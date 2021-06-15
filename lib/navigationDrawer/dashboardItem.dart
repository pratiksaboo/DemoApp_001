import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memory/routes.dart';


Card makeDashboardItem(String title, IconData icon,Color color, String route, BuildContext context) {
  return Card(
    elevation: 10,
    color: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      side: BorderSide(
          color: Colors.white
      ),

    ),
    child: InkWell(
      onTap: () {
    switch(route){
              case Routes.home:
                return  Navigator.pushReplacementNamed(context, Routes.home);
                break;
             case Routes.cherishedMemories:
              return  Navigator.pushReplacementNamed(context, Routes.cherishedMemories);
              break;
              case Routes.setting:
                return  Navigator.pushReplacementNamed(context, Routes.setting);
                break;

              default:
                return  Navigator.pushReplacementNamed(context, Routes.home);
            }

      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,size:40,
              color: Colors.white,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title ,style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    ),
  );
//Card makeDashboardItem(String title, IconData icon, String route, BuildContext context) {
//  return Card(
//      elevation: 1.0,
//      margin: new EdgeInsets.all(8.0),
//      child: Container(
//        decoration: BoxDecoration(color: Colors.green),
////        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
//        child: new InkWell(
//          splashColor: Colors.lightGreen,
//          onTap: () {
//            switch(route){
//              case routes.dashboard:
//                return  Navigator.push(
//                      context, MaterialPageRoute(builder: (context) => Dashboard()));
////                  Navigator.pushReplacementNamed(context, routes.home);
//
//              case routes.address:
//                return Navigator.push(
//                    context, MaterialPageRoute(builder: (context) => AddressList()));
//
//
//              default:
//                return Navigator.push(
//                    context, MaterialPageRoute(builder: (context) => Dashboard()));
//            }
////            Navigator.pushReplacementNamed(context,routes);
//          },
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            mainAxisSize: MainAxisSize.min,
//            verticalDirection: VerticalDirection.down,
//            children: <Widget>[
//              SizedBox(height: 50.0),
//              Center(
//                  child: Icon(
//                    icon,
//                    size: 40.0,
//                    color: Colors.white,
//                  )),
//              SizedBox(height: 20.0),
//              new Center(
//                child: new Text(title,
//                    style:
//                    new TextStyle(fontSize: 18.0, color: Colors.white)),
//              )
//            ],
//          ),
//        ),
//      ));
}