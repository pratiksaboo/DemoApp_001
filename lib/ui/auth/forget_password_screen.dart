import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_memory/Utility/validate.dart';
import 'package:flutter_memory/app_localizations.dart';
import 'package:flutter_memory/routes.dart';

import 'AuthExceptionHandler.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          _buildBackground(),
          Center(
            child: _buildForm(context),
          )
          // Align(
          //
          //   alignment: FractionalOffset.bottomCenter,
          //   child: _buildForm(context),
          // ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
       super.dispose();
  }

  Widget _buildForm(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 80, 24, 24),
            // padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Card(
                  elevation: 4,
                  shadowColor: Colors.deepOrange,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'images/icon.png',
                                height: 70.0,
                                width: 70.0,
                                fit: BoxFit.fill,
                              )
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp("[ ]"))
                          ],
                          style: Theme.of(context).textTheme.bodyText2,
                          validator: (value) {
                            return Validate.validateEmail(value);
                          },

                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.blueGrey,
                              ),
                              labelText: AppLocalizations.of(context)
                                  .translate("loginTxtEmail"),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width:0.0)),
                              border: OutlineInputBorder()
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orange,
                              ),
                              child: Text(
                                "Reset Password",
                                style: TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  FocusScope.of(context)
                                      .unfocus(); //to hide the keyboard - if any
                                  // await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text).then((value) {
                                  //   showAlertDialog(context, true);
                                  // }).catchError((err) {
                                  //   print(err);
                                  //   showAlertDialog(context,false);}).whenComplete((){
                                  //
                                  // });
                                  try {
                                    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text).then((value) {
                                      showAlertDialog(context, true);
                                    })
                                        .catchError((err) {
                                      print(err);
                                      final errorMsg = AuthExceptionHandler.generateErrorMessage(
                                          err.code);
                                      if (errorMsg != null)showErrorDialog(context,errorMsg);

                                      // _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      //   content: Text(errorMsg),
                                      // ));
                                        }
                                      );
                                  } on PlatformException catch (e) {
                                    print(e.code);
                                    print(e.details);
                                    final errorMsg = AuthExceptionHandler.generateErrorMessage(
                                       e.code);
                                    if (errorMsg != null)showErrorDialog(context,errorMsg);

                                      // _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      //   content: Text(errorMsg),
                                      // ));
                                  }
                                }
                              }),

                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            child: Text("Redirect to Login",style: TextStyle(color:Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.bold)),
//                        textColor: Theme.of(context).iconTheme.color,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.login);
                            },
                          ),
                        )
                      ], ),
                  ),
                ),

                // Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: <Widget>[
                //         SizedBox(
                //           height: 20,
                //         ),
                //         Text(
                //           Provider.of<Flavor>(context).toString(),
                //           style: Theme.of(context).textTheme.bodyText2,
                //         ),
                //       ],
                //     )),
              ],
            ),
          ),
        ));
  }
  showErrorDialog(BuildContext context, String errorMessage) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        _emailController.clear();
        Navigator.pop(context);
        // Navigator.of(context).pushNamed(Routes.login,
        // );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text(errorMessage
         ),
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
  showAlertDialog(BuildContext context, bool status) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.of(context).pushNamed(Routes.login,
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(status ? "Success" : "Error"),
      content: Text(status
          ? "Email Sent Successfully."
          : "Error in Sending Email. Please try again later"),
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
  Widget _buildBackground() {
    return ClipPath(
      clipper: SignInCustomClipper(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}

class SignInCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    var firstEndPoint = Offset(size.width / 2, size.height - 95);
    var firstControlPoint = Offset(size.width / 6, size.height * 0.45);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height / 2 - 50);
    var secondControlPoint = Offset(size.width, size.height + 15);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
