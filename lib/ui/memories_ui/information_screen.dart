import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_memory/ui/memories_ui/view_information_screen.dart';

class InformationScreen  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Help",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white)),
      ),
      body: _buildLayoutSection(context),
    );

  }
}

Widget _buildLayoutSection(BuildContext context) {
  return ListView(
    children: <Widget>[
      Card(
        elevation: 2,
        child: ListTile(
          title: Text("Help Center"),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) {
                // return AgreementDisplay();
                return ViewInformationScreen(title: "HELP_CENTER");
              },
            ),
            );
          },
        ),
      ),
      Card(
        elevation: 2,
        child: ListTile(
            title: Text("Privacy Policy"),
            trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) {
                return ViewInformationScreen(title: "PRIVACY_POLICY");
              },
            ),
            );
          },
        ),
      ),
      Card(
        elevation: 2,
        child: ListTile(
            title: Text("Terms and Conditions"),
            trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) {
                return ViewInformationScreen(title: "TC_USER_AGREEMENT");
              },
            ),
            );
          },
        ),
      ),
    ],
  );
}
