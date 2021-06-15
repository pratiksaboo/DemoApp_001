import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_memory/Utility/Utility.dart';
import 'package:flutter_memory/Utility/round_icon_button.dart';
import 'package:flutter_memory/app_localizations.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/Blog.dart';
import 'package:flutter_memory/models/BlogMeta.dart';
import 'package:flutter_memory/models/Gallery.dart';
import 'package:flutter_memory/models/WeatherData.dart';
import 'package:flutter_memory/models/nominee.dart';
import 'package:flutter_memory/routes.dart';
import 'package:flutter_memory/ui/memories_ui/view_image_file.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'image_view_screen.dart';


class EditBlogScreen extends StatefulWidget {
  final Blog blog;

  EditBlogScreen({Key key, @required this.blog}) : super(key: key);

  @override
  EditBlogScreenState createState() => EditBlogScreenState(blog);
}

class EditBlogScreenState extends State<EditBlogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Blog blog;
  File _image;
  var lat, lon;
  final Geolocator geolocator = Geolocator()
    ..forceAndroidLocationManager;
  WeatherData weatherData;
  String title;
  String blogMessage;
  bool _loading = false;
  List<Nominee> nomineeList;
  Nominee selectedNominee;
  Nominee selectedNominee2;
  BlogMeta meta;
  BlogLocation blogLocation;
  BlogContent content;
  String userId;
  String address;
  Weather weather;

  String thumbnailUrl ;
  bool isCherished= false;
  bool isLocation = false;
  bool isWeather = false;
  String _selectedDate;
  bool isThumbnail = false;
  bool deleteImage = false;
  bool changesMade = false;
  EditBlogScreenState(this.blog);

  final Set _saved = Set();

  List<Nominee> selectedNomineeList ;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _selectedDate = blog!=null && blog.selectedDate !=null ? blog.selectedDate: new DateFormat.yMMMMd("en_US").format(DateTime.now());
    if(blog!=null && blog.isCherishedMemory !=null)
    isCherished = blog.isCherishedMemory;
    nomineeMethod();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            if(changesMade)
            _onBackPressed();
            else    Navigator.of(context).pop();
          },
        ),
        title: Text(blog != null
            ? AppLocalizations.of(context).translate(
            "todosCreateEditAppBarTitleEditTxt")
            : AppLocalizations.of(context).translate(
            "todosCreateEditAppBarTitleNewTxt"),style: TextStyle(color: Colors.white)),
        actions: <Widget>[
        ],
      ),
      body: WillPopScope(
          onWillPop: changesMade ? _onBackPressed :() async => false, child: SafeArea(child: _buildForm(context))),
      // body: SafeArea(
      //   child: _buildForm(context),
      // ),

    );
  }

  Widget _progressIndicator() {
    if (_loading) {
     return new AlertDialog(
       elevation: 4,
        content: new Row(
          children: [
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),),
            Container(margin: EdgeInsets.only(left: 7),child:Text("Uploading..." )),
          ],),
      );

    } else {
      return Container();
    }
  }

  void _showIndicator() {
    setState(() {
      _loading = !_loading;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _openGallery(BuildContext context) async {
    File imageSelected;

    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile = await imagePicker.getImage(
      source: ImageSource.gallery,
      );
    if (pickedFile != null) {
      imageSelected = File(pickedFile.path);
      print("size");
      findScale(imageSelected);




      //
      // print(imageSelected.lengthSync());
      //   if(imageSelected.lengthSync()>125000) {
      //     _image = await testCompressAndGetFile(imageSelected);
      //   }else{
      //     _image = File(pickedFile.path);
      //   }
      //  setState(() {
      //   if (_image != null) {
      //     // _image = File(pickedFile.path);
      //     isThumbnail = false;
      //     print("size");
      //     print(_image.lengthSync());
      //     changesMade = true;
      //   }
      // });
    } else {
      print('No image selected.');
    }
    // setState(() {
    //   if (pickedFile != null) {
    //     _image = File(pickedFile.path);
    //     isThumbnail = false;
    //     print("size");
    //     print(_image.lengthSync());
    //     changesMade = true;
    //   } else {
    //     print('No image selected.');
    //   }
    // });
    Navigator.of(context).pop();
    // var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    // this.setState(() {
    //   _image = picture;
    //   isThumbnail = false;
    // });
    // ImagePicker imagePicker = ImagePicker();
    // PickedFile pickedFile = await imagePicker.getImage(
    //   source: ImageSource.gallery,
    //   imageQuality: 15,
    //   maxWidth: 800,
    //   maxHeight: 800,
    // );
    // setState(() {
    //   if (pickedFile != null) {
    //     _image = File(pickedFile.path);
    //     isThumbnail = false;
    //     print("size");
    //     print(_image.lengthSync());
    //     changesMade = true;
    //   } else {
    //     print('No image selected.');
    //   }
    // });
    // Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    File imageSelected;
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile = await imagePicker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      imageSelected = File(pickedFile.path);
      print("size");
      findScale(imageSelected);

      print('No image selected.');
    }
    Navigator.of(context).pop();
    // File imageSelected;
    // ImagePicker imagePicker = ImagePicker();
    // PickedFile pickedFile = await imagePicker.getImage(
    //   source: ImageSource.gallery,
    // );
    // if (pickedFile != null) {
    //   imageSelected = File(pickedFile.path);
    //   print("size");
    //   findScale(imageSelected);
    // // ImagePicker imagePicker = ImagePicker();
    // // PickedFile pickedFile = await imagePicker.getImage(
    // //   source: ImageSource.camera,
    // //   imageQuality: 15,
    // //   maxWidth: 800,
    // //   maxHeight: 800,
    // // );
    // // setState(() {
    // //   if (pickedFile != null) {
    // //     _image = File(pickedFile.path);
    // //     isThumbnail = false;
    // //     changesMade = true;
    // //     print("size");
    // //     print(_image.lengthSync());
    // //   } else {
    //     print('No image selected.');
    //   }
    // // });
    // Navigator.of(context).pop();
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Widget _buildForm(BuildContext context) {
    String thumbnail;

    title = widget.blog != null &&  widget.blog.content != null && widget.blog.content.title != null? widget.blog.content.title :"";
    blogMessage = widget.blog != null &&  widget.blog.content != null && widget.blog.content.body != null? widget.blog.content.body :"";
    if(blog != null && blog.content != null && blog.content.thumbnailUrl != null && _image == null){
      thumbnail = blog.content.thumbnailUrl;
      isThumbnail = true;
    }else{
      thumbnail = null;
      isThumbnail = false;
    }
    return new Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Stack(
          children:<Widget> [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: _formKey,
                child: GestureDetector(
                  child: Column(
                    verticalDirection: VerticalDirection.down,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Center(child: _progressIndicator()),
                      Flexible(child: calenderCarousalContainer(context),flex:2),
                      Flexible(child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),

                        child:
                        Card(
                          elevation: 2,
                          child: TextFormField(

                            textCapitalization: TextCapitalization.sentences,
                            initialValue: title,
                            onTap: () {
                              changesMade = true;
                            },
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2,
                            validator: (value) =>
                            value.isEmpty
                                ? AppLocalizations.of(context).translate(
                                "todosCreateEditTaskNameValidatorMsg")
                                : null,
                            onSaved: (value) {
                              title = value.trim();
                              print(title);
                              blog.content.title = title;
                              changesMade = true;
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width:0.0)),
                              contentPadding: const EdgeInsets.all(16.0),
                              // enabledBorder: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //         color: Theme
                              //             .of(context)
                              //             .iconTheme
                              //             .color, width: 2)),
                              labelText: AppLocalizations.of(context).translate(
                                  "todosCreateEditTaskNameTxt"),
                            ),
                          ),
                        ),
                      ),flex:2),
                      // Flexible(child: Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 0),
                      //   child: Card(
                      //     elevation: 2,
                      //     child: TextFormField(
                      //
                      //       keyboardType: TextInputType.multiline,
                      //       textInputAction: TextInputAction.newline,
                      //       textCapitalization: TextCapitalization.sentences,
                      //       initialValue: blogMessage,
                      //       onTap: () {
                      //         changesMade = true;
                      //       },
                      //
                      //       style: Theme
                      //           .of(context).textTheme.bodyText2,
                      //       maxLines: 10,
                      //       decoration: InputDecoration(
                      //         contentPadding: const EdgeInsets.all(8.0),
                      //
                      //         labelText: AppLocalizations.of(context).translate(
                      //             "todosCreateEditNotesTxt"),
                      //         alignLabelWithHint: true,
                      //
                      //       ),
                      //       validator: (value) =>
                      //       value.isEmpty
                      //           ? "Please enter message"
                      //           : null,
                      //       onSaved: (value) {
                      //         blogMessage = value.trim();
                      //         print(blogMessage);
                      //         blog.content.body = blogMessage;
                      //
                      //       },
                      //     ),
                      //   ),
                      // ),flex:2),
                      Flexible(child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: Card(
                          elevation: 2,
                          child: Container(

                            height: 200,
                            child: Theme(
                              data: ThemeData(
                                highlightColor: Colors.orange,       // Your color
                                platform: TargetPlatform.android,   // Specify platform as Android so Scrollbar uses the highlightColor
                              ),
                              child: Scrollbar(
                                isAlwaysShown: true,
                                controller: scrollController,
                                child: SingleChildScrollView(

                                  controller: scrollController,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: TextFormField(

                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      textCapitalization: TextCapitalization.sentences,
                                      initialValue: blogMessage,
                                      onTap: () {
                                        changesMade = true;
                                      },

                                      style: Theme
                                          .of(context).textTheme.bodyText2,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width:0.0)),
                                       contentPadding: const EdgeInsets.fromLTRB(16,4,0,0),

                                        labelText: AppLocalizations.of(context).translate(
                                            "todosCreateEditNotesTxt"),
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        alignLabelWithHint: true,

                                      ),
                                      validator: (value) =>
                                      value.isEmpty
                                          ? "Please enter message"
                                          : null,
                                      onSaved: (value) {
                                        blogMessage = value.trim();
                                        print(blogMessage);
                                        blog.content.body = blogMessage;

                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),flex:2),
                      // Flexible(child: titleContainer(context),flex:2),
                      // Flexible(child: messageBodyContainer(context),flex:2),
                      Flexible(
                        flex:2,
                        child: WeatherLocationWidget(blog: blog),),
                     Flexible (
                      flex: 3,
                      child: Visibility(
                        visible: thumbnail !=null || _image!=null ? true : false,
                        child: Card(
                          elevation: 2,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    if(thumbnail !=null && isThumbnail)
                                      Visibility(
                                        visible: isThumbnail,
                                        child: Center(
                                          child: new InkWell(
                                              child:  Image.network(thumbnail, fit: BoxFit.cover)
                                          ),
                                        ),
                                      ),
                                    Visibility(
                                      visible: _image!=null? true : false,
                                      child: Center(
                                        child: new InkWell(
                                            child: _image != null ? new Image.file(
                                              _image,
                                              height: 80.0,
                                              width: 80.0,
                                            ) : new Image.asset(
                                              'images/icon.png',
                                              height: 00.0,
                                              width: 00.0,
                                              fit: BoxFit.fill,
                                            )

                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex:3 ,
                                     child: Padding(
                                       padding: const EdgeInsets.only(left:14.0),
                                       child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              ElevatedButton(

                                                  child: Text( "View",
                                                    style: TextStyle(color:Colors.white,),
                                                  ),
                                                  onPressed: ()  {
                                                   if(!deleteImage) {
                                                     if(thumbnail != null)
                                                     Navigator.push(context,
                                                       new MaterialPageRoute(
                                                         builder: (context) {
                                                           return ViewImageScreen(
                                                               gallery: thumbnail);
                                                         },
                                                       ),
                                                     );
                                                     else if(_image != null) Navigator.push(context,
                                                       new MaterialPageRoute(
                                                         builder: (context) {
                                                           return ViewImageFileScreen(
                                                               gallery: _image);
                                                         },
                                                       ),
                                                     );
                                                   }
                                                  }),
                                              ElevatedButton(
                                                  child: Text( "Delete",
                                                    style: TextStyle(color:Colors.white,),
                                                  ),
                                                  onPressed: ()  {

                                                    if(blog.content.thumbnailUrl !=null){
                                                      warnDeleteDialog();

                                                    }
                                                    // changesMade = true;
                                                  }),
                                              ]
                                        ),
                                     ),
                                    ),
                                    ]
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                      Expanded(child: roundButtonContainer(context),flex:1),
                      Expanded(
                        flex:1,
                        child: Container(
                          margin: EdgeInsets.only(top: 8),
                            height: 50,
                            width: double.infinity,
                            child: SizedBox(
                              child: ElevatedButton(
                                onPressed: () {
                                  _formKey.currentState.save();
                                  print(title);
                                  print(blogMessage);

                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orangeAccent,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.grey,
                                  padding: const EdgeInsets.all(8.0),
                                ),
                                child: Text(
                                  "UPDATE",
                                ),
//                          shape: OutlineInputBorder(
//                              borderRadius: BorderRadius.circular(10)),
                              ),
                            )
                          // This align moves the children to the bottom
                        ),
                      ),
                    ],
                  ),onTap: (){
                  FocusScope.of(context).unfocus();
                  // _focusNode = FocusNode();
                  // _focusNode.unfocus();
                },
                ),

              ),
            ),
            Center(child: _progressIndicator()),
          ],

        ),
      ),
    );
  }
  Row roundButtonContainer(BuildContext context) {
    return Row( mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new RoundIconButton(
          onPressed: () {},
          icon: Icons.location_off,
          color:Colors.grey,
        ),
        new RoundIconButton(
          onPressed: () {},
          icon: Icons.cloud_off,
          color:Colors.grey,
        ),
        new RoundIconButton(
          onPressed: () {
            _selectNomineeDialog();
          },
          icon: Icons.person_add,
          color:Colors.orangeAccent,
        ),
        RoundIconButton(
          icon: Icons.attach_file,
          color:Colors.orangeAccent,
          onPressed: () {
            _showSelectionDialog(context);
          },
        ),
      ],
    );
  }
  ButtonBarTheme buttonBarContainer(BuildContext context) {
    return new ButtonBarTheme(
                      data: ButtonBarThemeData(
                          alignment: MainAxisAlignment.center),
                      child: new ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[


                          new ElevatedButton(
                              onPressed: () {},
                              child:  Icon(Icons.location_off,color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                              ),
                            // color: Colors.grey
                          ),
                          new ElevatedButton(
                              onPressed: () {},
                              child:  Icon(Icons.cloud_off,color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                              ),
                            // color: Colors.grey
                          ),
                          new ElevatedButton(
                              onPressed: () {
                                _selectNomineeDialog();
                              },
                              child: new Icon(Icons.person_add,color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orangeAccent,
                              ),
                            // color: Colors.orangeAccent
                          ),
                          new ElevatedButton(
                            onPressed: () {
                              _showSelectionDialog(context);
//                              getImage();
                            },
                            child: new Icon(Icons.attach_file,color: Colors.white),
                            style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
      ),
                          ),
                        ],
                      ),
                    );
  }

  Padding messageBodyContainer(BuildContext context) {
    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Card(
                        elevation: 2,
                        child: TextFormField(
                          textInputAction: TextInputAction.newline ,
                          textCapitalization: TextCapitalization.sentences,
                          initialValue: blogMessage,

                          style: Theme
                              .of(context).textTheme.bodyText2,
                          maxLines: 10,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width:0.0)),
                            contentPadding: const EdgeInsets.all(16.0),

                            labelText: AppLocalizations.of(context).translate(
                                "todosCreateEditNotesTxt",),
                            labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                            alignLabelWithHint: true,

                          ),
                          validator: (value) =>
                          value.isEmpty
                              ? "Please enter message"
                              : null,
                          onSaved: (value) {
                            blogMessage = value.trim();
                          },
                        ),
                      ),
                    );
  }

  Padding titleContainer(BuildContext context) {
    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),

                      child:
                      Card(
                        elevation: 2,
                        child: TextFormField(

                          textCapitalization: TextCapitalization.sentences,
                          initialValue: title,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyText2,
                          validator: (value) =>
                          value.isEmpty
                              ? AppLocalizations.of(context).translate(
                              "todosCreateEditTaskNameValidatorMsg")
                              : null,
                          onSaved: (value) {
                            title = value.trim();
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16.0),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width:0.0)),

                            labelText: AppLocalizations.of(context).translate(
                                "todosCreateEditTaskNameTxt"),
                          ),
                        ),
                      ),
                    );
  }
  Container calenderCarousalContainer(BuildContext context) {
    var buffer = new StringBuffer();
    String m;
    String n;
    if(selectedNominee == null){
      if(blog != null && blog.nominee != null && blog.nominee.nomineeName != null){
        selectedNominee = blog.nominee;
        List<String> str = blog.nominee.nomineeName.split(' ');
        m = str[0];
        buffer.write(m);
      }
      if(blog != null && blog.nominee2 != null && blog.nominee2.nomineeName != null){
        selectedNominee2 = blog.nominee2;
        List<String> str = blog.nominee2.nomineeName.split(' ');
        n = str[0];
        buffer.write(" and ");
        buffer.write(n);
      }

    }else {
      if (selectedNominee != null && selectedNominee.nomineeName != null) {
        List<String> str = selectedNominee.nomineeName.split(' ');
        m = str[0];
        buffer.write(m);
      }
      if (selectedNominee2 != null && selectedNominee2.nomineeName != null) {
        List<String> str = selectedNominee2.nomineeName.split(' ');
        n = str[0];
        buffer.write(" and ");
        buffer.write(n);
      }
    }
    // String _nomineeName;
    // if(selectedNominee == null) {
    //   _nomineeName =
    //   blog != null && blog.nominee != null && blog.nominee.nomineeName != null
    //       ?  blog.nominee.nomineeName
    //       : "";
    // }else
    //   _nomineeName = selectedNominee != null && selectedNominee.nomineeName != null? selectedNominee.nomineeName:"";

    // String _nomineeName;
    // if(selectedNominee == null) {
    //   _nomineeName =
    //   blog != null && blog.nominee != null && blog.nominee.nomineeName != null
    //       ?  blog.nominee.nomineeName
    //       : "";
    // }else
    //   _nomineeName = selectedNominee != null && selectedNominee.nomineeName != null? selectedNominee.nomineeName:"";
    return Container(
        child: Card(
          margin: EdgeInsets.fromLTRB(2,12,0,12),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2,2,0,4),
            child: Flexible(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2,8,0,8),
                      child: new Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          color: Colors.orange,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left:12.0),
                          child: Row(

                              children: [
                                InkWell(
                                  child: Text(
                                      _selectedDate,
                                      style: TextStyle(
                                          color: Colors
                                              .white,
                                          fontSize: 12.0)
                                  ),
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                      Icons.calendar_today,color: Colors.white,size: 12),
                                  tooltip: 'Tap to open date picker',
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                ),
                              ]),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: getIcon(),

                      onPressed: () {
                        setState(() {
                          // isCherished = !isCherished;
                          changesMade = true;
                          isCherished = !isCherished;
                          String message;
                          message = isCherished ? "Memory is Cherished": "Memory is uncherished";
                          Fluttertoast.showToast(
                              msg: message,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blueGrey,
                              textColor: Colors.white
                          );
                        }
                        );
                      },
                    ),


                    Flexible(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8),
                          child:
                          Text( buffer != null && buffer.isNotEmpty ? "Writing For " + buffer.toString():"",
                          // Text(_nomineeName.trim().isNotEmpty ? "Writing For $_nomineeName" : "",
                            style: TextStyle(
                                color: Colors.deepOrangeAccent,
                                fontSize: 16.0
                            ),)),
                    )
                  ]
              ),
            ),
          ),
        ));
  }
  // Container calenderCarousalContainer(BuildContext context) {
  //
  //   String _nomineeName;
  //   if(selectedNominee == null) {
  //     _nomineeName =
  //     blog != null && blog.nominee != null && blog.nominee.nomineeName != null
  //         ?  blog.nominee.nomineeName
  //         : "";
  //   }else
  //     _nomineeName = selectedNominee != null && selectedNominee.nomineeName != null? selectedNominee.nomineeName:"";
  //   return Container(
  //
  //                       child: Card(
  //                         margin: EdgeInsets.fromLTRB(2,12,0,12),
  //                         elevation: 4,
  //                         child: Padding(
  //                             padding: const EdgeInsets.fromLTRB(0,2,0,4),
  //                             child: Row(
  //                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                                 children: <Widget>[
  //                                   Padding(
  //                                     padding: const EdgeInsets.fromLTRB(2,8,0,8),
  //                                     child: new Container(
  //
  //                                       decoration: BoxDecoration(
  //                                         borderRadius: BorderRadius.circular(24.0),
  //                                         color: Colors.orange,
  //                                       ),
  //
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.only(left:4.0),
  //                                         child: Row(
  //
  //                                             children: [
  //                                               InkWell(
  //                                                 child: Text(
  //                                                     _selectedDate,
  //
  //                                                     style: TextStyle(
  //                                                         color: Colors
  //                                                             .white,
  //                                                         fontSize: 10.0)
  //                                                 ),
  //                                                 onTap: () {
  //                                                   _selectDate(context);
  //                                                 },
  //                                               ),
  //                                               IconButton(
  //                                                 icon: Icon(
  //                                                     Icons.calendar_today,color: Colors.white,size: 14,),
  //                                                 tooltip: 'Tap to open date picker',
  //                                                 onPressed: () {
  //                                                   _selectDate(context);
  //                                                 },
  //                                               ),
  //                                             ]),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   IconButton(
  //
  //                                     icon: getIcon(),
  //                                     onPressed: () {
  //
  //                                       setState(() {
  //                                         isCherished = !isCherished;
  //                                       }
  //                                       );
  //                                     },
  //                                   ),
  //
  //
  //                                   Flexible(
  //                                     child: Padding(
  //                                         padding: const EdgeInsets.symmetric(
  //                                             horizontal: 8),
  //                                         child:
  //                                         Text(_nomineeName.trim().isNotEmpty ? "Writing For $_nomineeName" : "",
  //                                         //   blog!=null && blog.nominee !=null && blog.nominee.nomineeName!=null ?"Writing For " + blog.nominee.nomineeName:
  //                                         // selectedNominee != null && selectedNominee.nomineeName != null? "Writing For " + selectedNominee.nomineeName:"",
  //                                           style: TextStyle(
  //                                               color: Colors.deepOrangeAccent,
  //                                               fontSize: 16.0
  //                                           ),)
  //                                         // Text(blog!=null && blog.nominee !=null && blog.nominee.nomineeName!=null ?"Writing For " + blog.nominee.nomineeName:
  //                                         //   selectedNominee != null && selectedNominee.nomineeName != null? "Writing For " + selectedNominee.nomineeName:"",
  //                                         //   style: TextStyle(
  //                                         //       color: Colors.deepOrangeAccent,
  //                                         //       fontSize: 16.0
  //                                         //   ),)
  //                                     ),
  //                                   )
  //                                 ]
  //                             )),
  //                       ));
  // }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // firstDate: DateTime.now().subtract(Duration(days: 0)),
      firstDate: DateTime(2020),
      lastDate: DateTime(2120),

      builder: (context, child) {
        return Theme(
//          data: ThemeData.from(
//            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),
//          ),
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),

          ),
