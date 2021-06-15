import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/AppSettings.dart';
import 'package:flutter_memory/routes.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppSettings appSettings;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();

    // startTimer();
  }
  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    _packageInfo = info;
    fetchAppSettings();
    // checkVersion(_packageInfo);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Center(

              child: Image.asset(
                'images/icon.png',
                height: 100.0,
                width: 100.0,


            )
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //
            //   children: <Widget>[
            //
            //     Image.asset(
            //       'images/icon.png',
            //       height: 100.0,
            //       width: 100.0,
            //
            //     )
            //
            //   ],
            // )
        )
    );
  }

  startTimer() {
    var duration = Duration(milliseconds:3000);
    return Timer(duration, redirect);
  }

  redirect() async {
    Navigator.of(context).pushReplacementNamed(Routes.home);
    // Navigator.of(context).pushReplacementNamed(Routes.home1);
  }

  void checkVersion(PackageInfo packageInfo, String minAppVersion) {
    print(packageInfo.version);
    Version currentVersion = Version.parse(packageInfo.version);
    Version latestVersion = Version.parse(minAppVersion);

    if (latestVersion > currentVersion) {
      print("Update is available");
      _showVersionDialog(context);
    }else {
      redirect();
    }

    // Version betaVersion = new Version(2, 1, 0, preRelease: ["beta"]);
    // // Note: this test will return false, as pre-release versions are considered
    // // lesser then a non-pre-release version that otherwise has the same numbers.
    // if (betaVersion > latestVersion) {
    //   print("More recent beta available");
    // }
    // if(packageInfo.version>)
  }
  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Theme.of(context).platform == TargetPlatform.iOS
            ? new CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(btnLabel),
              onPressed: () {
              },
              // onPressed: () => _launchURL(APP_STORE_URL),
            ),
            TextButton(
              child: Text(btnLabelCancel),
               onPressed: (){

             Navigator.pop(context);
             redirect();
             // startTimer();
            }
            ),
          ],
        )
            :
        new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(btnLabel),
              onPressed: () => _launchURL("https://play.google.com/store/apps/details?id=" + _packageInfo.appName),
            ),
            TextButton(
              child: Text(btnLabelCancel),
              onPressed: (){
                Navigator.pop(context);
                // startTimer();
        }
            ),
          ],
        );
      },
    );
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  fetchAppSettings() async {

    final addRef = FirebaseFirestore.instance.collection(StringConstant.APP_SETTING).doc(StringConstant.GLOBAL_CONSTANT).get();
     appSettings =  await addRef.then((userDetails1) {
      return AppSettings.fromJson(userDetails1.data());
    });
     if(appSettings !=null && appSettings.minAppVersion != null)
    checkVersion(_packageInfo,appSettings.minAppVersion);
   // return appSettings;
  }
}