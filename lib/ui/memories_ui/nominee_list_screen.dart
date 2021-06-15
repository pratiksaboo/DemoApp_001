import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/nominee.dart';
import 'package:flutter_memory/navigationDrawer/navigationDrawer.dart';
import 'package:flutter_memory/routes.dart';
import 'package:flutter_memory/ui/memories_ui/add_nominee_screen.dart';

class NomineeListScreen extends StatefulWidget {
  @override
  _NomineeListScreenState createState() => _NomineeListScreenState();
}

class _NomineeListScreenState extends State<NomineeListScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Nominee> nomineeList = [];
  bool visible = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Nominees",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white)),
      ),
      drawer: NavigationDrawer(),

      floatingActionButton: Visibility(
        visible: !visible ? false : true,
        // visible: !visible  && nomineeList.length> 2? false : true,
        // visible: nomineeList.length> 2 ? false : true,
        child: FloatingActionButton(
          child: Icon(Icons.add,color: Colors.white,),
          onPressed: () {
            print(nomineeList.length);
            if(visible)
            Navigator.of(context).pushNamed(
              Routes.create_edit_nominee,
            );
          },
        ),
      ),
      body: WillPopScope(
          onWillPop: () async => false, child: _buildBodySection(context)),
    );
  }

  Widget _buildBodySection(BuildContext context) {

    return  Container(
      padding: const EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<List<Nominee>>(
        future: _fetchData(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),));
          nomineeList = snapshot.data;
          if(! (snapshot.data.length>0)) return Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("No nominees added yet. Click on the + icon to add your first nominee.",textAlign: TextAlign.center,),
          ));

          return Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              verticalDirection: VerticalDirection.down,
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[

                Visibility(
                  visible: (nomineeList.length>0)?true:false,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: snapshot.data
                        .map((nomineeModel) =>Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          elevation: 2,
                          color: Colors.white,

                          child: InkWell(
                            onTap: () {
                              print(nomineeModel.nomineeId.toString());
                              Navigator.push( context,new MaterialPageRoute(
                                builder: (context)
                                {
                                  return AddNomineeScreen(nominee: nomineeModel);
                                },
                              ),
                              );
                              // Function is executed on tap.
                            },
                            child :new Container(
                              padding: new EdgeInsets.only(left:16.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(nomineeModel!=null && nomineeModel.nomineeName != null ? nomineeModel.nomineeName:"",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black87)),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(nomineeModel!=null && nomineeModel.nomineeEmail != null ? nomineeModel.nomineeEmail:"",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black87)),
                                  ),



                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(nomineeModel!=null && nomineeModel.nomineeContact != null && nomineeModel.countryCode != null ? nomineeModel.countryCode + nomineeModel.nomineeContact:nomineeModel!=null && nomineeModel.nomineeContact != null && nomineeModel.countryCode == null ?  nomineeModel.nomineeContact:"",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black87)),
                                         // child: Text(nomineeModel!=null && nomineeModel.nomineeContact != null ? nomineeModel.nomineeContact:"",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black87)),
                                  ),

                                ],
                              ),
                            ),
                          )


                      ),
                    ),

                    )
                        .toList(),

                  ),
                ),
              // Visibility(
                //   visible: nomineeList.length> 2 ? false : true,
                //   child: Expanded(
                //
                //     child: Align(
                //       alignment: Alignment.bottomRight,
                //       child: FloatingActionButton(
                //         elevation: 4,
                //         child: Icon(Icons.add,color: Colors.white,),
                //         onPressed: () {
                //           Navigator.of(context).pushNamed(
                //             Routes.create_edit_nominee,
                //           );
                //         },
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },

      ),
    );

  }

  Future<List<Nominee>> _fetchData() async {
    String userId;

    final auth.User user = auth.FirebaseAuth.instance.currentUser;
    userId = user.uid;
    final addRef = FirebaseFirestore.instance
        .collection(StringConstant.USER).doc(userId).collection(StringConstant.NOMINEE).get();

    List<Nominee> list = [];
    await addRef.then((QuerySnapshot snapshot) {
      list = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
        return Nominee.fromJson(documentSnapshot.data());
      }).toList();
    });
    print(list.length);
    if(list.length <= 2)
    visible = true;
    else  visible = false;



    setState(() {

    });

    return list;
  }

  @override
  void initState() {
    visible = false;
  }
}

