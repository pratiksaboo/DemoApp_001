import 'package:flutter/material.dart';
import 'package:flutter_memory/Utility/ConnectivityService.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget onlineChild;
  final Widget offlineChild;

  const NetworkAwareWidget({Key key, this.onlineChild, this.offlineChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NetworkStatus networkStatus = Provider.of<NetworkStatus>(context);
    print(networkStatus);
    if(networkStatus!=null) {

      if (networkStatus == NetworkStatus.Online) {
        StringConstant.networkStat = true;
        print(StringConstant.networkStat);
        return onlineChild;
      } else {
        StringConstant.networkStat = false;
        // showAlertDialog(context);
        _showToastMessage("Offline");
        print(StringConstant.networkStat);
         return offlineChild;
      }

    }

    else return onlineChild;

  }

  void _showToastMessage(String message){
    Fluttertoast.showToast(

        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("No Internet"),
      content: Text("Please check your Internet Connection"),
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




