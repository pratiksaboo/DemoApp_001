import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/quotes.dart';
import 'package:flutter_memory/navigationDrawer/navigationDrawer.dart';
import 'package:flutter_memory/routes.dart';
import 'package:flutter_memory/ui/memories_ui/add_quotes.dart';


class QuotesScreen extends StatefulWidget {
  @override
  _QuotesScreenState createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        title: Text("Quotes",style: TextStyle(color: Colors.white)),
      ),
      drawer: NavigationDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
        onPressed: () {
          Navigator.of(context).pushNamed(
            Routes.create_edit_quote,
          );
        },
      ),
      body: WillPopScope(
          onWillPop: () async => false, child: _buildBodySection(context)),
    );
  }

  Widget _buildBodySection(BuildContext context) {

    return  Container(
        padding: const EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height,
    // return new Column(
    //
    //   children: <Widget>[
       child: FutureBuilder<List<Quotes>>(
          future: _fetchData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),));
            if(! (snapshot.data.length>0)) return Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("No Quotes added yet. Click on the + icon to add quotes.",textAlign: TextAlign.center,),
            ));
            return SingleChildScrollView(
              child:Column(
                // Stretch the cards in horizontal axis
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: snapshot.data
                        .map((quotesModel) =>Card(
                         elevation: 2,

                        color: Colors.white,
                        // shape: RoundedRectangleBorder(
                        //   side: BorderSide(color: Colors.deepOrangeAccent, width: 1),
                        //   borderRadius: BorderRadius.circular(10),
                        //
                        // ),
                        child: InkWell(
                          onTap: () {
                            print(quotesModel.quoteId.toString());
                      Navigator.push( context,new MaterialPageRoute(
                           builder: (context)
                            {
                              return AddQuoteScreen(quote: quotesModel);
                            },
                      ),
                      );
                            // Function is executed on tap.
                          },
                          child :new Container(
                            padding: new EdgeInsets.all(8.0),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text(quotesModel!=null && quotesModel.quoteMessage != null ? quotesModel.quoteMessage:"",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black87)),
                                ),

                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text(quotesModel!=null && quotesModel.date != null ? quotesModel.date:"",style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.black87)),
                                ),


                              ],
                            ),
                          ),
                        )


                    ),

                    )
                        .toList(),

                  ),

                ],
              ),

            );
          },

        ),
      // ],
    // )
    );
  }

  Future<List<Quotes>> _fetchData() async {

    final addRef = FirebaseFirestore.instance.collection(StringConstant.QUOTES).orderBy("modifiedTimestamp",descending: true).get();
    List<Quotes> list = [];
    await addRef.then((QuerySnapshot snapshot) {
      list = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
        return Quotes.fromJson(documentSnapshot.data());
      }).toList();
    });
  setState(() {

  });
    return list;
  }
}
