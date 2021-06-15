import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/user.dart' as User;
import 'package:flutter_memory/navigationDrawer/navigationDrawer.dart';
import 'package:flutter_memory/ui/memories_ui/view_user_details_screen.dart';

class UserListScreen extends StatefulWidget {

  @override
  _ShowBlogScreenState createState() => _ShowBlogScreenState();
}

class _ShowBlogScreenState extends State<UserListScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // List<User.User> blogList = [];
  List<User.User> list = [];
  TextEditingController editingController = TextEditingController();
  List<User.User> _searchResult = [];

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
        title: Text("Memories Users", style: TextStyle(fontSize: 18.0,
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

      body: WillPopScope(
          onWillPop: () async => false, child: _buildBodySection(context)),

    );
  }


  Future<List<User.User>> _fetchData() async {
   list.clear();

    final addRef = FirebaseFirestore.instance.collection(StringConstant.USER).get();
    // List<User.User> list = [];
    await addRef.then((QuerySnapshot snapshot) {
      list = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
        return User.User.fromJson(documentSnapshot.data());
      }).toList();
    });

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
                prefixIcon: Icon(Icons.search),
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.orange),

                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                // border: OutlineInputBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(25.0)))),
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

  FutureBuilder<List<User.User>> futureBuilder() {
    return new FutureBuilder<List<User.User>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),));
        if (!(snapshot.data.length > 0)) return Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "No users to show.",
            textAlign: TextAlign.center,),
        ));
        return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,

          children: snapshot.data.map((blogModel) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text(
                      blogModel != null && blogModel.emailId != null ? blogModel
                          .emailId : "", style: TextStyle(fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),

                  onTap: () {
                    Navigator.push(context, new MaterialPageRoute(
                      builder: (context) {
                        return ViewUserDetailsScreen(user : blogModel);
                      },
                    ),
                    );
                  },

                  subtitle: Text(
                      blogModel != null && blogModel.userName != null && blogModel.contactNumber != null ? blogModel
                          .userName +"\n" +blogModel.countryCode+" "+ blogModel.contactNumber: "", style: TextStyle(fontSize: 18.0,
                      color: Colors.black87),maxLines:2),

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
    list.forEach((blog) {
      if (blog.emailId.toLowerCase().contains(
          text.toLowerCase()))
        _searchResult.add(blog);
        else if (blog.contactNumber.toLowerCase().contains(
          text.toLowerCase()))
        _searchResult.add(blog);
          else if (blog.userName.toLowerCase().contains(
          text.toLowerCase()))
        _searchResult.add(blog);

        // _searchResult.add(blog);
    });

    setState(() {});
  }

  Widget searchResultList() {
    return new ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: new ListTile(
              title: Text(
                  _searchResult[i].emailId , style: TextStyle(fontSize: 18.0,
                  fontWeight: FontWeight.bold,

                  color: Colors.black)),

              onTap: () {
                Navigator.push(context, new MaterialPageRoute(
                  builder: (context) {
                    return ViewUserDetailsScreen(user : _searchResult[i]);
                  },
                ),
                );
              },

              subtitle: Text(
                  _searchResult[i] != null && _searchResult[i].userName != null && _searchResult[i].contactNumber != null ? _searchResult[i]
                      .userName +"\n" +_searchResult[i].countryCode+" "+ _searchResult[i].contactNumber: "", style: TextStyle(fontSize: 18.0,
                  color: Colors.black87),maxLines:2),

            ),
          ),



          );

      },
    );
  }
}

















