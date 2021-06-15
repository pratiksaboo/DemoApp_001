import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/Agreements.dart';


class ViewInformationScreen extends StatefulWidget  {
  final String title;
  final Agreements agreementDoc;

  ViewInformationScreen({Key key, @required this.title, this.agreementDoc}) : super(key: key);

  @override
  ViewBlogScreenState createState() => ViewBlogScreenState(title,agreementDoc);
}

class ViewBlogScreenState extends State<ViewInformationScreen>  {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Agreements agreementDoc;
  String title;
  InAppWebViewController webViewController;

  String htmlFilePath = 'assets/manual.html';
  String url = "";

  ViewBlogScreenState(this.title, this.agreementDoc);

  @override
  void initState() {
    super.initState();
    // getTitle(title);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(getTitle(title),style:TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white)),
      ),
      body: (title != "HELP_CENTER") ? Center(

        child: _buildForm(context),
      ): Center(

        child: _buildWeb(context),
      ),


    );
  }


  @override
  void dispose() {

    super.dispose();
  }

  Widget _buildWeb(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),

      child: InAppWebView(
        initialFile: htmlFilePath,
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            // debuggingEnabled: true,
          )),
      onWebViewCreated: (InAppWebViewController controller) {
        webViewController = controller;
      },
      )
      // child:InAppWebView(
      //
      //   initialFile: htmlFilePath,
      //   // initialHeaders: {},
      //   initialOptions: InAppWebViewGroupOptions(
      //       crossPlatform: InAppWebViewOptions(
      //         // debuggingEnabled: true,
      //       )),
      //   onWebViewCreated: (InAppWebViewController controller) {
      //     webViewController = controller;
      //   },
      //   onLoadStart: (InAppWebViewController controller, String url) {
      //     setState(() {
      //       this.url = url;
      //     });
      //   },
      //   onLoadStop:
      //       (InAppWebViewController controller, String url) async {
      //     setState(() {
      //       this.url = url;
      //     });
      //   },
      //   onProgressChanged:
      //       (InAppWebViewController controller, int progress) {
      //     // setState(() {
      //     //   this.progress = progress / 100;
      //     // });
      //   },
      // ),

    );
  }
  Widget _buildForm(BuildContext context) {
    return FutureBuilder <Agreements>(
        future: fetchAgreement(),
        builder:(context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),));
          agreementDoc = snapshot.data;

          return    Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        verticalDirection: VerticalDirection.down,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Center(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text( agreementDoc != null && agreementDoc.title != null ? agreementDoc.title:"",style: TextStyle(fontSize: 18.0,
                                    fontWeight: FontWeight.bold,  color: Colors.black87),textAlign: TextAlign.justify,),
                              ),

                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text( agreementDoc != null && agreementDoc.description != null ? agreementDoc.description.replaceAll("/n","\n"):"",style: TextStyle(fontSize: 18.0,
                                  fontWeight: FontWeight.normal,  color: Colors.black87,
                                  height: 1.5 ,// the height between text, default is null
                                  letterSpacing: 1.0 ),textAlign: TextAlign.justify,),
                            ),

                          ),




                        ],
                      ),
                    ),
                  ),
                ),

              ] )
          ;
        }
    );
  }

  Future<Agreements> fetchAgreement() async {

    final addRef = FirebaseFirestore.instance.collection(StringConstant.APP_SETTING).doc(title).get();
    final agreementTable =  await addRef.then((agreement1) {
      return Agreements.fromJson(agreement1.data());
    });
    return agreementTable;
  }

  String getTitle(String title) {
    String title1;
    switch(title)
    {
      case "HELP_CENTER" : title1= "Help Center";
      break;
      case "PRIVACY_POLICY" : title1= "Privacy Policy";
      break;
      case "TC_USER_AGREEMENT" : title1= "Terms And Conditions";
      break;
      default: title1 = "Help" ;
    }
    return title1;
  }

  // loadLocalHTML() async{
  //
  //   String fileHtmlContents = await rootBundle.loadString(htmlFilePath);
  //   webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
  //       )
  //       .toString());
  //
  //   // webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
  //   //     mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //   //     .toString());
  // }

}

