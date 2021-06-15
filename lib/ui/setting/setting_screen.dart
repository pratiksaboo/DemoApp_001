import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_memory/app_localizations.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/user.dart' as User;
import 'package:flutter_memory/providers/auth_provider.dart';
import 'package:flutter_memory/routes.dart';
import 'package:flutter_memory/ui/memories_ui/resetPasswordWidget.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
// import 'package:local_auth_device_credentials/local_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {


  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // final LocalAuthentication _localAuthentication = LocalAuthentication();
  User.User userDetails;
  bool isSystemLock = false;

  bool isBiometricsAvailable;
  // bool _isSupported;

  @override
  void initState() {

    super.initState();
    // _localAuthentication
    //     .isDeviceSupported()
    //     .then((isSupported) => setState(() => _isSupported = isSupported));
    // checkBiometric();
  }
  // Future<void> checkBiometric() async {
  //   isBiometricsAvailable = await _localAuthentication.canCheckBiometrics;
  //   setState(() {
  //
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("settingAppTitle"),style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () async {

            Navigator.pushReplacementNamed(context, Routes.home);

          },
        ),
      ),
      body: _buildLayoutSection(context),
    );
  }

  Widget _buildLayoutSection(BuildContext context) {
    return ListView(
    children: <Widget>[

      FutureBuilder<User.User>(
         future: fetchUser(),
        builder: (context, snapshot) {
          // if (!snapshot.hasData)
            // return Center(child: CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),),);
          if (snapshot.hasData)   userDetails = snapshot.data;

          return Column(
            children: [
              Visibility(
                visible:userDetails!=null && userDetails.isManagement !=null && userDetails.isManagement ? true : false,
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Manage Quotes"),

                      trailing:SizedBox(
                        width: 120,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orangeAccent,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(Routes.quoteList,
                              );
                            },
                            child: Text("Add")),
                      ),
                    ),
                    ListTile(
                      title: Text("App Settings"),

                      trailing:SizedBox(
                        width: 120,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orangeAccent,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(Routes.adminSetting,
                              );
                            },
                            child: Text("Manage")),
                      ),
                    ),
                    ListTile(
                      title: Text("Download User Data"),

                      trailing:SizedBox(
                        width: 120,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orangeAccent,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(Routes.userList,
                              );
                            },
                            child: Text("Download")),
                      ),
                    ),
                    ListTile(
                      title: Text("Disclosure List"),

                      trailing:SizedBox(
                        width: 120,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orangeAccent,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(Routes.userDisclosureDateList,
                              );
                            },
                            child: Text("View")),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: userDetails != null &&( (userDetails.noPasscode!=null && userDetails.noPasscode) || (userDetails.passcode == null || userDetails.passcode.isEmpty)) ? true : false,
                child: ListTile(
                  title: Text("Set PassCode"),

                  trailing:SizedBox(
                    width: 120,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orangeAccent,
                        ),
                        onPressed: () {

                          if(userDetails != null)
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) => ResetPassCodeWidget(user:userDetails,title:"Set Passcode"),
                            ).then((value){
                              setState(() {

                              });
                            });

                        },
                        child: Text("Set")),
                  ),
                ),
              ),
              Visibility(
                visible: userDetails != null && userDetails.passcode!=null && userDetails.passcode.isNotEmpty ? true : false,
                child: ListTile(
                  title: Text("Change PassCode"),

                  trailing:SizedBox(
                    width: 120,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orangeAccent,
                        ),
                        onPressed: () {

                          if(userDetails != null)
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) => ResetPassCodeWidget(user:userDetails,title:"Reset Passcode"),
                            ).then((value){

                            });

                        },
                        child: Text("Reset")),
                  ),
                ),
              ),
          // ListTile(
          //   title: Text(userDetails != null && userDetails.isSystemPasscode != null && userDetails.isSystemPasscode ? "Disable System Lock":"Enable System Lock"),
          //
          //   // subtitle: Text("Use System lock "),
          //   trailing: Switch(
          //     activeColor: Theme.of(context).appBarTheme.color,
          //     activeTrackColor: Theme.of(context).textTheme.title.color,
          //     value: userDetails != null && userDetails.isSystemPasscode != null && userDetails.isSystemPasscode? true:false,
          //     onChanged: (value){
          //       setState(() {
          //         isSystemLock = value;
          //         userDetails.passcode = null;
          //         userDetails.isSystemPasscode =  isSystemLock;
          //         uploadUserPinData(userDetails);
          //
          //       });
          //     },
          //   ),
          // ),
            ],
          );
        }
      ),
      ListTile(
        title: Text("Manage Nominees"),

        trailing:SizedBox(
          width: 120,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.nomineeList,
                );
              },
              child: Text("Add")),
        ),
      ),
      ListTile(
        title: Text("Manage Profile"),

        trailing:SizedBox(
          width: 120,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.profile,
                );
              },
              child: Text("Edit")),
        ),
      ),

      ListTile(
        title: Text(
            AppLocalizations.of(context).translate("settingLogoutListTitle")),
        // subtitle: Text(AppLocalizations.of(context)
        //     .translate("settingLogoutListSubTitle")),
        trailing: SizedBox(
          width: 120,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent,
              ),
              onPressed: () {
                _confirmSignOut(context);
              },
              child: Text(AppLocalizations.of(context)
                  .translate("settingLogoutButton"))),
        ),
      )
    ],
      );
  }

  _confirmSignOut(BuildContext context) {
    showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
              // android: (_) => MaterialAlertDialogData(
              //     // backgroundColor: Colors.white),
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

  Future<User.User> fetchUser() async {
    String userId;

    final auth.User user = auth.FirebaseAuth.instance.currentUser;
    userId = user.uid;
    final addRef = FirebaseFirestore.instance.collection(StringConstant.USER).doc(userId).get();
    userDetails =  await addRef.then((userDetails1) {
      return User.User.fromJson(userDetails1.data());
    });
   // if(userDetails!=null && (userDetails.isSystemPasscode ==null || !userDetails.isSystemPasscode) && (userDetails.passcode == null || userDetails.passcode.isEmpty) )
   //   {
   //     int count=0;
   //     print(count++);
   //     await showDialog(
   //       barrierDismissible: false,
   //       context: context,
   //       builder: (BuildContext context) => SelectPassCodeWidget(isSupported:_isSupported,isBiometricsAvailable: isBiometricsAvailable,),
   //     ).then((value){
   //       PassCodes passCodes = value;
   //       userDetails.isSystemPasscode = passCodes.isSystemLock;
   //       userDetails.passcode = passCodes.password;
   //       uploadUserPinData(userDetails);
   //     });
   //   }
    return userDetails;
  }

  void uploadUserPinData(User.User userDetails) {
    Map<String, dynamic> postData = userDetails.toJson();
    FirebaseFirestore.instance
        .collection(StringConstant.USER).doc(userDetails.id)
        .set(postData).then((result) {
      print("user Details uploaded");

    }
    ).catchError((err) {
      print(err);

    }).whenComplete(() {
      setState(() {

      });
    });
  }

  void sendEmail() async {
    // ignore: deprecated_member_use
    final smtpServer = gmail("app.premo@gmail.com", "daguxsumxhdpmgqp");
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address("app.premo@gmail.com", 'Precious Memories App')
      ..recipients.add('tanushree.shelare@findingpi.com')

      ..subject = 'Forget Passcode'
      // ..text = 'Your passcode of the app is 1234 .\nPlease create a new password on login.'
      ..html = "\n<p>Your passcode of the app is 1234 .\nPlease create a new password on login.</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message successfully sent.');
      Fluttertoast.showToast(

          msg: 'Message successfully sent.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white
      );
    } on MailerException catch (e) {
      print('Message not sent.');
      Fluttertoast.showToast(

          msg: 'Message not sent ' ,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white
      );
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

  }





}
