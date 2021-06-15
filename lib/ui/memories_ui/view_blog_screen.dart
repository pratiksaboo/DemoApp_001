import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memory/app_localizations.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/Blog.dart';
import 'package:flutter_memory/routes.dart';

import 'edit_blog_screen.dart';

class ViewBlogScreen extends StatefulWidget {
  final Blog blog;

  ViewBlogScreen({Key key, @required this.blog}) : super(key: key);

  @override
  ViewBlogScreenState createState() => ViewBlogScreenState(blog);
}

class ViewBlogScreenState extends State<ViewBlogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Blog blog;
  bool _loading = false;
  auth.User user;

  ViewBlogScreenState(this.blog);

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  warnDeleteDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Memory?'),
            content: Text('Are you sure of deleting memory?'),
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
                  if (blog.content.thumbnailUrl != null) {
                    deleteStorage(blog.content.thumbnailUrl);
                    // FirebaseStorage.instance
                    // .refFromURL(blog.content.thumbnailUrl).delete().then((value) => deleteFromGallery()) .catchError((e) => print(e));
                  }
                  else {
                    deleteBlog();
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(blog != null
            ? AppLocalizations.of(context).translate(
            "todosCreateEditAppBarTitleEditTxt")
            : AppLocalizations.of(context).translate(
            "todosCreateEditAppBarTitleNewTxt"),
            style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit, color: Colors.white,),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(
                  builder: (context) {
                    return EditBlogScreen(blog: blog);
                  },
                ),
                );
              }),
          IconButton(
              icon: Icon(Icons.delete, color: Colors.white,),
              onPressed: () {
                warnDeleteDialog();
                // if(blog.content.thumbnailUrl !=null){
                //   FirebaseStorage.instance
                //       .getReferenceFromUrl(blog.content.thumbnailUrl)
                //       .then((reference) {reference.delete();
                //         deleteFromGallery();
                //       })
                //       .catchError((e) => print(e));
                // }
                // else {
                //   deleteBlog();
                //
                // }

              }),
        ],
      ),
      body: Center(child: _buildForm(context)),


    );
  }

  showAlertDialog(BuildContext context, bool status) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.of(context).pushNamed(Routes.home,
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(status ? "Success" : "Error"),
      content: Text(status
          ? "Deleted Successfully"
          : "Error in Saving. Please try again later"),
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

  Widget _progressIndicator() {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),),
      );
    } else {
      return Container();
    }
  }


  @override
  void dispose() {
    super.dispose();
  }


  Widget _buildForm(BuildContext context) {
    return new Container(

      height: MediaQuery
          .of(context)
          .size
          .height,
      child: SingleChildScrollView(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if(blog != null && blog.content != null &&
                            blog.content.thumbnailUrl != null)
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Hero(
                              tag: blog,
                              child: SizedBox(
                                  height: 300.0,
                                  width: 100.0,
                                  child: Image.network(
                                      blog.content.thumbnailUrl,
                                      fit: BoxFit.contain)
                              ),
                            ),
                          ),
                        BlogContentWidget(blog: blog),
                        OtherInfoWidget(blog: blog),
                      ],
                    ),

                  ),
                ),

              ),
              _progressIndicator(),

              //your elements here
            ],
          )),);
  }

  Future<void> deleteFromGallery() async {
    // final auth.User user = auth.FirebaseAuth.instance.currentUser;
    print(user.uid);
    FirebaseFirestore.instance
        .collection('GALLERY').doc(user.uid).collection("IMAGE").doc(
        blog.blogId)
        .delete().then((result) {
      showAlertDialog(context, true);
      deleteBlog();
    }
    )
        .catchError((err) {
      print(err);
    });
  }

  void deleteBlog() {
    FirebaseFirestore.instance
        .collection(StringConstant.BLOGS).doc(blog.blogId)
        .delete().then((result) {
      showAlertDialog(context, true);
    }
    )
        .catchError((err) {
      print(err);
    });
  }

  Future<void> fetchCurrentUser() async {
    user = auth.FirebaseAuth.instance.currentUser;
  }

  Future<void> deleteStorage(String thumbnailUrl) async {
    String fileName = thumbnailUrl.replaceAll("/o/", "*").replaceAll("%40", "@").replaceAll("%2F", "/");
    fileName = fileName.replaceAll("?", "*");
    fileName = fileName.split("*")[1];
    print(fileName);
    Reference storageReferance = FirebaseStorage.instance.ref();
    storageReferance
        .child(fileName)
        .delete()
        .then((_) => print('Successfully deleted $fileName storage item'))
        .then((value) => deleteFromGallery());
  }


}




class OtherInfoWidget extends StatelessWidget {
  const OtherInfoWidget({
    Key key,
    @required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    var buffer = new StringBuffer();
    String m;
    String n;
    if(blog != null && blog.nominee != null && blog.nominee.nomineeName != null){
      List<String> str = blog.nominee.nomineeName.split(' ');
      m = str[0];
      buffer.write(m);
    }
    if(blog != null && blog.nominee2 != null && blog.nominee2.nomineeName != null){
      List<String> str = blog.nominee2.nomineeName.split(' ');
      n = str[0];
      buffer.write(" and ");
      buffer.write(n);
    }
    return Visibility(
      visible:  blog != null && (blog.nominee != null || (blog.meta != null && blog.meta.weather != null && blog.meta.weather.address != null) )? true : false,
      child: Card(
        margin: EdgeInsets.fromLTRB(2,4,0,12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children:<Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child:  Text( "Other Info",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            ),
            Visibility(
              visible: blog != null && (blog.nominee != null || blog.nominee2 != null) ? true : false,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text( blog != null && (blog.nominee != null || blog.nominee2 != null) && buffer!=null ? "Nominee: "+buffer.toString() :""),
                // child: Text( blog != null && blog.nominee != null ? "Nominee: "+blog.nominee.nomineeName :""),
              ),
            ),
               Visibility(
                 visible: blog != null && blog.meta != null && blog.meta.weather != null&& blog.meta.weather.address != null ? true : false,
                 child: Padding(
                   padding: const EdgeInsets.all(8),
                  child: Text( blog != null && blog.meta != null && blog.meta.weather != null&& blog.meta.weather.address != null? "Location "+blog.meta.weather.address:""),
              ),
               ),
            Visibility(
              visible: blog != null && blog.meta != null && blog.meta.weather != null && blog.meta.weather.tempCelsius  != null ? true : false,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text( blog != null && blog.meta != null && blog.meta.weather != null&& blog.meta.weather.tempCelsius != null? "Weather "+blog.meta.weather.tempCelsius:""),
              ),
            ),

                  ],
          ),
        ),
    );
  }
}

class BlogContentWidget extends StatelessWidget {
  const BlogContentWidget({
    Key key,
    @required this.blog,
  }) : super(key: key);

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(2,12,0,12),
      // margin: EdgeInsets.only(top:12.0) ,
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),

            child: Text( blog != null && blog.content != null && blog.content.title != null?blog.content.title:"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
          ),
          Row(

            children: <Widget> [
              Icon(blog != null && blog.isCherishedMemory != null && blog.isCherishedMemory ? (Icons.star):(Icons.star_border) ),
              Padding(
                padding: const EdgeInsets.all(8),

                child: Text( blog != null ? blog.selectedDate :""),
              ),
            ],),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text( blog != null && blog.content != null && blog.content.body != null?blog.content.body:""),
          ),
        ],
      ),
    );
  }
}
