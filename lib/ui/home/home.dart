import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_memory/app_localizations.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/user.dart' as User;
import 'package:flutter_memory/providers/auth_provider.dart';
import 'package:flutter_memory/ui/memories_ui/resetPasswordWidget.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screen_lock/lock_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  {
  // final LocalAuthentication _localAuthentication = LocalAuthentication();
  // String _authorizedOrNot = "Not Authorized";
  String userId;
  User.User userModel;
  // bool _isAuthenticating = false;
  // bool _isSupported;
  // bool _loading = false;
  bool visible = false;
  String emailUser;
  bool _loading = false;

  String phoneNumber, verificationId;
  String otp, authStatus = "";
  User.User userTable;

  @override
  void initState() {
    super.initState();

    new Future.delayed(Duration.zero,() {
      fetchUserTable(context);



    });
    // fetchUserTable();
    // _localAuthentication
    //     .isDeviceSupported()
    //     .then((isSupported) => setState(() => _isSupported = isSupported));
  }

  @override
  Widget build(BuildContext context) {


    return  Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Precious Memories ",style: TextStyle(color: Colors.white,
            fontSize: 20.0,)),
        ),
        body:


        Center(
          child: Visibility(
            visible: visible,
            child: Container(
              // height: MediaQuery
              //     .of(context)
              //     .size
              //     .height,
                child: userModel!=null ? Center(
                  child: Visibility(
                    visible:userModel != null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Visibility(
                        //   visible:userModel != null && userModel.isSystemPasscode!= null && userModel.isSystemPasscode && _authorizedOrNot != null && _authorizedOrNot != "Authorized" ? true : false,
                        //   child: Column(
                        //     children: [
                        //       // Text("Authorized : $_authorizedOrNot"),
                        //       Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: RaisedButton(
                        //           onPressed: _authenticate,
                        //           // onPressed: _authorizeNow,
                        //           child: Text("Try Again",style: TextStyle(color: Colors.white,)),
                        //           color: Colors.orange,
                        //           colorBrightness: Brightness.light,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),


                        Visibility(
                          visible:userModel != null && userModel.passcode!= null && userModel.passcode.isNotEmpty && userModel.passcode!= ""? true : false,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: ()
                                    {
                                      String email ;
                                      if(userModel.emailId != null && userModel.emailId.isNotEmpty)
                                        email = userModel.emailId;
                                      else email = emailUser;
                                      confirmSendDialog(email,userModel.passcode);
                                      // resetDialog(context);
                                    },
                                    child: Text("Forgot Pass Code?",style: TextStyle(color: Colors.white,)),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                                    ),
                                    // color: Colors.orange,
                                    // colorBrightness: Brightness.light,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {lockScreen(userModel.passcode);},

                                    child: Text("Retry once Again",style: TextStyle(color: Colors.white,)),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                                    ),
                                    // color: Colors.orange,
                                    // colorBrightness: Brightness.light,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _confirmSignOut(context);
                                    },
                                    child: Text("Logout",style: TextStyle(color: Colors.white,)),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                                    ),
                                    // color: Colors.orange,
                                    // colorBrightness: Brightness.light,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(child: _progressIndicator()),
                      ],
                    ),
                  ),
                ) :
                Center(child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
                ),)
            ),
          ),
        )


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
        content: new Row(
          children: [
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),),
            Container(margin: EdgeInsets.only(left: 7),child:Text("Sending Email..." )),
          ],),
      );
      // return Center(
      //   child: CircularProgressIndicator(),
      // );
    } else {
      return Container();
    }
  }
  _confirmSignOut(BuildContext context) {
    showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
          // android: (_) => MaterialAlertDialogData(
          //   // backgroundColor: Colors.white),
          //     backgroundColor: Theme.of(context).appBarTheme.color),
          title: Text(
              AppLocalizations.of(context).translate("alertDialogTitle")),
          content: Text(
              AppLocalizations.of(context).translate("alertDialogMessage")),
          actions: <Widget>[
            PlatformDialogAction(

              child: PlatformText(AppLocalizations.of(context)
                  .translate("alertDialogCancelBtn")),
              onPressed: () => Navigator.pop(context),
            ),
            PlatformDialogAction(
              child: PlatformText(AppLocalizations.of(context)
                  .translate("alertDialogYesBtn")),
              onPressed: () {
                final authProvider =
                Provider.of<AuthProvider>(context, listen: false);

                authProvider.signOut();

                Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.login, ModalRoute.withName(Routes.login));
              },
            )
          ],
        ));
  }


  fetchUserTable(BuildContext mcontext) async {

    final auth.User user =  auth.FirebaseAuth.instance.currentUser;
    userId = user.uid;
    emailUser = user.email;
    final addRef = FirebaseFirestore.instance.collection(StringConstant.USER).doc(userId).get();
    userTable =  await addRef.then((userDetails1) {
      return User.User.fromJson(userDetails1.data());
    });
    if(user !=null && (user.emailVerified || (user.phoneNumber!=null && user.phoneNumber.isNotEmpty) )){
      feedData(mcontext);
    }else {
      showEmailVerifiedDialog(mcontext);

    }

  }
  Future<void> verifyPhoneNumber(BuildContext context) async {
    print("verify");
    String number;
    if(userTable!=null && userTable.contactNumber!=null)number=userTable.countryCode + userTable.contactNumber;
    await auth.FirebaseAuth.instance.verifyPhoneNumber(
      // phoneNumber: "+918605362299",
      phoneNumber: number,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (auth.AuthCredential authCredential) {
        setState(() {
          authStatus = "Your account is successfully verified";
          print(authStatus);
        });
      },
      verificationFailed: (auth.FirebaseAuthException authException) {
        setState(() {
          authStatus = "Authentication failed";
          print(authStatus);
          print(authException.message);
          ScaffoldFeatureController controller = ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authException.message)),
          );
          showEmailVerifiedDialog(context);
        });
      },
      codeSent: (String verId, [int forceCodeResent]) {
        verificationId = verId;
        setState(() {
          authStatus = "OTP has been successfully send";
          print(authStatus);
        });
        otpDialogBox(context).then((value) {});
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        setState(() {
          authStatus = "TIMEOUT";
          print(authStatus);
        });
      },

    );
  }
  otpDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter your OTP'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width:0.0)),
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                ),
                onChanged: (value) {
                  otp = value;
                },
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  signIn(otp);
                },
                child: Text(
                  'Submit',
                ),
              ),
            ],
          );
        });
  }
  Future<void> signIn(String otp) async {
    auth.User user = auth.FirebaseAuth.instance.currentUser;

    user.linkWithCredential(auth.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    )).then((value) => feedData(context)) .catchError((err) {
      // ScaffoldFeatureController controller = ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(err.message)),
      // );
      Fluttertoast.showToast(

          msg: err.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white
      ).whenComplete(() => showEmailVerifiedDialog(context));
      // showEmailVerifiedDialog(context);
    });
  }

  showEmailVerifiedDialog(BuildContext context) {
    // set up the button
    Widget okButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
      ),
      // color: Colors.orange,
      child: Text("OK", style: TextStyle(color: Colors.white),),
      onPressed: () {
        final authProvider =
        Provider.of<AuthProvider>(context, listen: false);
        authProvider.signOut();
        Navigator.pop(context);
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.login, ModalRoute.withName(Routes.login));
      },
    );
    Widget otpButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
      ),
      // color: Colors.orange,
      child: Text("OTP", style: TextStyle(color: Colors.white),),
      onPressed: () {
        Navigator.pop(context);
        verifyPhoneNumber(context);
      },
    );
    Widget resendButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
      ),
      child: Text("Resend", style: TextStyle(color: Colors.white),),
      onPressed: () async {
        auth.User user1 = auth.FirebaseAuth.instance.currentUser;

        try {
          await user1.sendEmailVerification().then((value) async {
            Navigator.pop(context);
            showEmailSendSuccessDialog(context);
          });

        } catch (e) {
          ScaffoldFeatureController controller = ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occured while trying to send email verification")),
          );

        }

      },
    );
    // Widget okButton = TextButton(
    //   child: Text("OK"),
    //   onPressed: () {
    //     final authProvider =
    //     Provider.of<AuthProvider>(context, listen: false);
    //     authProvider.signOut();
    //     Navigator.pop(context);
    //     Navigator.of(context).pushNamedAndRemoveUntil(
    //         Routes.login, ModalRoute.withName(Routes.login));
    //   },
    // );
    // Widget otpButton = TextButton(
    //   child: Text("OTP"),
    //   onPressed: () {
    //    Navigator.pop(context);
    //    verifyPhoneNumber(context);
    //   },
    // );
    // Widget resendButton = TextButton(
    //   child: Text("Resend "),
    //   onPressed: () async {
    //     FirebaseUser user1 = await FirebaseAuth.instance.currentUser();
    //
    //     try {
    //       await user1.sendEmailVerification().then((value) async {
    //         Navigator.pop(context);
    //         showEmailSendSuccessDialog(context);
    //       });
    //
    //     } catch (e) {
    //       ScaffoldFeatureController controller = ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text("An error occured while trying to send email verification")),
    //       );
    //
    //     }
    //
    //   },
    // );
    AlertDialog alert = AlertDialog(
      title: Text("Verify Yourself!!",style: TextStyle(fontWeight: FontWeight.bold),),
      content: Text("1. Please verify the email by clicking on the link sent to the email id (Username)"+"\n"+"2. Or click Resend button to send email again"+"\n"+"3. Or Click OTP button to verify yourself with Mobile Number"),
      actions: [
        okButton,
        resendButton,
        otpButton,
      ],
    );
    // set up the AlertDialog
    // AlertDialog alert = AlertDialog(
    //   title: Text("Email Not Verified"),
    //   content: Text("Please verify the email by clicking on the link sent to the email id (Username)"),
    //   actions: [
    //     okButton,
    //     resendButton,
    //   ],
    // );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showEmailSendSuccessDialog(BuildContext context) {
    // set up the button

    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        final authProvider =
        Provider.of<AuthProvider>(context, listen: false);
        authProvider.signOut();
        Navigator.pop(context);
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.login, ModalRoute.withName(Routes.login));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Email Sent successfully."),
      content: Text("Please verify the email by clicking on the link sent to the email id (Username) and login again to continue"),
      actions: [
        okButton,

      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  resetDialog(BuildContext context) {
    if(userModel!=null)
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => ResetPassCodeWidget(user: userModel,title:"Reset Passcode"),
      ).then((value){
        if(value!=null)
          lockScreen(value);

      });
  }


  lockScreen(String passCode) {
    showLockScreen(
      canCancel: true,
      context: context,
      correctString: passCode ,
      backgroundColor: Colors.amber.shade400,
      backgroundColorOpacity: 1,
      onCompleted: (context, result) {
        print(result);
        // if you specify this callback,
        // you must close the screen yourself
        Navigator.of(context).maybePop();
      },
      onUnlocked: () {
        print('Unlocked.');
        Navigator.of(context).pushNamed(Routes.splash);} ,
    );
  }
  void sendEmail(String emailId,String passcode) async {

    // _showIndicator();
    // ignore: deprecated_member_use
    final smtpServer = gmail("app.premo@gmail.com", "daguxsumxhdpmgqp");
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address("app.premo@gmail.com", 'Precious Memories App')
      ..recipients.add(emailId)

      ..subject = 'Forget Passcode'
      ..html = "\n<p>Your passcode of the app is $passcode. \nPlease Reset the Passcode from Settings page.</p>";

    try {
      final sendReport = await send(message, smtpServer).whenComplete(() => _showIndicator());
      print('Message successfully sent.'+sendReport.toString());
      showAlertDialog(context,true,null);
      // Fluttertoast.showToast(
      //
      //     msg: 'Email sent successfully.',
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.black,
      //     textColor: Colors.white
      // );
    } on MailerException catch (e) {
      print('Email not sent.');
      Fluttertoast.showToast(

          msg: 'Email not sent ' ,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white
      );
      var buffer = new StringBuffer();
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
        buffer.write(p.msg);
        buffer.write("\n");
      }
      showAlertDialog(context,false,buffer.toString());
    }

  }
  confirmSendDialog(String emailId,String passcode) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Forgot Pass Code?'),
            content: Text('Click on OK button to send Pass Code to your Email Id.',style: TextStyle(color: Colors.deepOrange),),
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
                  _showIndicator();
                  sendEmail(emailId,passcode);
                },
              ),
            ],
          );
        });
  }
  showAlertDialog(BuildContext context,bool status,String error) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        lockScreen(userModel.passcode);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(status?"Success":"Error"),
      content: Text(status?"Email Sent Successfully. Please check your inbox for the mail":error!=null && error.isNotEmpty ? error: "Email not sent"),
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

  Future<void> feedData(BuildContext mcontext) async {
    // final addRef = Firestore.instance.collection(StringConstant.USER).document(userId).get();
    // userTable =  await addRef.then((userDetails1) {
    //   return User.fromJson(userDetails1.data);
    // });
    if(userTable != null) userModel = userTable;
    print(userTable.userName);
    print(userTable.isSystemPasscode);
    print(userTable.passcode);

    if(userTable != null && userTable.noPasscode!= null && userTable.noPasscode)
      Navigator.of(mcontext).pushNamed(Routes.splash);

    else if (userTable != null && userTable.passcode != null &&
        userTable.passcode.isNotEmpty) {
      showLockScreen(
        canCancel: true,
        context: mcontext,
        correctString: userTable.passcode,
        backgroundColor: Colors.amber.shade400,
        backgroundColorOpacity: 1,
        onCompleted: (mcontext, result) {

        },
        onUnlocked: () {
          print('Unlocked.');
          print(mcontext);
          Navigator.of(mcontext).pushNamed(Routes.splash);
        },
      ).then((value) {
        print(value.toString());
        setState(() {
          visible = true;
        });
      });
    }
    else Navigator.of(mcontext).pushNamed(Routes.splash);
  }
}

