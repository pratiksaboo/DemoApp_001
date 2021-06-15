import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_memory/Utility/bottom_navigation_bar.dart';

import 'bodyItem.dart';



class NavigationDrawer extends StatefulWidget {
 final auth.User user;

  const NavigationDrawer({Key key, this.user}) : super(key: key);
 @override

 State<StatefulWidget> createState() {
   return new CreateDrawerState(user);
 }

}

class CreateDrawerState extends State<NavigationDrawer>{
  auth.User user;

  CreateDrawerState(this.user);
  @override
  void initState() {
    fetchCurrentUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Container(color: Colors.white,

        child: ListView(

          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(

              accountName: Text("${user != null && user.displayName!= null ? user.displayName:""}", style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500)),
              accountEmail: Text("${user != null && user.email!= null ? user.email :""}", style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500)),

              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                backgroundImage: user!=null && user.photoURL !=null ? NetworkImage(user.photoURL) : AssetImage('images/profileimage.png',)
                // backgroundImage: NetworkImage("${user!=null && user.photoURL !=null ? user.photoURL : "https://icon-library.com/images/profile-photo-icon/profile-photo-icon-4.jpg"}"),
              ),
              decoration: BoxDecoration(color: Colors.orangeAccent),
            ),
            // createDrawerHeader(context),
            // createDrawerHeader(context),
            createDrawerBodyItem(
                icon: Icons.home,
                text: 'Home',
                onTap: () {
                  // Navigator.pushReplacementNamed(context, Routes.home);
                  Navigator.push( context,new MaterialPageRoute(
                    builder: (context)
                    {
                      return BottomNavigationBarWidget(pageIndex: 0);
                    },
                  ));
                }
            ),
            createDrawerBodyItem(
                icon: Icons.star,
                text: 'Cherished Memories',
                onTap: () {
                  print(2);
                  // Navigator.pushReplacementNamed(context, Routes.cherishedMemories);
                  Navigator.push( context,new MaterialPageRoute(
                      builder: (context)
                  {
                    return BottomNavigationBarWidget(pageIndex: 2);
                  },
                  ));
                }
            ),
            createDrawerBodyItem(
                icon: Icons.photo_library,
                text: 'Gallery',
                onTap: () {
                  // Navigator.pushReplacementNamed(context, Routes.gallery);
                  Navigator.push( context,new MaterialPageRoute(
                    builder: (context)
                    {
                      return BottomNavigationBarWidget(pageIndex: 1);
                    },
                  ));
                }
            ),
            createDrawerBodyItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () {
                // Navigator.of(context).pushNamed(Routes.setting);
                Navigator.push( context,new MaterialPageRoute(
                  builder: (context)
                  {
                    return BottomNavigationBarWidget(pageIndex: 3);
                  },
                ));
              },
            ),


          ],
        ),
      ),
    );

   }



  Future<void> fetchCurrentUser() async {

    // user = auth.FirebaseAuth.instance.currentUser;
    user = auth.FirebaseAuth.instance.currentUser;
    print(user.email);
    print(user.displayName);
    setState(() {
    });
  }
}