// import 'dart:core';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_memory/constants/string.dart';
// import 'package:flutter_memory/models/Agreements.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// class ViewInformationScreen extends StatefulWidget {
//   final String title;
//   final Agreements agreementDoc;
//
//   ViewInformationScreen({Key key, @required this.title, this.agreementDoc}) : super(key: key);
//
//   @override
//   ViewBlogScreenState createState() => ViewBlogScreenState(title,agreementDoc);
// }
//
// class ViewBlogScreenState extends State<ViewInformationScreen> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   Agreements agreementDoc;
//   String title;
//   InAppWebViewController webViewController;
//
//   String htmlFilePath = 'assets/manual.html';
//   String url = "";
//
//   ViewBlogScreenState(this.title, this.agreementDoc);
//
//   @override
//   void initState() {
//     super.initState();
//     // getTitle(title);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back,color: Colors.white,),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: Text(getTitle(title),style:TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white)),
//       ),
//       body: (title != "HELP_CENTER") ? Center(
//
//         child: _buildForm(context),
//       ):Center(
//         child:_buildWeb(context),
//
//       ),
//
//
//     );
//   }
//
//
//   @override
//   void dispose() {
//
//     super.dispose();
//   }
//
//   Widget _buildWeb(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child:InAppWebView(
//
//         initialFile: htmlFilePath,
//         // initialHeaders: {},
//         initialOptions: InAppWebViewGroupOptions(
//             crossPlatform: InAppWebViewOptions(
//               // debuggingEnabled: true,
//             )),
//         onWebViewCreated: (InAppWebViewController controller) {
//           webViewController = controller;
//         },
//         onLoadStart: (InAppWebViewController controller, String url) {
//           setState(() {
//             this.url = url;
//           });
//         },
//         onLoadStop:
//             (InAppWebViewController controller, String url) async {
//           setState(() {
//             this.url = url;
//           });
//         },
//         onProgressChanged:
//             (InAppWebViewController controller, int progress) {
//           // setState(() {
//           //   this.progress = progress / 100;
//           // });
//         },
//       ),
//
//     );
//   }
//   Widget _buildForm(BuildContext context) {
//     return FutureBuilder <Agreements>(
//         future: fetchAgreement(),
//         builder:(context, snapshot) {
//           if (!snapshot.hasData) return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),));
//           agreementDoc = snapshot.data;
//
//           return    Stack(
//               children: <Widget>[
//                 Container(
//                   height: MediaQuery
//                       .of(context)
//                       .size
//                       .height,
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 0.0),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         verticalDirection: VerticalDirection.down,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
//                           Center(
//                             child: Card(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12),
//                                 child: Text( agreementDoc != null && agreementDoc.title != null ? agreementDoc.title:"",style: TextStyle(fontSize: 18.0,
//                                     fontWeight: FontWeight.bold,  color: Colors.black87),textAlign: TextAlign.justify,),
//                               ),
//
//                             ),
//                           ),
//                           Card(
//                             child: Padding(
//                               padding: const EdgeInsets.all(12),
//                               child: Text( agreementDoc != null && agreementDoc.description != null ? agreementDoc.description.replaceAll("/n","\n"):"",style: TextStyle(fontSize: 18.0,
//                                   fontWeight: FontWeight.normal,  color: Colors.black87,
//                                   height: 1.5 ,// the height between text, default is null
//                                   letterSpacing: 1.0 ),textAlign: TextAlign.justify,),
//                             ),
//
//                           ),
//
//
//
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//               ] )
//           ;
//         }
//     );
//   }
//
//   Future<Agreements> fetchAgreement() async {
//
//     final addRef = FirebaseFirestore.instance.collection(StringConstant.APP_SETTING).doc(title).get();
//     final agreementTable =  await addRef.then((agreement1) {
//       return Agreements.fromJson(agreement1.data());
//     });
//     return agreementTable;
//   }
//
//   String getTitle(String title) {
//     String title1;
//     switch(title)
//     {
//       case "HELP_CENTER" : title1= "Help Center";
//       break;
//       case "PRIVACY_POLICY" : title1= "Privacy Policy";
//       break;
//       case "TC_USER_AGREEMENT" : title1= "Terms And Conditions";
//       break;
//       default: title1 = "Help" ;
//     }
//     return title1;
//   }
//
// }
