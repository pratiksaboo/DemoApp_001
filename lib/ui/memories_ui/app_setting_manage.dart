import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memory/Utility/validate.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/AppSettings.dart';

class AppSettingsScreen extends StatefulWidget {
  final userTable;

  const AppSettingsScreen({Key key, this.userTable}) : super(key: key);
  @override
  MapScreenState createState() => MapScreenState(userTable);
}

class MapScreenState extends State<AppSettingsScreen>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String minAppVersion;
   int quoteFont;
   bool quoteByDate = false;
  bool datequote = false;
  String  splashUrl,buttonText;
  final _formKey = GlobalKey<FormState>();

  AppSettings appSettings;
  final userTable;

  bool _loading = false;

  MapScreenState(this.userTable);

  @override
  void initState() {
    super.initState();
    fetchSettings();
  }


  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("App Settings",style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit,color: Colors.white,),
              onPressed: () {
                setState(() {
                  _status = false;
                });
              }),

        ],
      ),

      bottomNavigationBar:
      Visibility(
        visible: !_status,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8,8,8,10),
          child: Container(
            child: SizedBox(
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    _formKey.currentState.save();

                    submit(context);

                  },

                  style: ElevatedButton.styleFrom(
                    primary: Colors.orangeAccent,
                    onPrimary: Colors.white,
                    onSurface: Colors.grey,
                    padding: const EdgeInsets.all(8.0),
                  ),
                  child: Text(
                    "Submit",
                  ),
                )
              // This align moves the children to the bottom
            ),),
        ),
      ),
      body: SafeArea(
        child: _buildForm(context),
      ),


    );
  }
  Widget _buildForm(BuildContext context) {

    return FutureBuilder <AppSettings>(
        future: fetchAppSettings(),
        builder:(context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
          ));
          appSettings = snapshot.data;
          setData(appSettings);
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          verticalDirection: VerticalDirection.down,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: quoteByDate ? Colors.orange : Colors.blueGrey,
                                  ),
                                  child: Center(child: new Text( quoteByDate ?"Quote by Date: On":"Quote by Date: Off",style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold))),
                                  onPressed: () {
                                    if (!_status) {
                                      setState(() {
                                        quoteByDate = !quoteByDate;
                                      });
                                    }
                                  }),
                            ),
                            // Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 25.0, right: 25.0, top: 16.0),
                            //     child: new Row(
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: <Widget>[
                            //         new Column(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: <Widget>[
                            //             new Text(
                            //               'Splash Url',
                            //               style: TextStyle(
                            //                   fontSize: 16.0,
                            //                   fontWeight: FontWeight.bold),maxLines: 4,
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     )),
                            // Visibility(
                            //   visible: false,
                            //   child: Padding(
                            //       padding: EdgeInsets.only(
                            //           left: 25.0, right: 25.0, top: 2.0),
                            //       child: new Row(
                            //         mainAxisSize: MainAxisSize.max,
                            //         children: <Widget>[
                            //           new Flexible(
                            //             child: new TextFormField(
                            //               initialValue: splashUrl,
                            //               keyboardType: TextInputType.multiline,
                            //               minLines: 4,
                            //               maxLines: null,
                            //               // expands: true,
                            //               decoration: const InputDecoration(
                            //                 hintText: "Splash Url",
                            //               ),
                            //               enabled: !_status,
                            //               autofocus: !_status,
                            //               validator: (value) =>
                            //               value.length == 0 ? "Please enter splash url" : null,
                            //               onSaved: (value) {
                            //                 splashUrl = value.trim();
                            //               },
                            //             ),
                            //           ),
                            //         ],
                            //       )),
                            // ),
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
                                          'Quote Font Size',
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
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        keyboardType: TextInputType.number,
                                        initialValue: quoteFont.toString(),
                                        decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(width:0.0)),
                                            hintText: "Enter quote Font Size"),
                                     enabled: !_status,
                                        validator: (value) {
                                          if (value.isEmpty)
                                            return 'Enter Quote Font Size';
                                          else if (value.isNotEmpty && int.parse(value)>25)
                                            return 'Font Size cannot exceed more than 25';
                                          else
                                            return null;
                                        },
                                        onSaved: (value) {
                                          quoteFont = int.parse(value.trim());
                                        },
                                      ),
                                    ),
                                  ],
                                )),
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
                                          'Min App Version',
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
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        initialValue: minAppVersion.toString(),
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(width:0.0)),
                                            hintText: "Enter Min App Version (1.0.0)"),
                                        enabled: !_status,
                                        validator: (value) {
                                          return Validate.validateVersion(value);
                                        },
                                        // value.length == 0
                                        //     ? "Please enter min App Version"
                                        //     : null,
                                        onSaved: (value) {
                                          minAppVersion = value.trim();
                                        },
                                      ),
                                    ),
                                  ],
                                )),



                          ],
                        ),

                      ),
                    ),
                  ),
                ),
                Center(child: _progressIndicator()),
              ] )
          ;
        }
    );
  }
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }




  void submit(BuildContext context) {
    final form = _formKey.currentState;
    if (form.validate()) {
      _showIndicator();
      uploadAppSettings();
    }
  }


  void  uploadAppSettings(){
    if(appSettings!=null) {
      // appSettings.splashUrl = splashUrl;
      appSettings.minAppVersion = minAppVersion;
      appSettings.quoteFontSize = quoteFont;

      appSettings.showQuoteByDate = quoteByDate;

      Map<String, dynamic> postData = appSettings.toJson();
      FirebaseFirestore.instance
          .collection(StringConstant.APP_SETTING).doc(StringConstant.GLOBAL_CONSTANT)
          .set(postData).then((result) {

        showAlertDialog(context, true);
        setState(() {
          _status = true;
          FocusScope.of(context).requestFocus(new FocusNode());
        });
//            _formKey.currentState.reset();
      }
      ).catchError((err) {
        print(err);
        showAlertDialog(context,false);}).whenComplete(() {
        _showIndicator();
      });
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
      // return Center(
      //   child: CircularProgressIndicator(),
      // );
    } else {
      return Container();
    }
  }

  void _showIndicator() {
    setState(() {
      _loading = !_loading;
    });
  }


  Future<AppSettings> fetchAppSettings() async {

    final addRef = FirebaseFirestore.instance.collection(StringConstant.APP_SETTING).doc(StringConstant.GLOBAL_CONSTANT).get();
    final userTable =  await addRef.then((userDetails1) {
      return AppSettings.fromJson(userDetails1.data());
    });
    return userTable;
  }


  void setData(AppSettings appSettings) {
    // splashUrl = appSettings!=null && appSettings.splashUrl!=null ? appSettings.splashUrl : "";
    minAppVersion = appSettings!=null && appSettings.minAppVersion!=null ? appSettings.minAppVersion : 0;
    quoteFont = appSettings!=null ? appSettings.quoteFontSize : 0;
    // if(appSettings.showQuoteByDate != null )
    //   quoteByDate = appSettings.showQuoteByDate;

    }
  fetchSettings() async {

    final addRef = FirebaseFirestore.instance.collection(StringConstant.APP_SETTING).doc(StringConstant.GLOBAL_CONSTANT).get();
    appSettings =  await addRef.then((userDetails1) {
      return AppSettings.fromJson(userDetails1.data());
    });
    if(appSettings !=null && appSettings.showQuoteByDate != null)
    {
      quoteByDate = appSettings.showQuoteByDate;
    }
  }


}

