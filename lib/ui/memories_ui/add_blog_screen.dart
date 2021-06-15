import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_memory/Utility/Utility.dart';
import 'package:flutter_memory/Utility/rest_ds.dart';
import 'package:flutter_memory/Utility/round_icon_button.dart';
import 'package:flutter_memory/app_localizations.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/Blog.dart';
import 'package:flutter_memory/models/BlogMeta.dart';
import 'package:flutter_memory/models/Gallery.dart';
import 'package:flutter_memory/models/WeatherData.dart';
import 'package:flutter_memory/models/nominee.dart';
import 'package:flutter_memory/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'customNomineeDialog.dart';


class CreateEditBlogScreen extends StatefulWidget {


  @override
  _CreateEditBlogScreenState createState() => _CreateEditBlogScreenState();
}

class _CreateEditBlogScreenState extends State<CreateEditBlogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Blog blog;

  File _image;
  var lat, lon;
  final Geolocator geolocator = Geolocator()
    ..forceAndroidLocationManager;
  Position _currentPosition;
  WeatherData weatherData;
  String title;
  String blogMessage;
  bool _loading = false;
  List<Nominee> nomineeList;
  Nominee selectedNominee;
  Nominee selectedNominee2;
  BlogMeta meta;
  BlogLocation blogLocation;
  BlogContent content;
  String userId;
  String address;
  Weather weather;
  String thumbnailUrl;
  bool isCherished = false;
  bool isLocation = false;
  bool isWeather = false;
  String dialogNomineeId;
  Nominee nomineeTable;

  final Set _saved = Set();

  List<Nominee> selectedNomineeList ;
  FocusNode _focusNode;
  var pdfBuffer = new StringBuffer();
  auth.User user;

  _CreateEditBlogScreenState();

  @override
  void initState() {
      super.initState();
      nomineeMethod();
    // _focusNode = FocusNode();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(AppLocalizations.of(context).translate(
            "todosCreateEditAppBarTitleNewTxt"),style: TextStyle(color: Colors.white)),
        actions: <Widget>[
        ],
      ),
      body: GestureDetector(
        child: SafeArea(child: _buildForm(context)),
        onTap:(){
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _progressIndicator() {
    if (_loading) {
      return new AlertDialog(
        elevation: 4,
        content: new Row(
          children: [
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            Container(margin: EdgeInsets.only(left: 7),child:Text("Uploading..." )),
          ],),
      );
      // return Center(
      //   child: CircularProgressIndicator(),
      // );
    } else {
      return Container();
    }
  }

  void _showIndicator() {
    setState(() {
      _loading = !_loading;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  void _openGallery(BuildContext context) async {
    File imageSelected;
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile = await imagePicker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      imageSelected = File(pickedFile.path);
      print("size");
      findScale(imageSelected);
    }else{
      print('No image selected.');
    }
    Navigator.of(context).pop();

  }

  void _openCamera(BuildContext context) async {
    File imageSelected;
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile = await imagePicker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      imageSelected = File(pickedFile.path);
      print("size");
      findScale(imageSelected);
    }else{
      print('No image selected.');
    }
    Navigator.of(context).pop();

  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(

              title: Text("From where do you want to take the photo?",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(4.0)),
                    GestureDetector(
                      child: Text("Gallery",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black)),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(10.0)),
                    GestureDetector(
                      child: Text("Camera",style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black)),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Widget _buildForm(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Stack(
          children: <Widget>[

            Container(
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: _formKey,
                child: Column(
                  verticalDirection: VerticalDirection.down,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Center(child: _progressIndicator()),

                    Flexible(child: calenderContainerWidget(context),flex:2),
                    Flexible(child: titleWidget(context),flex:2),
                    Flexible(child: messageBodyWidget(context),flex:3),
                    Flexible( flex:1,  child: Visibility(
                      visible: isLocation,
                      child: new Padding(
                          padding: EdgeInsets.fromLTRB(12.0, 8.0, 0.0, 0.0),
                          child:
                          Text(
                            isLocation && address != null ? "Location " + address:"",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0
                            ),)),
                    ),
                    ),
                    Flexible(
                      flex:1,
                      child: Visibility(
                        visible: isWeather,
                        child: new Padding(
                            padding: EdgeInsets.fromLTRB(12.0, 8.0, 0.0, 0.0),
                            child:
                            Text(
                              isWeather && weather != null && weather.tempCelsius != null ? "Weather " + weather.tempCelsius:"",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0
                              ),)),
                      ),
                    ),
                    Expanded(flex:2,
                      child: Center(
                        child: new InkWell(
                            child: _image != null ? new Image.file(
                              _image,
                              height: 80.0,
                              width: 80.0,
                            ) : new Image.asset(
                              'images/icon.png',
                              height: 00.0,
                              width: 00.0,
                              fit: BoxFit.fill,
                            )

                        ),
                      ),
                    ),

                    Flexible(child: roundButtonContainer(context),flex:1),
                    Flexible(
                      flex:1,
                      child: Container(
                          height: 50,
                          width: double.infinity,
                          child: SizedBox(
                            child: ElevatedButton(
                              onPressed: () {
                                _formKey.currentState.save();

                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orangeAccent,
                                onPrimary: Colors.white,
                                onSurface: Colors.grey,
                                padding: const EdgeInsets.all(0.0),
                              ),
                              child: Text(
                                "POST",
                              ),
                            ),
                          )
                        // This align moves the children to the bottom
                      ),
                    ),
                  ],
                ),

              ),

            ),
            Center(child: _progressIndicator()),
          ],

        ),
      ),
    );
  }

  Row roundButtonContainer(BuildContext context) {
    return Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new RoundIconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            isLocation = !isLocation;
                            _getCurrentLocation();
                          } );
                        },
                        icon: getLocationIcon(),
                        color:Colors.orangeAccent,
                      ),

                      new RoundIconButton(
                        onPressed: () {
                          setState(() {
                            FocusScope.of(context).unfocus();
                            isWeather = !isWeather;
                            if(isWeather)loadWeather();
                          }
                          );
                        },
                        icon: getWeatherIcon(),
                        color:Colors.orangeAccent,
                      ),

                      new RoundIconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if(nomineeList.length>0)
                          _selectNomineeDialog();
                          else showNomineeAlertDialog(context);
                        },
                        icon: Icons.person_add,
                        color:Colors.orangeAccent,
                      ),
                      RoundIconButton(
                        icon: Icons.attach_file,
                        color:Colors.orangeAccent,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _showSelectionDialog(context);
                        },
                      ),
                    ],
                  );
  }



  Padding messageBodyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Card(
        elevation: 2,
        child: TextFormField(
          // keyboardType: _focusNode.hasPrimaryFocus ?TextInputType.multiline:TextInputType.,
          // focusNode: _focusNode,
           textInputAction: TextInputAction.newline ,
          textCapitalization: TextCapitalization.sentences,
          style: Theme
              .of(context)
              .textTheme
              .bodyText2,
          maxLines: 20,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width:0.0)),
            contentPadding: const EdgeInsets.all(16.0),

            labelText: AppLocalizations.of(context).translate(
                "todosCreateEditNotesTxt"),

          ),
          validator: (value) =>
          value.isEmpty
              ? "Please enter message"
              : null,
          onSaved: (value) {
            blogMessage = value.trim();
          },
    onEditingComplete:(){
            print("Edit");
    },

        ),
      ),
    );
  }

  Padding titleWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child:
      Card(
        elevation: 2,
        // margin: EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(

          textCapitalization: TextCapitalization.sentences,
//                            initialValue: title,
          style: Theme
              .of(context)
              .textTheme
              .bodyText2,
          validator: (value) =>
          value.isEmpty
              ? AppLocalizations.of(context).translate(
              "todosCreateEditTaskNameValidatorMsg")
              : null,
          onSaved: (value) {
            title = value.trim();
          },
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16.0),

            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width:0.0)),
            labelText: AppLocalizations.of(context).translate(
                "todosCreateEditTaskNameTxt"),
          ),
        ),
      ),
    );
  }

  Container calenderContainerWidget(BuildContext context) {
    var buffer = new StringBuffer();
    String m;
    String n;
    if(selectedNominee != null && selectedNominee.nomineeName != null){
      List<String> str = selectedNominee.nomineeName.split(' ');
       m = str[0];
      buffer.write(m);
    }
    if(selectedNominee2 != null && selectedNominee2.nomineeName != null){
      List<String> str = selectedNominee2.nomineeName.split(' ');
      n = str[0];
      buffer.write(" and ");
      buffer.write(n);
    }

    return Container(
       child: Card(
          margin: EdgeInsets.fromLTRB(2,12,0,12),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2,2,0,4),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2,8,0,8),
                    child: new Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        color: Colors.orange,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left:12.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                child: Text(
                                    _selectedDate,
                                    style: TextStyle(
                                        color: Colors
                                            .white,
                                        fontSize: 12.0)
                                ),
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  _selectDate(context);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                    Icons.calendar_today,color: Colors.white,size: 12),
                                tooltip: 'Tap to open date picker',
                                onPressed: () {
                                  _selectDate(context);
                                },
                              ),
                            ]),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: getIcon(),
                    onPressed: () {
                      // isCherished = !isCherished;
                      // if(isCherished) Fluttertoast.showToast(
                      //
                      //     msg: "Cherished",
                      //     toastLength: Toast.LENGTH_LONG,
                      //     gravity: ToastGravity.CENTER,
                      //     timeInSecForIosWeb: 1,
                      //     backgroundColor: Colors.blueGrey,
                      //     textColor: Colors.white
                      // );
                      setState(() {
                        FocusScope.of(context).unfocus();
                        // isCherished = !isCherished;
                        isCherished = !isCherished;
                        String message;
                            message = isCherished ? "Memory is Cherished": "Memory is uncherished";
                          Fluttertoast.showToast(
                            msg: message,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blueGrey,
                            textColor: Colors.white
                        );
                      }
                      );
                    },
                  ),


                  Flexible(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8),
                        child:
                        Text(
                          ( selectedNominee != null || selectedNominee2 != null )&&buffer != null ? "Writing For " + buffer.toString():"",
                          // selectedNominee != null && selectedNominee.nomineeName != null? "Writing For " + selectedNominee.nomineeName:"",
                          style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontSize: 16.0
                          ),)),
                  )
                ]
            ),
          ),
        ));
  }


  loadWeather() async {
//    if(isLocation == true) {

    if (lat != null && lon != null) {
      var url = RestDatasource.WEATHER_URL ;
      url += 'lat=$lat&lon=$lon&';

      url += 'appid='+(StringConstant.WEATHER_API_KEY);

print(url);

      // final weatherResponse = await http.get(
      //     RestDatasource.Weather_URL + 'APPID=' +
      //         StringConstant.WEATHER_API_KEY + '&lat=${lat
      //         .toString()}&lon=${lon.toString()}');
      http.Response weatherResponse = await http.get(Uri.parse(url));

      // final weatherResponse = await http.get(url);
      if (weatherResponse.statusCode == 200) {
        return setState(() {
          weatherData =
          new WeatherData.fromJson(jsonDecode(weatherResponse.body));
          if (weatherData != null && weatherData.mainInfo != null &&
              weatherData.mainInfo.temp != null) {
            print(weatherData.name + weatherData.mainInfo.temp.toString());


            double tempCelsius = 0;
            tempCelsius = weatherData.mainInfo.temp - 273.15;
            double tempFahrenheit = (tempCelsius * 9 / 5) + 32;
            address = weatherData.name + ", " + weatherData.sysInfo.country;

            String sb = tempCelsius.round().toString() + "°C / " +
                tempFahrenheit.round().toString() + "°F";
            print(address);
            print(sb);

            pdfBuffer.write("Weather : " + sb.toString()+"\n");
            pdfBuffer.write("Address : " + address+"\n");

            weather = new Weather();
            if (isLocation)
              weather.address = address;
            if (isWeather)
              weather.tempCelsius = sb;
          }
        });
      } else {
        throw Exception('Failed to load internet');
      }
    }
    else {
      _getCurrentLocation();
    }
  }


  _getCurrentLocation() {
    if(isLocation == true) {
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
        });
        print("Latitude:" + _currentPosition.latitude.toString());
        print("Longitude: " + _currentPosition.longitude.toString());
        lat = _currentPosition.latitude.toString();
        lon = _currentPosition.longitude.toString();
        loadWeather();
      }).catchError((e) {
        print(e);
      });
    }
  }

  String _selectedDate = new DateFormat.yMMMMd("en_US").format(DateTime.now());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2120),

      builder: (context, child) {
        return Theme(
//          data: ThemeData.from(
//            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),
//          ),
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),

          ),
