import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_memory/Utility/Utility.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/quotes.dart';
import 'package:intl/intl.dart';

class AddQuoteScreen extends StatefulWidget {
  final Quotes quote;


  AddQuoteScreen({Key key, @required this.quote}) : super(key: key);

  @override
  _AddQuoteScreenState createState() => _AddQuoteScreenState(quote);
}

class _AddQuoteScreenState extends State<AddQuoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Quotes quote;
  String  message;
  String _selectedDate;
  bool _loading = false;
  bool isDateChanged = false;

  _AddQuoteScreenState(this.quote);


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
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(quote ==null?"Add Quote":"Manage Quotes",style: TextStyle(color: Colors.white)),
//        actions: <Widget>[
//          FlatButton(
//              onPressed: () {
//              },
//              child: Text("Save"))
//        ],
      ),
      body:  Center(

        child: _buildForm(context),

      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(8,8,8,10),
        child: Container(
            child: SizedBox(
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  _formKey.currentState.save();
                  _showIndicator();
                    submit(context,_selectedDate, message);

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
                // shape: OutlineInputBorder(
                //     borderRadius: BorderRadius.circular(10)),
              ),
            )
          // This align moves the children to the bottom
        ),
      ),

    );
  }

  @override
  void dispose() {
//    _taskController.dispose();
      super.dispose();
  }

  Widget _progressIndicator() {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
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


  Widget _buildForm(BuildContext context) {
   print(widget.quote != null &&  widget.quote.quoteMessage != null ?widget.quote.quoteMessage :"");
   message = widget.quote != null &&  widget.quote.quoteMessage != null ? widget.quote.quoteMessage :"";
   if(!isDateChanged) {
     _selectedDate = widget.quote != null && widget.quote.date != null
         ? widget.quote.date
         : new DateFormat.yMMMMd("en_US").format(DateTime.now());
   }
    return new Container(

      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
          child:Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
//      mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(width: 1.0, color: Colors.orangeAccent),
                                  left: BorderSide(width: 1.0, color: Colors.orangeAccent),
                                  right: BorderSide(width: 1.0, color: Colors.orangeAccent),
                                  bottom: BorderSide(width: 1.0, color: Colors.orangeAccent),
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      InkWell(
                                        child: Text(
                                            _selectedDate,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Color(0xFF000000))
                                        ),
                                        onTap: (){
                                          _selectDate(context);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        tooltip: 'Tap to open date picker',
                                        onPressed: () {
                                          _selectDate(context);
                                        },
                                      ),
                                    ]
                                ))),
                        SizedBox(height: 15.0),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.sentences,
                            initialValue: message,
                            style: Theme.of(context).textTheme.bodyText2,
                            maxLines: 15,
                            validator: (value) =>
                              value.length == 0 ? "Please enter quote": null,
                              onSaved: (value) {
                              message = value.trim();
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16.0),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide( color: Theme.of(context).iconTheme.color,width:1)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).iconTheme.color,
                                      width: 1)),
                              labelText: "Quotes here",
                              alignLabelWithHint: true,
                              // contentPadding: new EdgeInsets.symmetric(
                              //     vertical: 10.0, horizontal: 10.0),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ),

                ),

              ),

              _progressIndicator(),
              //your elements here
            ],
          ) ),);


  }





  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),

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
    if (picked != null) {
      print(picked.toString());
      // if (picked != null && picked.toString() != _selectedDate)
      setState(() {
        isDateChanged = true;
        _selectedDate = new DateFormat.yMMMMd("en_US").format(picked);
        print(_selectedDate);
      });
    }
  }

  submit(BuildContext context,String date, String message) async {
    final form = _formKey.currentState;
    if (form.validate()) {
      if (quote != null) {
        quote.modifiedTimestamp = DateTime.now();
      } else {
        quote = new Quotes();
        quote.quoteId = Utility.getRandomString(6);
        quote.createdTimestamp = DateTime.now();
        quote.modifiedTimestamp = DateTime.now();
      }
      String userId;
      final auth.User user = auth.FirebaseAuth.instance.currentUser;
      userId = user.uid;
      print(userId);
      quote.userId = userId;
      quote.date = date;
      quote.quoteMessage = message;

      Map<String, dynamic> postData = quote.toJson();
      FirebaseFirestore.instance
          .collection(StringConstant.QUOTES).doc(quote.quoteId)
          .set(postData).then((result)
      {
         showAlertDialog(context,true);

      }
      )
          .catchError((err) {
        showAlertDialog(context,false);
        print(err);

      }).whenComplete(() {
        _showIndicator();
      });
    }
  }
  showAlertDialog(BuildContext context,bool status) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.of(context).pop();
        // Navigator.of(context).pushNamed(Routes.quoteList,
        // );

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(status?"Success":"Error"),
      content: Text(status?"Saved Successfully":"Error in Saving. Please try again later"),
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
