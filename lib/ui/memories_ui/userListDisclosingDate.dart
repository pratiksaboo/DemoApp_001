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
import 'package:flutter_memory/ui/memories_ui/AllUserDisclosingList.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class UserListDateScreen extends StatefulWidget {

  @override
  _ShowBlogScreenState createState() => _ShowBlogScreenState();
}

class _ShowBlogScreenState extends State<UserListDateScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<User.User> list = [];
  List<User.User> list1 = [];
  TextEditingController editingController = TextEditingController();
  List<User.User> _searchResult = [];
  String selectedDateTo = new DateFormat.yMMMMd("en_US").format(DateTime.now());
  String selectedDateFrom = new DateFormat.yMMMMd("en_US").format( DateTime.now());
  DateTime picked1, picked2;
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextButton(
              child: Text("All Users",style: TextStyle(fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(
                  builder: (context) {
                    return AllUserDisclosingDateScreen();
                  },
                ),
                );
              },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: BorderSide(color: Colors.white),
                        )
                    )
                ),
            ),
          )
        ],
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
      if (picked1 == null) picked1 =  DateTime.parse(Utility.dateConverter(DateFormat.yMMMMd("en_US").format(DateTime.now())));
      print(picked1);

      if (picked2 == null) picked2 =  DateTime.parse(Utility.dateConverter(new DateFormat.yMMMMd("en_US").format(DateTime.now())));
      print(picked2);

      for(User.User user in list1){
        if(user!=null && user.disclosingDate!=null && user.disclosingDate!="0") {

          DateTime dateTime = DateTime.parse(
              Utility.dateConverter(user.disclosingDate));

          print(dateTime.toString());
          if ((dateTime.isAfter(picked1)|| dateTime.isAtSameMomentAs(picked1)) && (dateTime.isAtSameMomentAs(picked2)||dateTime.isBefore(picked2)))
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
          Container(
            child: widget.Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                calenderContainerWidget(context),
                Expanded(child: futureBuilder()),


              ],
            ),
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
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orangeAccent,
                      onPrimary: Colors.white,
                      onSurface: Colors.grey,
                      padding: const EdgeInsets.all(0.0),
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
                          // Navigator.push(context, new MaterialPageRoute(
                          //   builder: (context) {
                          //     return ViewUserDetailsScreen(user : blogModel);
                          //   },
                          // ),
                          // );
                        },
                        subtitle: Text(
                            blogModel != null && blogModel.userName != null && blogModel.disclosingDate != null ? blogModel
                                .userName +"\n" +"Disclosing Date : " + blogModel.disclosingDate: "", style: TextStyle(fontSize: 18.0,
                            color: Colors.black87),maxLines:2),
                        // subtitle: Wrap(
                        //   children: <Widget>[
                        //     Padding(
                        //       padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                        //       child: Text(
                        //           blogModel != null && blogModel.userName != null &&
                        //               blogModel.contactNumber != null ? blogModel
                        //               .userName + "\n" + blogModel.countryCode + " " +
                        //               blogModel.contactNumber : "",
                        //           style: TextStyle(fontSize: 18.0,
                        //               color: Colors.black87), maxLines: 2),
                        //     ),
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


  Container calenderContainerWidget(BuildContext context) {
    return Container(
        child: Wrap(
          children: <Widget>[
            Card(
              margin: EdgeInsets.fromLTRB(2, 12, 0, 12),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2, 2, 0, 4),
                child: widget.Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 8, 0, 8),
                        child: widget.Column(
                          children: [
                            Text("From Date"),
                            new Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                color: Colors.orange,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: widget.Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children: [
                                      InkWell(
                                        child: Text(
                                            selectedDateFrom,
                                            style: TextStyle(
                                                color: Colors
                                                    .white,
                                                fontSize: 12.0)
                                        ),
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          _selectDateFrom(context);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                            Icons.calendar_today,
                                            color: Colors.white, size: 12),
                                        tooltip: 'Tap to open date picker',
                                        onPressed: () {
                                          _selectDateFrom(context);
                                        },
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 8, 0, 8),
                        child: widget.Column(
                          children: [
                            Text("To Date"),
                            new Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                color: Colors.orange,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: widget.Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children: [
                                      InkWell(
                                        child: Text(
                                            selectedDateTo,
                                            style: TextStyle(
                                                color: Colors
                                                    .white,
                                                fontSize: 12.0)
                                        ),
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          _selectDateTo(context);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                            Icons.calendar_today,
                                            color: Colors.white, size: 12),
                                        tooltip: 'Tap to open date picker',
                                        onPressed: () {
                                          _selectDateTo(context);
                                        },
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),


                    ]
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> _selectDateFrom(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2120),

      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),

          ),
          child: child,
        );
      },
    );
    if (picked != null && picked.toString() != selectedDateFrom)
      setState(() {
        selectedDateFrom = new DateFormat.yMMMMd("en_US").format(picked);
      });
    print(picked.toString());
    picked1 = picked;
  }

  Future<void> _selectDateTo(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2120),

      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),

          ),
          child: child,
        );
      },
    );
    if (picked != null && picked.toString() != selectedDateTo)
      setState(() {
        selectedDateTo = new DateFormat.yMMMMd("en_US").format(picked);
      });
    picked2= picked;
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

// Write Excel data
    await file.writeAsBytes(bytes, flush: true);
    String name;
    if(picked1 == null && picked2 == null) name = "AllUserData"+ Utility.now();
    else name = selectedDateFrom +" to" + selectedDateTo;

    Reference ref = FirebaseStorage.instance.ref().child("Node").child(name).child(
        selectedDateFrom +" to" + selectedDateTo + "-" + Utility.now() + ".xlsx");


    await ref.putFile(file)
        .then((val) {
      showSuccessDialog(context,true);
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