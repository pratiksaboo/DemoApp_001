import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_memory/Utility/Utility.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share/share.dart';


int _progress = 0;
bool _isVisible = false;

class ViewImageScreen extends StatefulWidget {
  // final Gallery gallery;
  final String gallery;

  ViewImageScreen({Key key,  @required this.gallery}) : super(key: key);

  @override
  _ViewImageScreenState createState() => _ViewImageScreenState(gallery);
}

class _ViewImageScreenState extends State<ViewImageScreen> with SingleTickerProviderStateMixin{
  // Gallery gallery;
  String gallery;
  Animation<double> _animation;
  AnimationController _animationController;
  var path;

  _ViewImageScreenState(this.gallery);

  @override
  void initState(){

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    ImageDownloader.callback(onProgressUpdate: (String imageId, int progress) {
      setState(() {
        _progress = progress;
      });
    });
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Image",style: TextStyle(color: Colors.white)),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        //Init Floating Action Bubble
        floatingActionButton: FloatingActionBubble(
          // Menu items
          items: <Bubble>[

            // Floating action menu item
            Bubble(
              title:"Save",
              iconColor :Colors.white,
              bubbleColor : Colors.orangeAccent,
              icon:Icons.file_download,
              titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
              onPress: () {
                _animationController.reverse();
                _downloadImage();


              },
            ),
            // Floating action menu item
            Bubble(
              title:"Share",
              iconColor :Colors.white,
              bubbleColor : Colors.orangeAccent,
              icon:Icons.share,
              titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
              onPress: () {
                _animationController.reverse();
                _shareImageFromUrl();
              },
            ),

          ],

          // animation controller
          animation: _animation,

          // On pressed change animation state
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),

          // Floating Action button Icon color
          iconColor: Colors.orangeAccent,

          // Flaoting Action button Icon
          icon: AnimatedIcons.add_event,
        ),
//        floatingActionMenu(animationController: _animationController, animation: _animation),
     body:  Center( child: _buildForm(context) ),
    );
  }
  Widget _buildForm(BuildContext context) {

    return Center(
      child: Container(
        height:  MediaQuery.of(context).size.height,

        child: Stack(
          children: <Widget>[
            Center(

              child: Hero(
                tag: gallery,
                child: Container(
                  padding: EdgeInsets.all(50),

                  // child: PinchZoomImage(
                  //   image: Image.network(gallery),
                  //   zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                  //   hideStatusBarWhileZooming: true,
                  //
                  // ),

                  child: PhotoView(
                    imageProvider:NetworkImage(gallery) ,
                    maxScale: 2.5,
                    minScale: 0.5,
                    backgroundDecoration: BoxDecoration(color: Colors.transparent),
                  ),
                  // decoration: BoxDecoration(

                    // image: DecorationImage(
                    //   image:NetworkImage(gallery) ,
                    //
                    //   fit: BoxFit.scaleDown,
                    // ),
                  //   borderRadius:
                  //   BorderRadius.all(Radius.circular(20.0),),
                  //   color: Color.fromRGBO(240, 240, 240, 1.0),
                  // ),
                ),
              ),
            ),
            Center(
              child: Visibility(
                visible: _isVisible,
                child: Container(
                  color: Colors.white,
                  child: Padding(

                    padding: const EdgeInsets.all(12.0),
                    child: Text('Progress: $_progress %',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.red)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }

  Future<void> _downloadImage() async {
    _isVisible = true;
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }else{
      try {
        // Saved with this method.
        // var imageId = await ImageDownloader.downloadImage(gallery,destination:AndroidDestinationType.directoryDownloads..inExternalFilesDir()..subDirectory("MemoryImages/"+Utility.getRandomString(3)+".jpg"));
        var imageId = await ImageDownloader.downloadImage(gallery,destination:AndroidDestinationType.directoryDownloads..subDirectory("MemoryImages/"+Utility.getRandomString(3)+".jpg"));
        if (imageId == null) {
          print("Image null");
          return;
        }

        // Below is a method of obtaining saved image information.
        // var fileName = await ImageDownloader.findName(imageId);
        var path = await ImageDownloader.findPath(imageId);
        // var size = await ImageDownloader.findByteSize(imageId);
        // var mimeType = await ImageDownloader.findMimeType(imageId);
        print(path);

        setState(() {
          _isVisible = false;
          showAlertDialog(context,true);
        });

      } on PlatformException catch (error) {
        print(error);
        showAlertDialog(context,false);
      }
    }

  }

  showAlertDialog(BuildContext context, bool status) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(status ? "Success" : "Error"),
      content: Text(status
          ? "Saved Successfully"
          : "Error in Saving. Please try again later"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _shareImageFromUrl() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }else{
      try {
        // Saved with this method.

        var imageId = await ImageDownloader.downloadImage(gallery,destination:AndroidDestinationType.directoryDownloads..subDirectory("SentMemoryImages/"+Utility.getRandomString(3)+".jpg"));
        if (imageId == null) {
          print("Image null");
          return;
        }

        // Below is a method of obtaining saved image information.
        // var fileName = await ImageDownloader.findName(imageId);
        var path = await ImageDownloader.findPath(imageId);
        // var size = await ImageDownloader.findByteSize(imageId);
        // var mimeType = await ImageDownloader.findMimeType(imageId);
        print("File path");
        print(path);

        if(path!=null){
          Share.shareFiles(['$path'], text: '');
        }


      } on PlatformException catch (error) {
        print(error);
        showAlertDialog(context,false);
      }
    }

  }
}
