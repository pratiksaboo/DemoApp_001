import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/AppSettings.dart';
import 'package:flutter_memory/models/Blog.dart';
import 'package:flutter_memory/models/quotes.dart';
import 'package:flutter_memory/navigationDrawer/navigationDrawer.dart';
import 'package:flutter_memory/routes.dart';
import 'package:flutter_memory/ui/memories_ui/SearchScreen.dart';
import 'package:flutter_memory/ui/memories_ui/information_screen.dart';
import 'package:flutter_memory/ui/memories_ui/nominee_list_screen.dart';
import 'package:flutter_memory/ui/memories_ui/view_blog_screen.dart';
import 'package:intl/intl.dart';


class BlogScreen extends StatefulWidget {

  @override
  _CreateBlogScreenState createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<BlogScreen>{
  AppSettings appSettings;
  int quoteSize;
  bool quoteVisible =false ;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String quoteMessage;
  static String noEventText = "No event here";
  String calendarText = noEventText;
  // DateTime _currentDate;
  DateTime _currentDate = DateTime.now();
  String dateSelected = new DateFormat.yMMMMd("en_US").format(DateTime.now());
  bool _isVisible = true;
  EventList<Event> _markedDateMap = new EventList<Event>();
  List<Blog> blogList;
  List<DateTime> datesEvent = [] ;
  TextEditingController editingController = TextEditingController();
  bool _isSearchVisible = false;
  List<Blog> _searchResult = [];
  // bool enable = true;

  @override
  void initState() {
    super.initState();

    calenderMethod();
    fetchAppSettings();

  }


  @override
  void dispose() {
    super.dispose();
  }

  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.deepOrange, width: 2.0)),
    child: new Icon(
      Icons.local_florist,
       color: Colors.amber,
    ),
  );
  @override
  Widget build(BuildContext context) {

    getQuote();

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("PreMoApp" ,style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white)),

        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search,color: Colors.white,),
              onPressed: () {
                Navigator.push( context,new MaterialPageRoute(
                  builder: (context)
                  {

                    return SearchScreen();

                  },
                ),
                );
                // setState(() {
                //   _isSearchVisible = !_isSearchVisible;
                //   _isVisible = false;
                // });
              }),
          IconButton(
              icon: Icon(Icons.calendar_today,color: Colors.white,),
              onPressed: () {
                setState(() {
                  _isVisible = !_isVisible;
                  _isSearchVisible = false ;
                });
              }),
          IconButton(
              icon: Icon(Icons.person_add,color: Colors.white,),
              onPressed: () {
                Navigator.push( context,new MaterialPageRoute(
                  builder: (context)
                  {
                    return NomineeListScreen();
                  },
                ),
                );
              }),
          IconButton(
              icon: Icon(Icons.info_outline,color: Colors.white,),
              onPressed: () {
                Navigator.push( context,new MaterialPageRoute(
                  builder: (context)
                  {
                    return InformationScreen();
                  },
                ),
                );
              }),
        ],

      ),
      drawer: NavigationDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white),
        onPressed: () {

          Navigator.of(context).pushNamed(
            Routes.create_edit_blog,
          );
        },
      ),
      body: WillPopScope(
          onWillPop: () async => false, child: _buildBodySection(context)),

    );

  }

  void refresh(DateTime date) {
    print('selected date ' +
        date.day.toString() +
        date.month.toString() +
        date.year.toString() +
        ' ' +
        date.toString());
    if(_markedDateMap.getEvents(new DateTime(date.year, date.month, date.day)).isNotEmpty){
      calendarText = _markedDateMap
          .getEvents(new DateTime(date.year, date.month, date.day))[0]
          .title;
    } else{
      calendarText = noEventText;
    }
    dateSelected = new DateFormat.yMMMMd("en_US").format(date);
    _currentDate = date;
    print("date selected: "+dateSelected);
  }



  Future<List<Blog>> _fetchData() async {
    if(_isVisible){
      final auth.User user = auth.FirebaseAuth.instance.currentUser;

      final addRef = FirebaseFirestore.instance.collection(StringConstant.BLOGS).where(
          "selectedDate", isEqualTo: dateSelected).where("authorId",isEqualTo:user.uid).get();
      List<Blog> list = [];
      await addRef.then((QuerySnapshot snapshot) {
        list = snapshot.docs.map((DocumentSnapshot documentSnapshot) {

          return Blog.fromJson(documentSnapshot.data());

        }).toList();

      });
      return list;
    }else {
      final auth.User user = auth.FirebaseAuth.instance.currentUser;

      final addRef = FirebaseFirestore.instance.collection(StringConstant.BLOGS).where(
          "authorId", isEqualTo: user.uid)
          .orderBy("modifiedTimestamp",descending: true).get();
      List<Blog> list = [];
      await addRef.then((QuerySnapshot snapshot) {
        list = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
          return Blog.fromJson(documentSnapshot.data());
        }).toList();
      });

      return list;
    }

  }
  Future<List<Blog>> _fetchAllBlog() async {

    final auth.User user = auth.FirebaseAuth.instance.currentUser;

    final addRef = FirebaseFirestore.instance.collection(StringConstant.BLOGS).where(
        "authorId", isEqualTo: user.uid).get();
    List<Blog> list = [];
    await addRef.then((QuerySnapshot snapshot) {
      list = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
        return Blog.fromJson(documentSnapshot.data());
      }).toList();
    });

    return list;

  }
  getQuote() async {
   var addRef;
    String today = DateFormat.yMMMMd("en_US").format(DateTime.now());
    if(!quoteVisible)
     addRef = FirebaseFirestore.instance.collection(StringConstant.QUOTES).get();
    else
     addRef = FirebaseFirestore.instance.collection(StringConstant.QUOTES).where(
        "date", isEqualTo: today).get();
    List<Quotes> list = [];
    await addRef.then((QuerySnapshot snapshot) {
      list = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
        return Quotes.fromJson(documentSnapshot.data());
      }).toList();
      if (list.length > 0) {
        print(list.length > 0 ? list[0].quoteMessage : "");
        Random random = new Random();
        quoteMessage = (list[random.nextInt(list.length)].quoteMessage);
      }
    });
  }

  Widget _buildBodySection(BuildContext context) {
    if(_isSearchVisible==false) {
      editingController.clear();
      _searchResult.clear();
    }
    return Container(

      height: MediaQuery.of(context).size.height,
      child: Column(

        verticalDirection: VerticalDirection.down,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Visibility(
          //   visible: _isSearchVisible,
          //   child: Padding(
          //     padding: const EdgeInsets.all(4.0),
          //     child: TextField(
          //       onChanged: (value) {
          //         filterSearchResults(value);
          //       },
          //       controller: editingController,
          //       decoration: InputDecoration(
          //           labelText: "Search",
          //           hintText: "Search",
          //           prefixIcon: Icon(Icons.search),
          //           border: OutlineInputBorder(
          //               borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          //     ),
          //   ),
          // ),
          Visibility (
            // visible:quoteVisible,
            visible:true,
            child:  QuotesCard(quoteMessage: quoteMessage,quoteSize:  quoteSize),
          ),
          // QuotesCard(quoteMessage: quoteMessage,quoteSize:  quoteSize),
          Visibility (
            visible: _isVisible,
            child: Expanded(child: calendarCarousel(),flex:2),
          ),
          // Visibility (
          //   visible: _isVisible,
          //   child: calendarCarousel(),
          // ),
          SizedBox( height: 5,),
          // Expanded(child:
          //   Container(
          //     child: futureBuilder()))
          Expanded(child:
          Container(
              child:_searchResult.length != 0 || editingController.text.isNotEmpty ? searchResultList(): futureBuilder()))

        ],
      ),
    );

  }

  FutureBuilder<List<Blog>> futureBuilder() {

    return new FutureBuilder<List<Blog>>(
      future: _fetchData(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) return Center(child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
        ));
        if(! (snapshot.data.length>0)) return Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Tap + icon to write a memory.",textAlign: TextAlign.center,),
        ));
        return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,

          children:snapshot.data.map((blogModel) {

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

                leading: Hero(
                  tag: blogModel,
                  child: SizedBox(
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

              ),
            );
          },

          ).toList(),

        );
      },);
  }

  CalendarCarousel<Event> calendarCarousel() {
    return CalendarCarousel(
      height: 370,
      headerMargin: EdgeInsets.all(4.0) ,
      headerTextStyle:TextStyle(fontWeight: FontWeight.bold, fontSize: 18,
        color: Colors.deepOrange,
      ),
      dayPadding: 0.0 ,
      weekDayPadding: EdgeInsets.all(0.0) ,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      weekFormat: false,
      selectedDayBorderColor: Colors.orange,
      selectedDateTime: _currentDate,

      markedDatesMap: _markedDateMap,
      selectedDayButtonColor: Colors.orange,
      selectedDayTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
      todayBorderColor: Colors.transparent,
      weekdayTextStyle: TextStyle(color: Colors.black),
      daysHaveCircularBorder: true,
      todayButtonColor: Colors.deepOrange,
      leftButtonIcon: Icon(
        Icons.arrow_back_ios_rounded,
        size: 16.0,
        color: Colors.deepOrange,
      ),
      rightButtonIcon: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16.0,
        color: Colors.deepOrange,
      ),

      onDayPressed: (DateTime date, List<Event> events) {

        setState(() {
          refresh(date);

        });

      },
    );
  }

  void calenderMethod() async{
    print("inside calender method");
    Future<List<Blog>> _futureOfList = _fetchAllBlog();
    blogList = await _futureOfList;
    if (blogList.length > 0)
     datesEvent.clear();
    for (int i = 0; i < blogList.length; i++) {
      Blog blog = blogList[i];
      print(blog.selectedDate);
      String str1 = blog.selectedDate;
      List<String> str2 = str1.split(',');
      int year = int.parse(str2[1]);
      List<String> str3 = str2[0].split(' ');
      int day = int.parse(str3[1]);
      int month = StringConstant.monthsInYear[str3[0]];

      datesEvent.add(DateTime(year, month, day));
    }

    if(datesEvent.length>0)
    {
      addMarker(DateTime(2020, 1, 01));
    }
  }

  addMarker(DateTime startEventDateTime) {

    for(int i=0;i<datesEvent.length ; i++){

if(datesEvent[i] !=null)
      _markedDateMap.add(
          datesEvent[i],
          new Event(
            date: datesEvent[i],
            icon: _eventIcon ,
            dot: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              color: Colors.deepOrange,
              height: 4.0,
              width: 4.0,
            ),
          ));


    }
    setState(() {

    });

  }

  void filterSearchResults(String text) {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    blogList.forEach((blog) {
      if (blog.content.title.toLowerCase().contains(text.toLowerCase())) _searchResult.add(blog);
    });

    setState(() {});

  }

  Widget searchResultList() {
    return new ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, i) {
        return new ListTile(
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

          subtitle: Text(
              _searchResult[i].content.body
              , style: TextStyle(fontSize: 18.0,

              color: Colors.black87)),

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

        );
      },
    );
  }

  fetchAppSettings() async {

    final addRef = FirebaseFirestore.instance.collection(StringConstant.APP_SETTING).doc(StringConstant.GLOBAL_CONSTANT).get();
    appSettings =  await addRef.then((userDetails1) {
      return AppSettings.fromJson(userDetails1.data());
    });
    setState(() {
      if(appSettings !=null && appSettings.quoteFontSize != null)
      {
        quoteSize = appSettings.quoteFontSize;
      }
      if(appSettings!=null && appSettings.showQuoteByDate!=null )
        quoteVisible = appSettings.showQuoteByDate;
    });
  }
}

class QuotesCard extends StatelessWidget {


  const QuotesCard({
    Key key,
    @required this.quoteMessage, this.quoteSize,
  }) : super(key: key);
  final int quoteSize;
  final String quoteMessage;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Column(

            children: <Widget>[
              Container(
                  color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("Quote of the Day" ,style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white)
                    )),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(quoteMessage !=null ? quoteMessage : "All is well" ,style: TextStyle(fontSize: quoteSize!=null ? quoteSize.toDouble() : 18.0, fontWeight: FontWeight.normal, color: Colors.blueGrey)

                    )),
              ),
            ]));
  }
}
