//          data: ThemeData.light(),
          // This will change to light theme.
          child: child,
        );
      },
    );
    if (picked != null && picked.toString() != _selectedDate)
      setState(() {
        _selectedDate = new DateFormat.yMMMMd("en_US").format(picked);
      });
  }

  Future<String> _selectNomineeDialog() async {
    _saved.clear();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState2) {
              return AlertDialog(

                title: Text('Select Nominee'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () {
                      print(_saved);
                      if(_saved.length>2)
                        Fluttertoast.showToast(
                            msg: 'Please select only two nominees' ,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white
                        );
                      else{
                        selectedNomineeList =  List<Nominee>.empty(growable: true);
                        // selectedNomineeList =  List<Nominee>();
                        setState(() {
                          if(_saved.length>0 )
                            {
                              selectedNominee = null;
                              selectedNominee2 = null;
                              if(nomineeList[_saved.elementAt(0)]!=null )selectedNominee = nomineeList[_saved.elementAt(0)];
                              if(_saved.length>1 && nomineeList[_saved.elementAt(1)]!=null )selectedNominee2 = nomineeList[_saved.elementAt(1)];
                             if(selectedNominee!=null) print(selectedNominee.nomineeName);
                              if(selectedNominee2!=null)  print(selectedNominee2.nomineeName);
                            }
                          // for(int i=0; i<_saved.length;i++)
                          // {
                          //   selectedNomineeList.add(nomineeList[_saved.elementAt(i)]);
                          // }
                          // if(selectedNomineeList!=null)
                          //
                          //   for(int i=0; i<selectedNomineeList.length;i++)
                          //   {
                          //     print(selectedNomineeList[i].nomineeName);
                          //   }

                        });
                      }

                      Navigator.pop(context);


                    },
                    child: Text('OK'),
                  ),
                ],
                content: Container(
                  width: double.minPositive,
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: nomineeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        title: Text(nomineeList[index].nomineeName),
                        checkColor: Colors.deepOrange,
                       value: _saved.contains(index),
                        onChanged: (val) {
                          setState2(() {
                            if(val == true){
                              _saved.add(index);
                            } else{
                              _saved.remove(index);
                            }
                          });
                        },

                      );
                      // return RadioListTile(
                      //   value: index,
                      //   groupValue: _currentIndex,
                      //   title: Text(nomineeList[index].nomineeName),
                      //   onChanged: (val) {
                      //     setState2(() {
                      //       _currentIndex = val;
                      //       print(_currentIndex);
                      //     });
                      //
                      //   },
                      // );

                    },
                  ),
                ),
              );
            },
          );
        });
  }


  Future<List<Nominee>> _fetchData() async {
    // String userId;

    user = auth.FirebaseAuth.instance.currentUser;
    userId = user.uid;
    final addRef = FirebaseFirestore.instance
        .collection(StringConstant.USER).doc(userId)
        .collection(StringConstant.NOMINEE)
        .get();

    List<Nominee> list = [];
    await addRef.then((QuerySnapshot snapshot) {
      list = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
        return Nominee.fromJson(documentSnapshot.data());
      }).toList();
    });
    return list;
  }

  void nomineeMethod() async {
    Future<List<Nominee>> _futureOfList = _fetchData();
    nomineeList = await _futureOfList;
    if (nomineeList.length > 0)
      for (int i = 0; i < nomineeList.length; i++) {
        Nominee nominees = nomineeList[i];
        print(nominees.nomineeName);
        print("Nominee: " + nominees.nomineeName.toString());
      }
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
          ? "Saved Successfully"
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

  void updateGallery(Blog blog) async {
    if (blog.content != null)
      if (blog.content.thumbnailUrl != null &&
          blog.content.thumbnailUrl.isNotEmpty) {
        Gallery gallery = new Gallery();
        gallery.imageURL = blog.content.thumbnailUrl;
        gallery.blogId = blog.blogId;
        gallery.fileCategory = "IMAGE";
        if (_image != null)
          gallery.extension = Utility.getFileExtension(_image);
        else
          gallery.extension = "jpg";
        gallery.postingDate = DateTime.now();

        Map<String, dynamic> postData = gallery.toJson();
        FirebaseFirestore.instance
            .collection('GALLERY').doc(userId).collection("IMAGE")
            .doc(blog.blogId)
            .set(postData)
            .then((result) {
//        _formKey.currentState.reset(),
          showAlertDialog(context, true);
        }
        )
            .catchError((err) {
          showAlertDialog(context, false);
          print(err);
        }).whenComplete(() {
          _showIndicator();
        });
      }
  }

  getIcon() {
    if (isCherished)
      return Icon(Icons.star,size: 34.0);
    else
      return Icon(Icons.star_border,size: 34.0);
  }
  getLocationIcon() {
    if (isLocation)
      return Icons.location_on;
    else
      return Icons.location_off;

  }
  getWeatherIcon() {
    if (isWeather)
      return Icons.cloud;
    else
      return Icons.cloud_off;

  }

  showNomineeAlertDialog(BuildContext context) {

      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) => CustomNomineeDialogBox(nominee: null,),
          ).then((value)  async {
            print(value);
            dialogNomineeId = value;
            final addRef =  FirebaseFirestore.instance
                .collection(StringConstant.USER).doc(userId).collection(
                StringConstant.NOMINEE)
                .doc(dialogNomineeId).get();
              nomineeTable =  await addRef.then((nominee1) {
              return Nominee.fromJson(nominee1.data());
            });
              print(nomineeTable.nomineeName);
              if(nomineeTable != null){
                setState(() {
                  selectedNominee = nomineeTable;
                  nomineeMethod();
                });
              }

          });
          // Navigator.of(context).pushNamed(
          //   Routes.create_edit_nominee,
          // );
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("No Nominee Added"),
        content: Text("Click OK button to add Nominee "),
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


  Future<File> testCompressAndGetFile(File file, int width, int height) async {
    final filePath = file.absolute.path;

    // Create output file path
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    print("testCompressAndGetFile");
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 80,
      minWidth: width,
      minHeight: height,
      // rotate: 90,
      keepExif: true,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }



  double calcScale({
    double srcWidth,
    double srcHeight,
    double minWidth,
    double minHeight,
  }) {
    var scaleW = srcWidth / minWidth;
    var scaleH = srcHeight / minHeight;

    var scale = math.max(1.0, math.min(scaleW, scaleH));

    return scale;
  }

  Future<void> findScale(File imageSelected) async {

    var decodedImage = await decodeImageFromList(imageSelected.readAsBytesSync());
    print(decodedImage.width);
    print(decodedImage.height);

    var scale = calcScale(
      srcWidth: decodedImage.width.toDouble(),
      srcHeight: decodedImage.height.toDouble(),
      minWidth: 500,
      minHeight: 500,
    );
    double targetWidth = decodedImage.width / scale ;
    double targetHeight = decodedImage.height / scale ;
    print("targetHeight = $targetHeight");
    print("targetWidth = $targetWidth");

    print("scale = $scale");
    print("target width = ${decodedImage.width / scale}, height = ${decodedImage.height / scale}");

    if(scale>1) {
      _image = await testCompressAndGetFile(
          imageSelected, targetWidth.toInt(), targetHeight.toInt());
    }else{
      _image = imageSelected;}

    if(_image !=null && _image.lengthSync()/1000 < 200 ){
      setState(() {
        if (_image != null) {

          print("size");
          print(_image.lengthSync()/1000);

        }
      });

    }else {
      _image = await testCompressAndGetFile(imageSelected, 400, 400);
      print("size");
      print(_image.lengthSync()/1000);
      setState(() {
        if (_image != null) {

          print("size");
          print(_image.lengthSync()/1000);

        }
      });
    }
    // setState(() {
    //   if (_image != null) {
    //      print("size");
    //     print(_image.lengthSync());
    //
    //   }
    // });
  }




}

