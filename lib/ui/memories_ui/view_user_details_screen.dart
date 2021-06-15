import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_memory/Utility/Utility.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/Blog.dart';
import 'package:flutter_memory/models/nominee.dart';
import 'package:flutter_memory/models/user.dart' as User;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart' ;


// import 'package:downloads_path_provider/downloads_path_provider.dart';

class ViewUserDetailsScreen extends StatefulWidget {
  final User.User user;

  ViewUserDetailsScreen({Key key, @required this.user}) : super(key: key);

  @override
  ViewUserDetailsScreenState createState() => ViewUserDetailsScreenState(user);
}

class ViewUserDetailsScreenState extends State<ViewUserDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  User.User blog;
  bool _loading = false;
  List<Blog> blogList;
  List<Nominee> nominee1SelectedList;

  List<Blog> nominee1List = [];
  List<Blog> nominee2List = [];
  List<Blog> nominee3List = [];
  List<Blog> otherList = [];
  var storeDir,sourceDir;
  int _progress = 0;

  List<ImageData> imagesList = [];
  var pdfBuffer = new StringBuffer();
  var image;
  final List<File> files = [];
  final _appDataDir = Directory.systemTemp;
  var fileLenght = 0;

  bool isEmoji = false;
  ViewUserDetailsScreenState(this.blog);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("User Details", style: TextStyle(color: Colors.white)),

      ),
      body: Center(child: _buildForm(context)),
    );
  }

  Widget _progressIndicator() {
    if (_loading) {
      return new AlertDialog(

        elevation: 4,
        content: new Row(
          children: [
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),),
            Container(margin: EdgeInsets.only(left: 7),child:Text(_progress!=0 ?'Uploading Progress: $_progress %':"Creating Backup..." )),
          ],),
      );

    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {
    return new Container(

      height: MediaQuery.of(context).size.height,
      child: Stack(
        children:<Widget> [
          Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                    // BlogContentWidget(blog: blog),
                    Card(
                      margin: EdgeInsets.fromLTRB(2,12,0,12),
                      // margin: EdgeInsets.only(top:12.0) ,
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 16.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),

                            child: Text( blog != null && blog.userName != null ?blog.userName:""),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 16.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Contact Number',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Text( blog != null && blog.contactNumber != null ?
                            "\n" + blog.countryCode+" "+ blog.contactNumber: ""),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 16.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'User Id',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Text( blog != null && blog.id != null ? blog
                                .id : ""),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 16.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Date of Birth',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: Text( blog != null && blog.dob != null ? blog
                                .dob : "Not available"),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 16.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Disclosing Date',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0,bottom: 25.0),
                            child: Text( blog != null && blog.disclosingDate != null ? blog
                                .disclosingDate : "Not available"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0,bottom: 25.0),
                            child:Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  _showIndicator();
                                  getData();

                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orangeAccent,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.grey,
                                  padding: const EdgeInsets.all(0.0),
                                ),
                                child: Text(
                                  "Back Up",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Visibility(
                      visible: files.length>0 && files[0].path.isNotEmpty ? true : false,
                      child: Card(
                        margin: EdgeInsets.fromLTRB(2,12,0,12),
                        child: Column(
                          children: [
                            Text("Files Created : "),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: files.length,
                                itemBuilder: (context, index) {
                                  return new ListTile(
                                    title: new Text(files[index].path.split('/').last),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),

              ),
            ),
          ),

          Center(
              child: _progressIndicator()),
        ],
      ),
    );
  }

  Future<List<Blog>> fetchAllData() async {
   
    List<Blog> list = [];
    QuerySnapshot collectionSnapshot = await FirebaseFirestore.instance.collection(StringConstant.BLOGS).where(
        "authorId", isEqualTo: blog.id).get();

    list = collectionSnapshot.docs.map((DocumentSnapshot documentSnapshot) {

      return Blog.fromJson(documentSnapshot.data());
    }).toList();


    return list;
  }

  Future<List<Nominee>> fetchNominees() async {
    // final addRef = FirebaseFirestore.instance
    //     .collection(StringConstant.USER).document(blog.id).collection(
    //     StringConstant.NOMINEE).getDocuments();
    List<Nominee> list = [];
    QuerySnapshot collectionSnapshot = await FirebaseFirestore.instance
        .collection(StringConstant.USER).doc(blog.id).collection(
        StringConstant.NOMINEE).get().catchError((err) {
      print("Network error"+err.toString());
    });
    list = collectionSnapshot.docs.map((DocumentSnapshot documentSnapshot) {
      return Nominee.fromJson(documentSnapshot.data());
    }).toList();
    // await addRef.then((QuerySnapshot snapshot) {
    //   list = snapshot.documents.map((DocumentSnapshot documentSnapshot) {
    //     return Nominee.fromJson(documentSnapshot.data);
    //   }).toList();
    // });
    print(list.length);
    return list;
  }

  void createPdf(BuildContext context,List<Blog> nomList, String nomineeId) async {
    final pdf = pw.Document();
    // final Uint8List fontData = await File('OpenSans-Regular.ttf').readAsBytes();
    final fontData = await rootBundle.load('assets/fonts/OpenSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    // final imageData = await rootBundle.load('assets/fonts/NototColorEmoji.ttf');
    // final ttf1 = pw.Font.ttf(imageData.buffer.asByteData());

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    } else {
      for (Blog printblog in nomList) {
        pdf.addPage(
          pw.Page(
              build: (pw.Context context) {
                return pw.Container(

                    margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                    padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                    child: pw.Column(
                        children: [
                          pw.Text(printblog.content.title.replaceAll(RegExp(r'[^A-Za-z0-9().,;?""]'), ' '),textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(font: ttf,

                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),),
                          pw.SizedBox(height: 8),
                          pw.Container(
                              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm,left: 3.0 * PdfPageFormat.mm,right: 3.0 * PdfPageFormat.mm),
                              padding: const pw.EdgeInsets.all(4.0),
                              child:pw.Column(
                                children: [
                                  pw.Row(
                                    // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                      children: [
                                        pw.Text("User Id : ",style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 10,
                                        )),
                                        pw.Text(printblog.authorId,style: pw.TextStyle(
                                          fontSize: 10,
                                        )),
                                      ]
                                  ),
                                  pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                                  pw.Row(
                                    // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                      children: [
                                        pw.Text("Nominee 1 Name : ",style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 10,
                                        )),
                                        pw.Text(printblog.nominee != null &&
                                            printblog.nominee.nomineeName != null
                                            ? printblog.nominee.nomineeName
                                            : "Not selected",style: pw.TextStyle(fontSize: 10,)),
                                      ]
                                  ),
                                  pw.SizedBox(height: 8),
                                  pw.Row(
                                    // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                      children: [
                                        pw.Text("Nominee 2 Name : ",style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,fontSize: 10
                                        )),
                                        pw.Text(printblog.nominee2 != null &&
                                            printblog.nominee2.nomineeName != null
                                            ? printblog.nominee2.nomineeName
                                            : "Not selected",style: pw.TextStyle(fontSize: 10,)),
                                      ]
                                  ),
                      ],),
                                  pw.SizedBox(height: 8),
                                  pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Row(
                                          // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                            children: [
                                              pw.Text("Latitude : ",style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,fontSize: 10,
                                              )),
                                              pw.Text(printblog!=null && printblog.meta!=null && printblog.meta.blogLocation!=null && printblog.meta.blogLocation.latitude!=null?printblog.meta.blogLocation.latitude
                                                  .toString():"Not Available",style: pw.TextStyle(fontSize: 10,)),
                                            ]
                                        ),
                                        pw.Row(
                                          // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                            children: [
                                              pw.Text("Longitude : ",style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,fontSize: 10
                                              )),
                                              pw.Text(printblog!=null && printblog.meta!=null && printblog.meta.blogLocation!=null && printblog.meta.blogLocation.longitude!=null?printblog.meta.blogLocation
                                                  .longitude
                                                  .toString():"Not Available",style: pw.TextStyle(fontSize: 10,)),
                                            ]
                                        )
                                      ]
                                  ),
                                  pw.SizedBox(height: 8),
                                  pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Row(
                                          // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                            children: [
                                              pw.Text("Location : ",style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,fontSize: 10
                                              )),
                                              pw.Text(printblog!=null && printblog.meta!=null && printblog.meta.weather!=null && printblog.meta.weather.address!=null?printblog.meta.weather.address:"Not Available",style: pw.TextStyle(fontSize: 10,)),
                                            ]
                                        ),
                                        pw.Row(
                                          // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                            children: [
                                              pw.Text("Weather : ",style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,fontSize: 10
                                              )),
                                              pw.Text(printblog!=null && printblog.meta!=null && printblog.meta.weather!=null && printblog.meta.weather.tempCelsius!=null ?printblog.meta.weather.tempCelsius:"Not Available",style: pw.TextStyle(fontSize: 10,)),
                                            ]
                                        ),
                                      ]
                                  ),
                                  pw.SizedBox(height: 8),
                                  pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Row(
                                          // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                            children: [
                                              pw.Text("Cherished : ",style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,fontSize: 10
                                              )),
                                              pw.Text(printblog.isCherishedMemory
                                                  .toString(),style: pw.TextStyle(fontSize: 10,)),
                                            ]
                                        ),
                                        pw.Row(
                                          // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                            children: [
                                              pw.Text("Memory Date : ",style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,fontSize: 10
                                              )),
                                              pw.Text(printblog.selectedDate,style: pw.TextStyle(fontSize: 10,)),
                                            ]
                                        ),

                                      ]
                                  ),
                                ],),

                              decoration:pw.BoxDecoration(
                                border: pw.Border(top: pw.BorderSide(
                                  color: PdfColors.blueGrey900,
                                  width: .5,

                                ),
                                  bottom: pw.BorderSide(
                                    color: PdfColors.blueGrey900,
                                    width: .5,

                                  ),
                                  left: pw.BorderSide(
                                    color: PdfColors.blueGrey900,
                                    width: .5,

                                  ),
                                  right: pw.BorderSide(
                                    color: PdfColors.blueGrey900,
                                    width: .5,

                                  ),
                                ),
                              )
                          ),
                          pw.SizedBox(height: 8),

                          pw.Container(

                              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm,left: 3.0 * PdfPageFormat.mm,right: 3.0 * PdfPageFormat.mm),
                              padding: const pw.EdgeInsets.all(4.0),

                              child:pw.Column(

                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [

                                  pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                      children: [
                                        pw.Text("Memory",style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,fontSize: 10
                                        ),),

                                      ]
                                  ),

                                  pw.SizedBox(height: 8),
                                  // pw.Paragraph(text: parser.unemojify(printblog.content.body),textAlign: pw.TextAlign.justify,style: pw.TextStyle(fontSize: 10),),
                                  pw.Paragraph(text: printblog.content.body.replaceAll(RegExp(r'[^A-Za-z0-9().,;?""]'), ' '),textAlign: pw.TextAlign.justify,style: pw.TextStyle(font: ttf,fontSize: 10),),
                                  // pw.Paragraph(text: printblog.content.body.replaceAll(RegExp(r'[^A-Za-z0-9().,;?""]'), ' '),textAlign: pw.TextAlign.justify,style: pw.TextStyle(fontSize: 10),),


                                ],),

                              decoration:pw.BoxDecoration(
                                border: pw.Border(top: pw.BorderSide(
                                  color: PdfColors.blueGrey900,
                                  width: .5,

                                ),
                                  bottom: pw.BorderSide(
                                    color: PdfColors.blueGrey900,
                                    width: .5,

                                  ),
                                  left: pw.BorderSide(
                                    color: PdfColors.blueGrey900,
                                    width: .5,

                                  ),
                                  right: pw.BorderSide(
                                    color: PdfColors.blueGrey900,
                                    width: .5,

                                  ),
                                ),
                              )
                          ),
                          pw.SizedBox(height: 8),
                          pw.Center(child: pw.Image(getUrl(printblog.blogId), width: 400,
                            height: 150,)),

                          pw.SizedBox(height: 8),
                        ]

                    )
                );
              }
          ),

        );
      }
    }
    // final downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    final dir = await getExternalStorageDirectory();
    final String path = "${dir.path}/${nomineeId}.pdf";
    final file = File(path);

    if ((await file.exists())) {
      print("exist");
      if (file.existsSync()) {
        await file.writeAsBytes(await pdf.save()).whenComplete(() {
          _showIndicator();

        }).then((value) async {
          setState(() {
            files.add(file);
          });
          _showIndicator();

          print(files.length);
          print(fileLenght);
          if(files.length>0 && fileLenght>0 && files.length == fileLenght+1){
            sourceDir = await getExternalStorageDirectory();
            storeDir =
                Directory(_appDataDir.path + "/blogsData");
            if(files.length>0) {
              final zipFile = await _testZipFiles(includeBaseDirectory: false);
              if(zipFile.existsSync()){
                try {
                  ZipFile.createFromFiles(
                      sourceDir: sourceDir, files: files, zipFile: zipFile).then((value) async {
                    Reference ref = FirebaseStorage.instance.ref().child("user_account").child(blog.emailId).child(
                        "BACK_UP").child(Utility.getRandomString(4)+"-"+Utility.now()+".zip");


                    // await ref.putFile(zipFile)
                    //     .then((val) {
                    //
                    //   showSuccessDialog(context,true);
                    // });
                    UploadTask uploadTask = ref.putFile(zipFile);
                    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
                      print('Task state: ${snapshot.state}');
                      print(
                          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
                      if(snapshot.state == TaskState.success){
                        _progress=0;
                        showSuccessDialog(context,true);
                      }else
                        _progress = ((snapshot.bytesTransferred / snapshot.totalBytes) * 100).round();
                      setState(() {

                      });

                    }, onError: (e) {
                      print(uploadTask.snapshot);
                      showSuccessDialog(context,false);
                    });


                  });

                } catch (e) {

                  showSuccessDialog(context,false);
                  print(e);
                }
              }
            }
          }
        });
      }
    }

    else {
      // _showIndicator();
      // Fluttertoast.showToast(
      //
      //     msg: file. path.split('/').last+" error in creating pdf file",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.blueGrey,
      //     textColor: Colors.white
      // );
      print("not exist");
      file.create();
      await file.writeAsBytes(await pdf.save()).whenComplete(() {
      }).then((value) async {
        setState(() {
          files.add(file);
        });

      });
    }
  }

  Future<List<ImageData>> getImages(List<Blog> blogList) async {
    List<ImageData> list = [];
    for (Blog blog in blogList) {
      if (blog != null && blog.content != null &&
          blog.content.thumbnailUrl != null) {
        print(blog.content.thumbnailUrl);
        var imageProvider = NetworkImage(blog.content.thumbnailUrl);
        image = await flutterImageProvider(imageProvider);
      }
      else {
        const imageProvider = const AssetImage('images/icon.png');
        image = await flutterImageProvider(imageProvider);
      }
      ImageData img = new ImageData();
      img.url = image;
      img.blogId = blog.blogId;
      list.add(img);
    }
    return list;
  }

  pw.ImageProvider getUrl(String blogId) {
    var img;
    for (ImageData data in imagesList) {
      if (blogId == data.blogId) {
        img = data.url;
      }
    }
    return img;
  }

  Future<File> _testZipFiles({@required bool includeBaseDirectory}) async {

    final testFiles = _createTestFiles(storeDir);
    final zipFile = _createZipFile("testZipFiles.zip");
    try {
      await ZipFile.createFromFiles(
          sourceDir: storeDir,
          files: testFiles,
          zipFile: zipFile,
          includeBaseDirectory: includeBaseDirectory);
    } catch (e) {
      print(e);
    }
    return zipFile;
  }
  File _createZipFile(String fileName)  {

    final zipFilePath = _appDataDir.path + "/" + fileName;
    final zipFile = File(zipFilePath);

    if (zipFile.existsSync()) {
      print("Deleting existing zip file: " + zipFile.path);
      zipFile.deleteSync();
    }
    return zipFile;
  }
  List<File> _createTestFiles(Directory storeDir) {
    if (storeDir.existsSync()) {
      storeDir.deleteSync(recursive: true);
    }
    storeDir.createSync();
    final fileList = <File>[];
    for (int i = 0; i < files.length; i++) {
      final file = File(storeDir.path + "/"+ Utility.getRandomString(4)+"/.pdf" );
      file.createSync(recursive: true);
      print("Writing file: " + file.path);
      file.writeAsStringSync(files[i].path.split('/').last);
      fileList.add(file);
    }
    return fileList;
  }

  void getData() async {
    files.clear();
    if(blog!=null)createUserDataPdf(context,blog);
    fileLenght = 0;
    nominee1List.clear();
    nominee2List.clear();
    nominee3List.clear();
    otherList.clear();
    imagesList.clear();
    Future<List<Nominee>> _futureNomineeList = fetchNominees();
    nominee1SelectedList = await _futureNomineeList;
    Future<List<Blog>> _futureOfList = fetchAllData();
    blogList = await _futureOfList;

    if (blogList.length > 0) {
      Future<List<ImageData>> _futureOfImages = getImages(blogList);
      imagesList = await _futureOfImages;

      if (imagesList.length > 0) {
        for (Blog blog in blogList) {
          if (blog.nominee != null || blog.nominee2 != null ) {
            if (blog.nominee != null) {
              if (nominee1SelectedList.length > 0) {
                if (blog.nominee.nomineeId == nominee1SelectedList[0].nomineeId)
                  nominee1List.add(blog);
              }
              if (nominee1SelectedList.length > 1) {
                if (blog.nominee.nomineeId == nominee1SelectedList[1].nomineeId)
                  nominee2List.add(blog);
              }
              if (nominee1SelectedList.length > 2) {
                if (blog.nominee.nomineeId == nominee1SelectedList[2].nomineeId)
                  nominee3List.add(blog);
              }
            }
            if (blog.nominee2 != null) {
              if (nominee1SelectedList.length > 0) {
                if (blog.nominee2.nomineeId ==
                    nominee1SelectedList[0].nomineeId)
                  nominee1List.add(blog);
              }
              if (nominee1SelectedList.length > 1) {
                if (blog.nominee2.nomineeId ==
                    nominee1SelectedList[1].nomineeId)
                  nominee2List.add(blog);
              }
              if (nominee1SelectedList.length > 2) {
                if (blog.nominee2.nomineeId ==
                    nominee1SelectedList[2].nomineeId)
                  nominee3List.add(blog);
              }
            }
          }
          else {
            otherList.add(blog);
          }
        }
        print("List 1 " + nominee1List.length.toString());
        print("List 2 " + nominee2List.length.toString());
        print("List 3 " + nominee3List.length.toString());
        print("Others " + otherList.length.toString());

        if (nominee1List.length > 0 && imagesList.length > 0) {
          fileLenght++;
          try {
            createPdf(context,nominee1List, nominee1SelectedList[0].nomineeName);
            // createPdf(context,nominee1List, nominee1SelectedList[0].nomineeId+" Nominee 1");
          } catch (e) {
            print(e);
          }
        }
        if (nominee2List.length > 0 && imagesList.length > 0) {
          fileLenght++;
          try {
            imageCache.clear();
            Future<List<ImageData>> _futureOfImages = getImages(blogList);
            imagesList = await _futureOfImages;
            createPdf(context,nominee2List, nominee1SelectedList[1].nomineeName);
          } catch (e) {
            print(e);
          }
        }
        if (nominee3List.length > 0 && imagesList.length > 0) {
          fileLenght++;
          try {
            imageCache.clear();
            Future<List<ImageData>> _futureOfImages = getImages(blogList);
            imagesList = await _futureOfImages;
            createPdf(context,nominee3List, nominee1SelectedList[2].nomineeName);
          } catch (e) {
            print(e);
          }
        }

        if (otherList.length > 0) {
          fileLenght++;
          try {
            imageCache.clear();
            Future<List<ImageData>> _futureOfImages = getImages(blogList);
            imagesList = await _futureOfImages;
            createPdf(context,otherList, "Others");
          } catch (e) {
            print(e);
          }
        }
      }
    }else{
      // _showIndicator();
      Fluttertoast.showToast(

          msg: "No Blogs Written Yet",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white
      );
      print(files.length);
      if(files.length>0){
        sourceDir = await getExternalStorageDirectory();
        storeDir =
            Directory(_appDataDir.path + "/blogsData");
        if(files.length>0) {
          final zipFile = await _testZipFiles(includeBaseDirectory: false);
          if(zipFile.existsSync()){
            try {
              ZipFile.createFromFiles(
                  sourceDir: sourceDir, files: files, zipFile: zipFile).then((value) async {
                Reference ref = FirebaseStorage.instance.ref().child("user_account").child(blog.emailId).child(
                    "BACK_UP").child(Utility.getRandomString(4)+"-"+Utility.now()+".zip");


                // await ref.putFile(zipFile)
                //     .then((val) {
                //
                //   showSuccessDialog(context,true);
                // });
                UploadTask uploadTask = ref.putFile(zipFile);
                uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
                  print('Task state: ${snapshot.state}');
                  print(
                      'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
                  setState(() {

                    if(snapshot.state == TaskState.success){
                      _progress=0;
                      showSuccessDialog(context,true);
                    }else  _progress = ((snapshot.bytesTransferred / snapshot.totalBytes) * 100).round();
                  });

                }, onError: (e) {
                  print(uploadTask.snapshot);
                  showSuccessDialog(context,false);
                });

              });



            } catch (e) {

              showSuccessDialog(context,false);
              print(e);
            }
          }
        }
      }
    }
  }

  void _showIndicator() {
    setState(() {
      _loading = !_loading;
    });
  }
  showSuccessDialog(BuildContext context,bool status) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        _showIndicator();

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(status?"Success":"Error"),
      content: Text(status?"Back up taken Successfully":"Error in taking backup. Please press Back Up button once again"),
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
  Future<void> createUserDataPdf(BuildContext context, User.User user) async {
    auth.User userFire =  auth.FirebaseAuth.instance.currentUser;
    if (userFire != null && userFire.photoURL != null) {
      var imageProvider = NetworkImage(userFire.photoURL);
      image = await flutterImageProvider(imageProvider);
    }
    else {
      const imageProvider = const AssetImage('images/icon.png');
      image = await flutterImageProvider(imageProvider);
    }
    final pdf = pw.Document();

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    } else {

      pdf.addPage(

        pw.Page(
            build: (pw.Context context) {
              return pw.Container(
                  child: pw.Column(
                      children: [
                        pw.Text("Precious Memories - User Details",textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),),
                        pw.SizedBox(height: 8),

                        pw.Image(image, width: 150,
                          height: 80,),
                        pw.SizedBox(height: 8),
                        pw.Container(
                            padding: const pw.EdgeInsets.all(8.0),
                            child:pw.Column(
                              children: [
                                pw.Row(
                                    children: [
                                      pw.Text("User Id : ", style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold, fontSize: 10,
                                      )),
                                      pw.Text(user.id != null
                                          ? user.id
                                          : "",style: pw.TextStyle(   fontSize: 10, )),
                                    ]
                                ),
                                pw.SizedBox(height: 8),
                                pw.Row(
                                  // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                    children: [
                                      pw.Text("User Name : ",style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,fontSize: 10,
                                      )),
                                      pw.Text(user.userName,style: pw.TextStyle(   fontSize: 10, )),
                                    ]
                                ),
                                pw.SizedBox(height: 8),
                                pw.Row(
                                  // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                    children: [
                                      pw.Text("Contact Number: ",style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,fontSize: 10,
                                      )),
                                      pw.Text(user != null && user.contactNumber != null ?
                                      "\n" + user.countryCode+" "+ user.contactNumber: "",style: pw.TextStyle(   fontSize: 10, )),
                                    ]
                                ),
                                pw.SizedBox(height: 8),
                                pw.Row(
                                  // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                    children: [
                                      pw.Text("Date of Birth: ",style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,fontSize: 10,
                                      )),
                                      pw.Text(user != null && user.dob != null ? user
                                          .dob : "Not available",style: pw.TextStyle(   fontSize: 10, )),
                                    ]
                                ),
                                pw.SizedBox(height: 8),
                                pw.Row(
                                  // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                                    children: [
                                      pw.Text("Disclosing Date : ",style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,fontSize: 10,
                                      )),
                                      pw.Text(user != null && user.disclosingDate != null ? user
                                          .disclosingDate : "Not available",style: pw.TextStyle(   fontSize: 10, )),
                                    ]
                                ),
                              ],),

                            decoration:pw.BoxDecoration(
                              border: pw.Border(top: pw.BorderSide(
                                color: PdfColors.blueGrey900,
                                width: .5,

                              ),
                                bottom: pw.BorderSide(
                                  color: PdfColors.blueGrey900,
                                  width: .5,

                                ),
                                left: pw.BorderSide(
                                  color: PdfColors.blueGrey900,
                                  width: .5,

                                ),
                                right: pw.BorderSide(
                                  color: PdfColors.blueGrey900,
                                  width: .5,

                                ),
                              ),
                            )
                        ),
                        pw.SizedBox(height: 8),

                      ]

                  )
              );
            }
        ),
      );

    }

    final dir = await getExternalStorageDirectory();
    final String path = "${dir.path}/${user.userName}.pdf";
    final file = File(path);

    if ((await file.exists())) {
      print("exist");
      if (file.existsSync()) {
        await file.writeAsBytes(await pdf.save()).whenComplete(() {
        }).then((value) async {
          setState(() {
            files.add(file);
          });

        });
      }
    }

    else {
      // _showIndicator();
      // Fluttertoast.showToast(
      //
      //     msg: file. path.split('/').last+" error in creating pdf file",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.blueGrey,
      //     textColor: Colors.white
      // );
      print("not exist");
      file.create();
      await file.writeAsBytes(await pdf.save()).whenComplete(() {
      }).then((value) async {
        setState(() {
          files.add(file);
        });

      });

    }
  }
}
class ImageData {
  dynamic url;
  String blogId;

  ImageData({this.url, this.blogId});
}