//          data: ThemeData.light(),
          // This will change to light theme.
          child: child,
        );
      },
    );
    if (picked != null && picked.toString() != _selectedDate)
      setState(() {
        _selectedDate = new DateFormat.yMMMMd("en_US").format(picked);
        changesMade = true;
      });
  }
  Future<String> _selectNomineeDialog() async {
    _saved.clear();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState2) {
              return AlertDialog(

                title: Text('Select Nominee'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () {
                      print(_saved);
                      if(_saved.length>2)
                        Fluttertoast.showToast(
                            msg: 'Please select only two nominees' ,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white
                        );
                      else{
                        selectedNomineeList =  List<Nominee>.empty(growable: true);
                        // selectedNomineeList =  List<Nominee>();
                        setState(() {
                          if(_saved.length>0 )
                          {
                            selectedNominee = null;
                            selectedNominee2 = null;
                            if(nomineeList[_saved.elementAt(0)]!=null )selectedNominee = nomineeList[_saved.elementAt(0)];
                            if(_saved.length>1 && nomineeList[_saved.elementAt(1)]!=null )selectedNominee2 = nomineeList[_saved.elementAt(1)];
                            if(selectedNominee!=null) print(selectedNominee.nomineeName);
                            if(selectedNominee2!=null)  print(selectedNominee2.nomineeName);
                          }
                          // for(int i=0; i<_saved.length;i++)
                          // {
                          //   selectedNomineeList.add(nomineeList[_saved.elementAt(i)]);
                          // }
                          // if(selectedNomineeList!=null)
                          //
                          //   for(int i=0; i<selectedNomineeList.length;i++)
                          //   {
                          //     print(selectedNomineeList[i].nomineeName);
                          //   }

                        });
                      }

                      Navigator.pop(context);


                    },
                    child: Text('OK'),
                  ),
                ],
                content: Container(
                  width: double.minPositive,
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: nomineeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(nomineeList[index].nomineeName),
                        checkColor: Colors.deepOrange,
                        value: _saved.contains(index),
                        onChanged: (val) {
                          setState2(() {
                            if(val == true){
                              _saved.add(index);
                            } else{
                              _saved.remove(index);
                            }
                          });
                        },

                      );

                    },
                  ),
                ),
              );
            },
          );
        });
  }

  // Future<String> _selectNomineeDialog() async {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(
  //           builder: (context, setState2) {
  //             return AlertDialog(
  //
  //               title: Text('Select Nominee'),
  //               actions: <Widget>[
  //                 FlatButton(
  //                   onPressed: () {
  //
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('CANCEL'),
  //                 ),
  //                 FlatButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       selectedNominee = nomineeList[_currentIndex];
  //                       print(selectedNominee.nomineeName);
  //                       changesMade = true;
  //                     });
  //                     Navigator.pop(context, _currentIndex.toString());
  //
  //                   },
  //                   child: Text('OK'),
  //                 ),
  //               ],
  //               content: Container(
  //                 width: double.minPositive,
  //                 height: 300,
  //                 child: ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: nomineeList.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     return RadioListTile(
  //                       value: index,
  //                       groupValue: _currentIndex,
  //                       title: Text(nomineeList[index].nomineeName),
  //                       onChanged: (val) {
  //                         setState2(() {
  //                           _currentIndex = val;
  //
  //                           print(_currentIndex);
  //                         });
  //                       },
  //                     );
  //                   },
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       });
  // }

  Future<List<Nominee>> _fetchData() async {
    String userId;

    final auth.User user = auth.FirebaseAuth.instance.currentUser;
    userId = user.uid;
    final addRef = FirebaseFirestore.instance
        .collection(StringConstant.USER).doc(userId)
        .collection(StringConstant.NOMINEE)
        .get();

    List<Nominee> list = [];
    await addRef.then((QuerySnapshot snapshot) {
      list = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
        return Nominee.fromJson(documentSnapshot.data());
      }).toList();
    });
    return list;
  }

  void nomineeMethod() async {
    Future<List<Nominee>> _futureOfList = _fetchData();
    nomineeList = await _futureOfList;
    if (nomineeList.length > 0)
      for (int i = 0; i < nomineeList.length; i++) {
        Nominee nominees = nomineeList[i];
        print(nominees.nomineeName);
      }
  }


  warnDeleteDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Image?'),
            content: Text('Are you sure of deleting image?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);




                },
              ),
            ],
          );
        });
  }
  showAlertDialog(BuildContext context, bool status) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.of(context).pushNamed(Routes.home,
        );
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



  getIcon() {

    if (isCherished)
      return Icon(Icons.star,size: 34.0);
    else
      return Icon(Icons.star_border,size: 34.0);
  }





  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Save Changes?'),
            content: Text('Do you want to save the changes?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  _formKey.currentState.save();
                  print(title);
                  print(blogMessage);

                },
              ),
            ],
          );
        });
  }



  Future<File> testCompressAndGetFile(File file, int width, int height) async {
    final filePath = file.absolute.path;

    // Create output file path
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    print("testCompressAndGetFile");
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 80,
      minWidth: width,
      minHeight: height,
      // rotate: 90,
      keepExif: true,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }



  double calcScale({
    double srcWidth,
    double srcHeight,
    double minWidth,
    double minHeight,
  }) {
    var scaleW = srcWidth / minWidth;
    var scaleH = srcHeight / minHeight;

    var scale = math.max(1.0, math.min(scaleW, scaleH));

    return scale;
  }

  Future<void> findScale(File imageSelected) async {

    var decodedImage = await decodeImageFromList(imageSelected.readAsBytesSync());
    print(decodedImage.width);
    print(decodedImage.height);

    var scale = calcScale(
      srcWidth: decodedImage.width.toDouble(),
      srcHeight: decodedImage.height.toDouble(),
      minWidth: 1920,
      minHeight: 1080,
    );
    double targetWidth = decodedImage.width / scale ;
    double targetHeight = decodedImage.height / scale ;
    print("targetHeight = $targetHeight");
    print("targetWidth = $targetWidth");

    print("scale = $scale");
    print("target width = ${decodedImage.width / scale}, height = ${decodedImage.height / scale}");

if(scale>1) {
  _image = await testCompressAndGetFile(
      imageSelected, targetWidth.toInt(), targetHeight.toInt());
}else{
    _image = imageSelected;}
    if(_image !=null && _image.lengthSync()/1000 < 200 ){
      setState(() {
        if (_image != null) {
          isThumbnail = false;
          print("size");
          print(_image.lengthSync()/1000);

        }
      });

    }else {
      _image = await testCompressAndGetFile(imageSelected, 400, 400);
      print("size");
      print(_image.lengthSync()/1000);
      setState(() {
        if (_image != null) {
          isThumbnail = false;
          print("size");
          print(_image.lengthSync()/1000);

        }
      });
    }
    // setState(() {
    //   if (_image != null) {
    //     isThumbnail = false;
    //     print("size");
    //     print(_image.lengthSync());
    //     changesMade = true;
    //   }
    // });
  }


}

class WeatherLocationWidget extends StatelessWidget {
  const WeatherLocationWidget({
    Key key,
    @required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible:  blog != null &&  (blog.meta != null && blog.meta.weather != null && blog.meta.weather.address != null) ? true : false,
        child: Card(

          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children:<Widget>[

        Visibility(
          visible: blog != null && blog.meta != null && blog.meta.weather != null&& blog.meta.weather.address != null ? true : false,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text( blog != null && blog.meta != null && blog.meta.weather != null&& blog.meta.weather.address != null? "Location "+blog.meta.weather.address:""),
          ),
        ),
        Visibility(
          visible: blog != null && blog.meta != null && blog.meta.weather != null && blog.meta.weather.tempCelsius  != null ? true : false,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text( blog != null && blog.meta != null && blog.meta.weather != null&& blog.meta.weather.tempCelsius != null? "Weather "+blog.meta.weather.tempCelsius:""),
          ),
        ),
      ]  ),),);
  }
}
