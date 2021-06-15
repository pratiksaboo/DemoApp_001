import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/Gallery.dart';
import 'package:flutter_memory/models/user.dart' as User;
import 'package:flutter_memory/navigationDrawer/navigationDrawer.dart';
import 'package:flutter_memory/ui/memories_ui/image_view_screen.dart';

import '../../routes.dart';

class GalleryScreen extends StatefulWidget {
  @override
  GalleryScreenState createState() => GalleryScreenState();
}

class GalleryScreenState extends State<GalleryScreen>{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // User userDetails;

  @override
  void initState() {
    super.initState();
    // fetchUser();
  }
  // Future<User> fetchUser() async {
  //   String userId;
  //
  //   final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   userId = user.uid;
  //   final addRef = Firestore.instance.collection(StringConstant.USER).document(userId).get();
  //   userDetails =  await addRef.then((userDetails1) {
  //     return User.fromJson(userDetails1.data);
  //   });
  //   if(userDetails!=null && (userDetails.isSystemPasscode ==null || !userDetails.isSystemPasscode) && (userDetails.passcode == null || userDetails.passcode.isEmpty) )
  //   {
  //     int count=0;
  //     print(count++);
  //     await showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) => SelectPassCodeWidget(isSupported:true,isBiometricsAvailable: true,),
  //     ).then((value){
  //       PassCodes passCodes = value;
  //       userDetails.isSystemPasscode = passCodes.isSystemLock;
  //       userDetails.passcode = passCodes.password;
  //       uploadUserPinData(userDetails);
  //     });
  //   }
  //   return userDetails;
  // }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Gallery" ,style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white)),
        leading: IconButton(
          icon:Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: ()  {
            // await showDialog(
            //     barrierDismissible: false,
            //     context: context,
            //     builder: (BuildContext context) => SelectPassCodeWidget(isSupported:true,isBiometricsAvailable: true,),
            // ).then((value){
            // PassCodes passCodes = value;
            // userDetails.isSystemPasscode = passCodes.isSystemLock!=null?passCodes.isSystemLock:false;
            // userDetails.passcode = passCodes.password;
            // uploadUserPinData(userDetails);
            // Navigator.pushReplacementNamed(context, Routes.home);
            // });
            Navigator.pushReplacementNamed(context, Routes.home);
          },
        ),

      ),
      drawer: NavigationDrawer(),
      body : FutureBuilder<List<Gallery>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
          ));
          if(! (snapshot.data.length>0)) return Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("No Image found.",textAlign: TextAlign.center,),
          ));
          return
            new GalleryGridView(gallery: snapshot.data);
          // return snapshot.hasData
          //     ? new GalleryGridView(gallery: snapshot.data)
          //     : new Center(child: new CircularProgressIndicator());

        },
      ),

    );

  }

  void uploadUserPinData(User.User userDetails) {
    Map<String, dynamic> postData = userDetails.toJson();
    FirebaseFirestore.instance
        .collection(StringConstant.USER).doc(userDetails.id)
        .set(postData).then((result) {
      print("user Details uploaded");
      // showAlertDialog(context, true);
      //            _formKey.currentState.reset();
    }
    ).catchError((err) {
      print(err);
      // showAlertDialog(context,false);
    }).whenComplete(() {
      setState(() {

      });
    });
  }
  Future<List<Gallery>> _fetchData() async {

    final auth.User user = auth.FirebaseAuth.instance.currentUser;
    print(user.uid);
    final addRef =  FirebaseFirestore.instance
        .collection(StringConstant.GALLERY).doc(user.uid).collection(StringConstant.IMAGE).get();
    List<Gallery> list = [];
    await addRef.then((QuerySnapshot snapshot) {
      list = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
               print(list);
        return Gallery.fromJson(documentSnapshot.data());

      }).toList();

    }).catchError((e) {
      print(e);
    });
    return list;
  }
}

class GalleryGridView extends StatelessWidget {
  final List<Gallery> gallery;

  GalleryGridView({Key key, this.gallery}) : super(key: key);



  Card getStructuredGridCell(Gallery gallery, BuildContext context) {
    return new Card(
        elevation: 1.5,
        child: InkWell(
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) {
                return ViewImageScreen(gallery: gallery.imageURL);
              },
            ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Hero(
              tag: gallery.imageURL,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(gallery.imageURL),
                    fit: BoxFit.cover,
                  ),
                  borderRadius:
                  BorderRadius.all(Radius.circular(20.0),),
                ),
              ),
            ),
          ),
        )

        );
  }

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 0.80,

      children: List.generate(gallery.length, (index) {
        return getStructuredGridCell(gallery[index],context);
      }),
    );
  }
}