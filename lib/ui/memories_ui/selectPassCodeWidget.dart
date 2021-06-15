import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_memory/models/PassCode.dart';

class SelectPassCodeWidget extends StatefulWidget {
  final  bool isSupported;
  final  bool isBiometricsAvailable;
  // const SelectPassCodeWidget({Key key, @required this.isSupported}) : super(key: key);
  const SelectPassCodeWidget({Key key, @required this.isSupported, @required this.isBiometricsAvailable}) : super(key: key);

  @override
  _SelectPassCodeWidgetState createState() => _SelectPassCodeWidgetState(isSupported,isBiometricsAvailable);
}

class _SelectPassCodeWidgetState extends State<SelectPassCodeWidget> {
  final _formKey = GlobalKey<FormState>();

  bool noPassCode = false;
  final  bool isSupported;
  final bool isBiometricsAvailable;
  bool isSystemLock = false;
  TextEditingController _passwordController = TextEditingController(text: "");

  _SelectPassCodeWidgetState(this.isSupported,this.isBiometricsAvailable);


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return  new Container(


      child: SingleChildScrollView(
          child:Column(

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
                        Visibility(
                          visible: false,
                          // visible: (isSupported !=null && isSupported) && (isBiometricsAvailable !=null && isBiometricsAvailable) ? true  : false,
                          child: Row(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Use System Lock"),
                                ),
                              ),
                              Switch(
                                value: isSystemLock,
                                onChanged: (value){
                                  setState(() {
                                    isSystemLock = value;
                                    if(isSystemLock) _passwordController.clear();
                                    print(isSystemLock);
                                  });
                                },
                                activeTrackColor: Colors.orangeAccent,
                                activeColor: Colors.deepOrange,
                              ),

                            ],
                          ),
                        ),
                        Visibility(
                          visible: false,
                          // visible:isSupported !=null && isSupported && isBiometricsAvailable !=null && isBiometricsAvailable ? true : false,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("OR"),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Create New Pin"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            enabled: !noPassCode,
                            // enabled: !isSystemLock ,
                            obscureText: true,
                            maxLength: 4,
                            controller: _passwordController,
                            style: Theme.of(context).textTheme.bodyText2,
                            validator: (value){
                              if(!noPassCode){
                                // if(!isSystemLock) {
                                if (value.isEmpty || value.length < 4)
                                  return 'Please Enter Password';
                                // if (!(Validate.isNumeric(value)))
                                //   return 'Please Enter only digits';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blueGrey,
                                ),
                                labelText: "Pass Code",
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width:0.0)),
                                border: OutlineInputBorder()
                            ),

                          ),
                        ),
                        Visibility(
                          visible: true,
                          // visible:isSupported !=null && isSupported ? true : false,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("OR"),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Register without Passcode"),
                              ),
                            ),
                            Switch(
                              value: noPassCode,
                              onChanged: (value){
                                setState(() {
                                  noPassCode = value;
                                  if(noPassCode) _passwordController.clear();
                                  print(noPassCode);
                                });
                              },
                              activeTrackColor: Colors.orangeAccent,
                              activeColor: Colors.deepOrange,
                            ),

                          ],
                        ),


                        SizedBox(
                          width: 320.0,
                          child: ElevatedButton(
                            onPressed: () async {
                              _formKey.currentState.save();
                              final form = _formKey.currentState;
                              // form.save();
                              if (form.validate()) {
                                PassCodes passCode = new PassCodes();
                                passCode.isSystemLock = isSystemLock;
                                passCode.password = _passwordController.text;
                                passCode.noPassCode = noPassCode;
                                // if(!isSystemLock)  passCode.password = _passwordController.text;
                                // else  passCode.password = null;
                                Navigator.pop(context, passCode);

                              }
                            },
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
      ),
                          ),
                        )
                      ],
                    ),

                  ),

                ),

              ),

              //your elements here
            ],
          ) ),);
  }


  @override
  void dispose() {

    _passwordController.dispose();
    super.dispose();
  }
}
// class SelectPassCodeWidget extends StatefulWidget {
//   final  bool isSupported;
//   final  bool isBiometricsAvailable;
//   // const SelectPassCodeWidget({Key key, @required this.isSupported}) : super(key: key);
//   const SelectPassCodeWidget({Key key, @required this.isSupported, @required this.isBiometricsAvailable}) : super(key: key);
//
//   @override
//   _SelectPassCodeWidgetState createState() => _SelectPassCodeWidgetState(isSupported,isBiometricsAvailable);
// }
//
// class _SelectPassCodeWidgetState extends State<SelectPassCodeWidget> {
//   final _formKey = GlobalKey<FormState>();
//
//   bool noPassCode = false;
//   final  bool isSupported;
//   final bool isBiometricsAvailable;
//   bool isSystemLock = false;
//   TextEditingController _passwordController = TextEditingController(text: "");
//
//   _SelectPassCodeWidgetState(this.isSupported,this.isBiometricsAvailable);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       elevation: 0,
//       backgroundColor: Colors.white,
//       child: contentBox(context),
//     );
//   }
//   contentBox(context){
//     return  new Container(
//
//
//       child: SingleChildScrollView(
//           child:Column(
//
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//
//             children: <Widget>[
//               Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: <Widget>[
//                         Visibility(
//                           // visible: false,
//                           visible: (isSupported !=null && isSupported) && (isBiometricsAvailable !=null && isBiometricsAvailable) ? true  : false,
//                           child: Row(
//                             children: [
//                               Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text("Use Biometric Lock"),
//                                 ),
//                               ),
//                               Switch(
//                                 value: isSystemLock,
//                                 onChanged: (value){
//                                   setState(() {
//                                     isSystemLock = value;
//                                     if(isSystemLock) _passwordController.clear();
//                                     print(isSystemLock);
//                                   });
//                                 },
//                                 activeTrackColor: Colors.orangeAccent,
//                                 activeColor: Colors.deepOrange,
//                               ),
//
//                             ],
//                           ),
//                         ),
//                         Visibility(
//                           // visible: false,
//                           visible:isSupported !=null && isSupported && isBiometricsAvailable !=null && isBiometricsAvailable ? true : false,
//                           child: Center(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text("OR"),
//                             ),
//                           ),
//                         ),
//                         Center(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text("Create New Pin"),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextFormField(
//                             keyboardType: TextInputType.number,
//                             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                             enabled: !noPassCode,
//                             // enabled: !isSystemLock ,
//                             obscureText: true,
//                             maxLength: 4,
//                             controller: _passwordController,
//                             style: Theme.of(context).textTheme.bodyText2,
//                             validator: (value){
//                               if(!noPassCode && !isSystemLock){
//                                 // if(!isSystemLock) {
//                                 if (value.isEmpty || value.length < 4)
//                                   return 'Please Enter Password';
//                                 // if (!(Validate.isNumeric(value)))
//                                 //   return 'Please Enter only digits';
//                               }
//                               return null;
//                             },
//                             decoration: InputDecoration(
//                                 prefixIcon: Icon(
//                                   Icons.lock,
//                                   color: Colors.blueGrey,
//                                 ),
//                                 labelText: "Pass Code",
//                                 border: OutlineInputBorder()),
//
//                           ),
//                         ),
//                         Visibility(
//                           visible: true,
//                           // visible:isSupported !=null && isSupported ? true : false,
//                           child: Center(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text("OR"),
//                             ),
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text("Register without Passcode"),
//                               ),
//                             ),
//                             Switch(
//                               value: noPassCode,
//                               onChanged: (value){
//                                 setState(() {
//                                   noPassCode = value;
//                                   if(noPassCode) _passwordController.clear();
//                                   print(noPassCode);
//                                 });
//                               },
//                               activeTrackColor: Colors.orangeAccent,
//                               activeColor: Colors.deepOrange,
//                             ),
//
//                           ],
//                         ),
//
//
//                         SizedBox(
//                           width: 320.0,
//                           child: RaisedButton(
//                             onPressed: () async {
//                               _formKey.currentState.save();
//                               final form = _formKey.currentState;
//                               // form.save();
//                               if (form.validate()) {
//                                 PassCodes passCode = new PassCodes();
//                                 passCode.isSystemLock = isSystemLock;
//                                 passCode.password = _passwordController.text;
//                                 passCode.noPassCode = noPassCode;
//                                 // if(!isSystemLock)  passCode.password = _passwordController.text;
//                                 // else  passCode.password = null;
//                                 Navigator.pop(context, passCode);
//
//                               }
//                             },
//                             child: Text(
//                               "Submit",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             color: Colors.orangeAccent,
//                           ),
//                         )
//                       ],
//                     ),
//
//                   ),
//
//                 ),
//
//               ),
//
//               //your elements here
//             ],
//           ) ),);
//   }
//
//
//   @override
//   void dispose() {
//
//     _passwordController.dispose();
//     super.dispose();
//   }
// }
