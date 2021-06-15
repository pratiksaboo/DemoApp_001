import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/Blog.dart';
import 'package:flutter_memory/navigationDrawer/navigationDrawer.dart';
import 'package:flutter_memory/ui/memories_ui/view_blog_screen.dart';



class SearchScreen extends StatefulWidget {

  @override
  _ShowBlogScreenState createState() => _ShowBlogScreenState();
}

class _ShowBlogScreenState extends State<SearchScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Blog> blogList = [];
  TextEditingController editingController = TextEditingController();
  List<Blog> _searchResult = [];

  @override
  void initState() {
    super.initState();
    // _fetchData();
  }


  @override
  void dispose() {
    super.dispose();
    editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Memories", style: TextStyle(fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {

            Navigator.of(context).pop();
          },
        ),
      ),
      drawer: NavigationDrawer(),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add, color: Colors.white),
      //   onPressed: () {
      //     Navigator.of(context).pushNamed(
      //       Routes.create_edit_blog,
      //     );
      //   },
      // ),
      body: WillPopScope(
          onWillPop: () async => false, child: _buildBodySection(context)),

    );
  }


  Future<List<Blog>> _fetchData() async {
    blogList.clear();
    final auth.User user = auth.FirebaseAuth.instance.currentUser;

    final addRef = FirebaseFirestore.instance.collection(StringConstant.BLOGS).where(
        "authorId", isEqualTo: user.uid).get();
    List<Blog> list = [];
    await addRef.then((QuerySnapshot snapshot) {
      list = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
        return Blog.fromJson(documentSnapshot.data());
      }).toList();
    });
    blogList.addAll(list) ;
    return list;
  }


  Widget _buildBodySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextField(
            onChanged: (value) {
              filterSearchResults(value);
            },

            controller: editingController,
            decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search,color: Colors.orange,),
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.orange),

                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
        ),

        SizedBox(height: 5,),
       
        Expanded(child:
        Container(
            child: _searchResult.length != 0 ||
                editingController.text.isNotEmpty
                ? searchResultList()
                : futureBuilder()))

      ],
    );
  }

  FutureBuilder<List<Blog>> futureBuilder() {
    return new FutureBuilder<List<Blog>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
          ));
        if (!(snapshot.data.length > 0)) return Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "No memories to show.",
            textAlign: TextAlign.center,),
        ));
        return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,

          children: snapshot.data.map((blogModel) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                    blogModel != null && blogModel.content != null ? blogModel
                        .content.title : "", style: TextStyle(fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),

                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(
                    builder: (context) {
                      return ViewBlogScreen(blog: blogModel);
                    },
                  ),
                  );
                },

                // subtitle: Text(
                //     blogModel != null && blogModel.content != null ? blogModel
                //         .content.body : "", style: TextStyle(fontSize: 18.0,
                //     color: Colors.black87),maxLines:2),

                leading: SizedBox(
                  height: 72.0,
                  width: 72.0,
                  child: blogModel.content.thumbnailUrl == null
                      ? Image(
                      image: AssetImage('images/icon.png'),
                      fit: BoxFit.cover
                  )
                      : Image.network(
                      blogModel.content.thumbnailUrl, fit: BoxFit.cover),
                ),

              ),
            );
          },

          ).toList(),

        );
      },);
  }


  void filterSearchResults(String text) {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    blogList.forEach((blog) {
      if (blog.content.title.toLowerCase().contains(
          text.toLowerCase())) _searchResult.add(blog);
    });

    setState(() {});
  }

  Widget searchResultList() {
    return new ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: new ListTile(
            title: Text(
                _searchResult[i].content.title, style: TextStyle(fontSize: 18.0,
                fontWeight: FontWeight.bold,

                color: Colors.black)),

            onTap: () {
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) {
                  return ViewBlogScreen(blog: _searchResult[i]);
                },
              ),
              );
            },

            // subtitle: Text(
            //     _searchResult[i].content.body
            //     , style: TextStyle(fontSize: 18.0,
            //
            //     color: Colors.black87)),

            leading: SizedBox(
              height: 72.0,
              width: 72.0,
              child: _searchResult[i].content.thumbnailUrl == null
                  ? Image(
                  image: AssetImage('images/icon.png'),
                  fit: BoxFit.cover
              )
                  : Image.network(
                  _searchResult[i].content.thumbnailUrl, fit: BoxFit.cover),
            ),

          ),
        );
      },
    );
  }
}

















