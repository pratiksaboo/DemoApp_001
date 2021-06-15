import 'package:flutter/material.dart';
import 'package:flutter_memory/models/user_model.dart';
import 'package:flutter_memory/providers/auth_provider.dart';
import 'package:provider/provider.dart';


Widget createDrawerHeader(BuildContext context){
  final authProvider = Provider.of<AuthProvider>(context);





  return DrawerHeader(

      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,

      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image:  AssetImage('images/icon.png'))),
      child: Container(color: Colors.orangeAccent,
          child: Stack(children: <Widget>[
            Positioned(
                bottom: 12.0,
                left: 16.0,
                child:  StreamBuilder(
                    stream: authProvider.user,
                    builder: (context, snapshot) {
                      final UserModel user = snapshot.data;
                     return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            Text(user  != null ? user.email:"" ,
                                        style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500)),

                          ]
                      );

                    }),




      ),

      ],



            ),
          ));


}
