import 'package:flutter/material.dart';
import 'package:flutter_memory/ui/memories_ui/blog_screen.dart';
import 'package:flutter_memory/ui/memories_ui/cherishedMemories.dart';
import 'package:flutter_memory/ui/memories_ui/gallery_screen.dart';
import 'package:flutter_memory/ui/setting/setting_screen.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final int pageIndex ;
  BottomNavigationBarWidget({Key key, @required this.pageIndex}) : super(key: key);
  @override
  _MyBottomBarDemoState createState() => new _MyBottomBarDemoState(pageIndex);
}

class _MyBottomBarDemoState extends State<BottomNavigationBarWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _pageIndex = 0;
  int pageIndex;
  PageController _pageController;

  List<Widget> tabPages = [
    BlogScreen(),
    GalleryScreen(),
    CherishedScreen(),
    SettingScreen()
  ];

  _MyBottomBarDemoState(this.pageIndex);

  @override
  void initState(){
    super.initState();
    // fetchUser();
    print(pageIndex);
    if(pageIndex !=null) _pageIndex = pageIndex;

    _pageController = PageController(initialPage: _pageIndex);

  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return  StringConstant.networkStat == false ?  Scaffold(
    //   key: _scaffoldKey,
    //   body: Container(
    //
    //       child : Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //
    //             children: <Widget>[
    //
    //               Icon(Icons.signal_wifi_off,color: Colors.deepOrange,size: 100,),
    //               Text(
    //                 "No internet connection!",
    //                 style: TextStyle(
    //                     color: Colors.blueGrey,
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 20.0),
    //               ),
    //
    //             ],
    //           ))
    //   ),
    // ) :
    return  Scaffold(
      key: _scaffoldKey,
      // drawer: NavigationDrawer(),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.white,
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        backgroundColor: Colors.orangeAccent,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem( icon: Icon(Icons.home,color:_pageIndex == 0
              ? Colors.blueGrey: Colors.white,), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.photo_library,color:_pageIndex == 1
              ? Colors.blueGrey: Colors.white,), label:"Gallery"),
          BottomNavigationBarItem(icon: Icon(Icons.star,color: _pageIndex == 2
              ? Colors.blueGrey: Colors.white,), label: "Cherished"),
          BottomNavigationBarItem(icon: Icon(Icons.settings,color:_pageIndex == 3
              ? Colors.blueGrey: Colors.white,), label: "Settings"),
        ],

      ),

      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {

    this._pageController.animateToPage(index,duration: const Duration(milliseconds: 500),curve: Curves.easeInOut);
  }

}