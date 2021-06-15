import 'package:flutter/material.dart';

import 'Utility/bottom_navigation_bar.dart';

class MainScreen extends StatelessWidget {

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: BottomNavigationBarWidget(pageIndex: 0),

    );


  }
}

// class MainScreen extends StatefulWidget {
//   @override
//   MainScreenState createState() => MainScreenState();
// }
//
// class MainScreenState extends State<MainScreen>{
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//
//
//   @override
//   void initState() {
//
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//
//
//
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: NavigationDrawer(),
//
//       body: StreamProvider<NetworkStatus>(
//         create: (context) =>
//         NetworkStatusService().networkStatusController.stream,
//         child: NetworkAwareWidget(
//           onlineChild: Container(
//             child: BottomNavigationBarWidget(),
//           ),
//           offlineChild:  Scaffold(
//
//               body: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//
//                     children: <Widget>[
//
//                       Icon(Icons.signal_wifi_off,color: Colors.deepOrange,size: 100,),
//                       Text(
//                         "No internet connection!",
//                         style: TextStyle(
//                             color: Colors.blueGrey,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20.0),
//                       ),
//
//                     ],
//                   ))
//           ),
//
//         ),
//       ),
//
//     );
//
//   }
//
//
// }
//
