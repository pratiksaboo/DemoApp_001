import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart' as widget;
import 'package:flutter_memory/Utility/Utility.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/user.dart' as User;
import 'package:flutter_memory/navigationDrawer/navigationDrawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class AllUserDisclosingDateScreen extends StatefulWidget {

  @override
  _ShowBlogScreenState createState() => _ShowBlogScreenState();
}

class _ShowBlogScreenState extends State<AllUserDisclosingDateScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<User.User> list = [];
  List<User.User> list1 = [];
  TextEditingController editingController = TextEditingController();
  List<User.User> _searchResult = [];

  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
            "Disclosure List", style: TextStyle(fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

      ),
      drawer: NavigationDrawer(),

      body: WillPopScope(
          onWillPop: () async => false, child: _buildBodySection(context)),

    );
  }


  Future<List<User.User>> _fetchData() async {

    list.clear();
    list1.clear();
    final addRef = FirebaseFirestore.instance.collection(StringConstant.USER).get();
    await addRef.then((QuerySnapshot snapshot) {
      list1 = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
        return User.User.fromJson(documentSnapshot.data());
      }).toList();
    });
    print(list1.length.toString());
    if(list1.length>0)
    {

      for(User.User user in list1){
        if(user!=null && user.disclosingDate!=null ) {
            list.add(user);
        }
      }
    }
    print(list.length.toString());
    return list;
  }


  Widget _buildBodySection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: widget.Stack(
        children:<Widget>[
          widget.Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(child: futureBuilder()),


            ],
          ),
          Center(
              child: _progressIndicator()),
        ], ),
    );
  }
  void _showIndicator() {
    setState(() {
      _loading = !_loading;
    });
  }
  Widget _progressIndicator() {
    if (_loading) {
      return new AlertDialog(

        elevation: 4,
        content: new widget.Row(
          children: [
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),),
            Container(margin: EdgeInsets.only(left: 7),child:Text("Uploading..." )),
          ],),
      );

    } else {
      return Container();
    }
  }
  FutureBuilder<List<User.User>> futureBuilder() {
    return new FutureBuilder<List<User.User>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),));
        if (!(snapshot.data.length > 0)) return Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "No users to show.",
            textAlign: TextAlign.center,),
        ));
        return widget.Column(
          children: [
            Visibility(
              visible: list.length>0 ? true : false,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 2.0,bottom: 10.0),
                child:Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _showIndicator();
                      createExcelFile();
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                        padding: MaterialStateProperty.all(EdgeInsets.all(0.0)),
                        textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white))
                    ),
                    child: Text(
                      "Export Data",
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,

                children: snapshot.data.map((blogModel) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        isThreeLine: true,
                        title: Text(
                            blogModel != null && blogModel.emailId != null ? blogModel
                                .emailId : "", style: TextStyle(fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),

                        onTap: () {

                        },
                        subtitle: Text(
                            blogModel != null && blogModel.userName != null && blogModel.disclosingDate != null ? blogModel
                                .userName +"\n" +"Disclosing Date : " + blogModel.disclosingDate: "", style: TextStyle(fontSize: 18.0,
                            color: Colors.black87),maxLines:2),
                        // subtitle: Wrap(
                        //
                        //   children: <Widget>[
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                        //   child: Text(
                        //       blogModel != null && blogModel.userName != null  ? blogModel
                        //           .userName : "",
                        //       style: TextStyle(fontSize: 18.0,
                        //           color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis,),
                        // ),
                        //     // Padding(
                        //     //   padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                        //     //   child: Text(
                        //     //       blogModel != null && blogModel.userName != null &&
                        //     //           blogModel.contactNumber != null ? blogModel
                        //     //           .userName + "\n" + blogModel.countryCode + " " +
                        //     //           blogModel.contactNumber : "",
                        //     //       style: TextStyle(fontSize: 18.0,
                        //     //           color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis,),
                        //     // ),
                        //
                        //     Padding(
                        //       padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        //       child: Text(blogModel != null &&
                        //           blogModel.disclosingDate != null
                        //           ? "Disclosing Date : " + blogModel.disclosingDate
                        //           : "", style: TextStyle(fontSize: 18.0,
                        //           color: Colors.black87), maxLines: 2),
                        //     ),
                        //   ],
                        // ),



                      ),
                    ),
                  );
                },

                ).toList(),

              ),
            ),
          ],
        );
      },);
  }
  Future<void> createExcelFile() async {
//Create an Excel document.

    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    // sheet.showGridlines = false;
    sheet.getRangeByName('E1').setText('User Id');
    sheet.getRangeByName('E1').cellStyle.fontSize = 10;
    sheet.getRangeByName('E1').cellStyle.bold = true;

    sheet.getRangeByName('A1').setText('Email Id');
    sheet.getRangeByName('A1').cellStyle.fontSize = 10;
    sheet.getRangeByName('A1').cellStyle.bold = true;

    sheet.getRangeByName('B1').setText('Name');
    sheet.getRangeByName('B1').cellStyle.fontSize = 10;
    sheet.getRangeByName('B1').cellStyle.bold = true;

    sheet.getRangeByName('C1').setText('Contact Number');
    sheet.getRangeByName('C1').cellStyle.fontSize = 10;
    sheet.getRangeByName('C1').cellStyle.bold = true;

    sheet.getRangeByName('D1').setText('Disclosing Date');
    sheet.getRangeByName('D1').cellStyle.fontSize = 10;
    sheet.getRangeByName('D1').cellStyle.bold = true;

    if (list.length > 0) {
      for (int i= 0; i<list.length;i++) {
        // for (User.User user in list) {
        List<String> data = [

          list[i].emailId,
          list[i].userName,
          list[i].contactNumber,
          list[i].disclosingDate,
          list[i].id,
        ];
        var number = i+2;
        sheet.getRangeByName('A$number').setText(list[i].emailId);
        sheet.getRangeByName('B$number').setText(list[i].userName);
        sheet.getRangeByName('C$number').setText(list[i].contactNumber);
        sheet.getRangeByName('D$number').setText(list[i].disclosingDate);
        sheet.getRangeByName('E$number').setText(list[i].id);
        // sheet.importList(list[i].emailId, i+1, i, false);
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

// Get external storage directory
    final directory = await getExternalStorageDirectory();

// Get directory path
    final path = directory.path;

// Create an empty file to write Excel data
    File file = File("${path}.xlsx");
    print(file.path);

    String name = "AllUserData"+ Utility.now();
// Write Excel data
    await file.writeAsBytes(bytes, flush: true);
    Reference ref = FirebaseStorage.instance.ref().child("Node").child(name).child(
              "AllUserData" + "-" + Utility.now() + ".xlsx");


          await ref.putFile(file)
              .then((val) {
            showSuccessDialog(context,true);
          });

  }


  // Future<void> createExcelFile() async {
  //   var excel = Excel.createExcel();
  //   CellStyle cellStyle = CellStyle(backgroundColorHex: "#1AFF1A",
  //       fontFamily: getFontFamily(FontFamily.Calibri));
  //
  //   cellStyle.underline = Underline.Single; // or Underline.Double
  //   Sheet sheetObject1 = excel["Sheet1"];
  //
  //
  //   var cell1 = sheetObject1.cell(CellIndex.indexByString("E1"));
  //   cell1.value = "User Id"; // dynamic values support provided;
  //   cell1.cellStyle = cellStyle;
  //
  //   var cell2 = sheetObject1.cell(CellIndex.indexByString("A1"));
  //   cell2.value = "Email Id"; // dynamic values support provided;
  //   cell2.cellStyle = cellStyle;
  //
  //   var cell3 = sheetObject1.cell(CellIndex.indexByString("B1"));
  //   cell3.value = "Name"; // dynamic values support provided;
  //   cell3.cellStyle = cellStyle;
  //
  //   var cell4 = sheetObject1.cell(CellIndex.indexByString("C1"));
  //   cell4.value = "Contact Number"; // dynamic values support provided;
  //   cell4.cellStyle = cellStyle;
  //
  //   var cell5 = sheetObject1.cell(CellIndex.indexByString("D1"));
  //   cell5.value = "Disclosing Date"; // dynamic values support provided;
  //   cell5.cellStyle = cellStyle;
  //
  //   // Sheet sheetObject1 = excel["Sheet1"];
  //   if (list.length > 0) {
  //     for (User.User user in list) {
  //       List<String> data = [
  //
  //         user.emailId,
  //         user.userName,
  //         user.contactNumber,
  //         user.disclosingDate,
  //         user.id,
  //       ];
  //       sheetObject1.appendRow(data);
  //     }
  //   }
  //   var res = await Permission.storage.request();
  //   final dir = await getExternalStorageDirectory();
  //
  //   final String path = "${dir.path}.xlsx";
  //   final file = File(path);
  //   if (res.isGranted) {
  //     if (await file.exists()) {
  //       print("File exist");
  //       await file.delete().catchError((e) {
  //         print(e);
  //       });
  //     }
  //     String name = "AllUserData"+ Utility.now();
  //
  //
  //     try {
  //       excel.encode().then((onValue) {
  //         file
  //           ..createSync(recursive: true)
  //           ..writeAsBytesSync(onValue);
  //       }).then((value) async {
  //         Reference ref = FirebaseStorage.instance.ref().child("Node").child(name).child(
  //             "AllUserData" + "-" + Utility.now() + ".xlsx");
  //
  //
  //         await ref.putFile(file)
  //             .then((val) {
  //           showSuccessDialog(context,true);
  //         });
  //       });
  //     }catch (e){
  //       showSuccessDialog(context,false);
  //       print(e);
  //     }
  //   }
  // }
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
      content: Text(status?"Exported Data Successfully":"Error in exporting data. Please press Back Up button once again"),
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
}

















