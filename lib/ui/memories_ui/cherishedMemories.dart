import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/Blog.dart';
import 'package:flutter_memory/models/user.dart';
import 'package:flutter_memory/navigationDrawer/navigationDrawer.dart';
import 'package:flutter_memory/ui/memories_ui/view_blog_screen.dart';

import '../../routes.dart';

class CherishedScreen extends StatefulWidget {
  @override
  CherishedScreenState createState() => CherishedScreenState();
}

class CherishedScreenState extends State<CherishedScreen>{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  User userDetails;

  @override
  void initState() {
    super.initState();
    // fetchUser();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cherished Memories" ,style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: ()  {
              Navigator.pushReplacementNamed(context, Routes.home);

          },
        ),

      ),
      drawer: NavigationDrawer(),

      body: WillPopScope(
          onWillPop: () async => false, child: _buildBodySection(context)),

    );

  }




  Future<List<Blog>> _fetchData() async {

      final auth.User user = auth.FirebaseAuth.instance.currentUser;

      final addRef = FirebaseFirestore.instance.collection(StringConstant.BLOGS).where(
          // "isCherishedMemory", isEqualTo: true).where("authorId",isEqualTo:user.uid).getDocuments();
          "isCherishedMemory", isEqualTo: true).where("authorId",isEqualTo:user.uid).orderBy("modifiedTimestamp",descending: true).get();
      List<Blog> list = [];
      await addRef.then((QuerySnapshot snapshot) {
        list = snapshot.docs.map((DocumentSnapshot documentSnapshot) {

          return Blog.fromJson(documentSnapshot.data());

        }).toList();

      });
      return list;


  }



  Widget _buildBodySection(BuildContext context) {
    return new FutureBuilder<List<Blog>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
          ));
          if(! (snapshot.data.length>0)) return Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("No Cherished Memory found.",textAlign: TextAlign.center,),
          ));
         return ListView(
           scrollDirection: Axis.vertical,
           shrinkWrap: true,
            children: snapshot.data
                .map((blogModel) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(

              title: Text(blogModel != null && blogModel.content != null ? blogModel
                            .content.title : "",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black)),

              onTap: () {
                  Navigator.push(context, new MaterialPageRoute(
                        builder: (context) {
                          return ViewBlogScreen(blog: blogModel);

                        },
                      ),
                      );
              },

              // subtitle: Text( blogModel != null && blogModel.content != null ? blogModel
              //             .content.body : "" ,style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black87) ,maxLines:2),


              leading: Hero(
                  tag: blogModel,
                  child: SizedBox(
                    height: 72.0,
                    width: 72.0,
                      child: blogModel.content.thumbnailUrl == null
                            ? Image(
                            image: AssetImage('images/icon.png'),
                            fit: BoxFit.fill
                        )
                            : Image.network(
                            blogModel.content.thumbnailUrl, fit: BoxFit.cover),
                      ),
              ),

            ),
                ))
                .toList(),

          );
    },
    );

  }
}
















