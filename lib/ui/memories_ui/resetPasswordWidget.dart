import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/user.dart';

class ResetPassCodeWidget extends StatefulWidget {
  final User user;
  final String title;

  const ResetPassCodeWidget({Key key,  @required this.user, @required this.title}) : super(key: key);

  @override
  _ResetPassCodeWidgetState createState() => _ResetPassCodeWidgetState(this.user,this.title);
}

class _ResetPassCodeWidgetState extends State<ResetPassCodeWidget> {
  final _formKey = GlobalKey<FormState>();
  String title;
  User user;
  bool _loading = false;
  // bool enable = false;
  TextEditingController _passwordController = TextEditingController(text: "");

  _ResetPassCodeWidgetState(this.user,this.title);


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return  new Container(


      child: SingleChildScrollView(
          child:Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,

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

                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(title),
                            // child: Text("Reset Pass Code"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 4,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            controller: _passwordController,
                            style: Theme.of(context).textTheme.bodyText2,
                            validator: (value){
                                if (value.isEmpty || value.length < 4 )
                                  return 'Please Enter Password';
                                // if (!(Validate.isNumeric(value)))
                                //   return 'Please Enter only digits';
                              return null;
                            },
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width:0.0)),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blueGrey,
                                ),
                                labelText: "Pass Code",
                                border: OutlineInputBorder()),

                          ),
                        ),



                        SizedBox(
                          width: 320.0,
                          child: ElevatedButton(
                            onPressed: () async {
                              _formKey.currentState.save();
                              final form = _formKey.currentState;

                              if (form.validate()) {

                                // resetPassword(_passwordController.text);
                                // PassCodes passCode = new PassCodes();
                                // passCode.isSystemLock = false;
                                // passCode.password = _passwordController.text;
                                _showIndicator();
                                if(user!=null) {
                                  _showIndicator();
                                  user.passcode =  _passwordController.text;
                                  user.noPasscode =  false;
                                  Map<String, dynamic> postData = user.toJson();
                                  FirebaseFirestore.instance
                                      .collection(StringConstant.USER).doc(user.id)
                                      .set(postData).then((result) {

                                    print("user Details uploaded");
                                    // showAlertDialog(context, true);
                                    //            _formKey.currentState.reset();
                                  }
                                  ).catchError((err) {
                                    print(err);
                                    // showAlertDialog(context,false);
                                  }).whenComplete(() {
                                    _showIndicator();
                                    Navigator.pop(context, _passwordController.text);
                                  });
                                }
                                // Navigator.pop(context, _passwordController.text);
                              }
                            },
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
      ),
                          ),
                        )
                      ],
                    ),

                  ),

                ),

              ),
              Center(child: _progressIndicator()),
              //your elements here
            ],
          ) ),);
  }

  Widget _progressIndicator() {
    if (_loading) {

      return Center(
        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),),
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
  // showAlertDialog(BuildContext context, bool status) {
  //   // set up the button
  //   Widget okButton = TextButton(
  //     child: Text("OK"),
  //     onPressed: () {
  //       // Navigator.pop(context);
  //       Navigator.pop(context, _passwordController.text);
  //       // lockScreen();
  //     },
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text(status ? "Success" : "Error"),
  //     content: Text(status
  //         ? "Password Reset Successfully"
  //         : "Error in Password Reset. Please try again later"),
  //     actions: [
  //       okButton,
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
  @override
  void dispose() {

    _passwordController.dispose();
    super.dispose();
  }
}