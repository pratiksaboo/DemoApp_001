import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_memory/Utility/Utility.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/user.dart' as User;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../routes.dart';

class ProfilePage extends StatefulWidget {
  final userTable;

  const ProfilePage({Key key, this.userTable}) : super(key: key);
  @override
  MapScreenState createState() => MapScreenState(userTable);
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  File _image;
  bool isThumbnail = false;
  DateTime _selectedDate;
  String  name,emailId,dob,dateSelected;
  final _formKey = GlobalKey<FormState>();
  String thumbnailUrl;
  User.User userDetails;
  final userTable;
  auth.User user ;
  bool _loading = false;
  String phoneNumber1;
  String phoneCountryCode;
  String phoneIsoCode;
  bool isFuture = false;
  bool isToggle = false;
  bool userEditDate = false;
  bool newUser = false;
  MapScreenState(this.userTable);


  @override
  void initState() {
    fetchCurrentUser();
    fetchData();
    super.initState();
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
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }
  @override
  Widget build(BuildContext context) {


    return new Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("Edit Profile",style: TextStyle(color: Colors.white)),

        ),
        bottomNavigationBar:
          Padding(
            padding: const EdgeInsets.fromLTRB(8,8,8,10),
            child: Visibility(
              visible: !_status,
              child: Container(
              child: SizedBox(
                  height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    _formKey.currentState.save();
                    print(name);
                    print(phoneNumber1);
                    // userDetails.userName = name;
                    // userDetails.isoCode = phoneIsoCode;
                    // userDetails.contactNumber = phoneNumber1;
                    submit(context);

                  },

                  style: ElevatedButton.styleFrom(
                    primary: Colors.orangeAccent,
                    onPrimary: Colors.white,
                    onSurface: Colors.grey,
                    padding: const EdgeInsets.all(8.0),
                  ),
                  child: Text(
                    "Submit",
                  ),
              )
        // This align moves the children to the bottom
      ),),
            ),
          ),
        body: SafeArea(
          child: _buildForm(context),
        ),


    );
  }
  Widget _buildForm(BuildContext context) {

    return FutureBuilder <User.User>(
      future: fetchUser(),
      builder:(context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),));
        userDetails = snapshot.data;
        setData(userDetails);
        return    Stack(
            fit: StackFit.expand,
            children: <Widget>[
           Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 0.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    verticalDirection: VerticalDirection.down,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                    // _progressIndicator(),
                      new Container(

                        color: Colors.white,
                        child: new Column(
                          children: <Widget>[

                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: new Stack(
                                  fit: StackFit.loose, children: <Widget>[
                                new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    if(thumbnailUrl !=null && isThumbnail)
                                      Visibility(
                                        visible: isThumbnail,
                                        child: new Container(
                                          height: 140.0,
                                          width: 140.0,
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: const Color(0x33A6A6A6)),
                                            // image: new Image.asset(_image.)
                                          ),
                                          child: ClipOval(

                                            // child: FadeInImage.memoryNetwork(
                                            //   placeholder:  kTransparentImage,
                                            //   image: thumbnailUrl,
                                            // ),
                                            child: Image.network(thumbnailUrl, fit: BoxFit.cover),
                                          ),

                                        ),
                                      ),
                                    Visibility(
                                      visible: !isThumbnail,
                                      child: new Container(
                                        height: 140.0,
                                        width: 140.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.orangeAccent),
                                          // image: new Image.asset(_image.)
                                        ),
                                        child: ClipOval(
                                          child: _image != null ? new Image.file(
                                            _image,fit: BoxFit.cover,) :null ,
//                                      new Image.asset(
//                                        'images/icon.png',
//                                         fit: BoxFit.cover,
//                                      ),
                                        ),

                                      ),
                                    ),

                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 90.0, right: 100.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            if (_status == false)
                                              _showSelectionDialog(context);
                                          },
                                          child: new CircleAvatar(
                                            backgroundColor: Colors.red,
                                            radius: 25.0,
                                            child: new Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                            ),

                                          ),

                                        )
                                      ],
                                    )),
                              ]),
                            )
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 8.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Personal Information',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  _status ? _getEditIcon() : new Container(),
                                ],
                              )
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 16.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextFormField(
                                  initialValue: name,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width:0.0)),
                                    hintText: "Enter Your Name",
                                  ),
                                  enabled: !_status,
                                  autofocus: !_status,
                                  validator: (value) =>
                                  value.length == 0 ? "Please enter Name" : null,
                                  onSaved: (value) {
                                    name = value.trim();
                                    userDetails.userName = name;
                                  },
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 8.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Email ID',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextFormField(
                                  initialValue:emailId,
                                  decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width:0.0)),
                                      hintText: "Enter Email ID"),
//                                      enabled: !_status,
                                  enabled: false,
                                  validator: (value) =>
                                  value.length == 0 ? "Please enter email" : null,
                                  onSaved: (value) {
                                    emailId = value.trim();
                                  },
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 8.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Mobile',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: AbsorbPointer(
                          absorbing: _status? true : false,
                          child: Container(

                            child: Column(
                              children: [


                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IntlPhoneField(
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width:0.0)),
                                      border: OutlineInputBorder(

                                        borderSide: BorderSide(),
                                      ),
                                    ),

                                    initialCountryCode: phoneIsoCode.isNotEmpty ? phoneIsoCode : 'US',
                                    initialValue: phoneNumber1,
                                    autoValidate: true,
                                    onChanged: (phone) {
                                      // _validatePhoneNumber(phoneNumber1,phoneIsoCode);
                                      // setState(() {
                                      // phoneError = null;
                                      //
                                      // });
                                    },
                                    onSaved:(phone) {
                                      print(phone.completeNumber);
                                      print(phone.countryISOCode);
                                      print(phone.number);
                                      print(phone.countryCode);
                                      phoneNumber1 = phone.number;
                                      phoneIsoCode = phone.countryISOCode;
                                      phoneCountryCode = phone.countryCode;
                                      userDetails.isoCode = phoneIsoCode;
                                      userDetails.contactNumber = phoneNumber1;
                                      userDetails.countryCode = phoneCountryCode;
                                      // _validatePhoneNumber(phoneNumber1,phoneIsoCode);
                                    },

                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                      ),


                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 8.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Date of Birth',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )), Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextFormField(
                                  initialValue: dob,
                                  decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width:0.0)),
                                      hintText: "Enter Date of Birth"),
                                  enabled: !_status,
                                  // validator: (value) => value.length == 0 ? "Please enter Date of Birth" : null,
                                  onSaved: (value) {
                                    dob = value.trim();
                                    userDetails.dob = dob;
                                  },
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 8.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(

                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Disclosing Date',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Visibility(
                        visible: newUser,
                        child: Container(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 8.0),
                                child: CheckboxListTile(

                                  activeColor: Colors.orange,
                                  title: Text("Forever",style: TextStyle(fontSize: 16),),
                                  value: isFuture,
                                  onChanged: (bool value) {
                                    if(!_status) {
                                      setState(() {
                                        if (value) {
                                          _selectedDate = null;
                                          userDetails.disclosingDate = "0";
                                        }
                                        isFuture = value;
                                        isToggle = true;
                                      });
                                    }
                                  },
                                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                ),
                              ),
                              // Visibility(
                              //   visible: !isFuture,
                              //   child: new Text(
                              //     dateSelected !=null && dateSelected.isNotEmpty ? dateSelected : "0",
                              //     style: TextStyle(
                              //         fontSize: 16.0,
                              //         fontWeight: FontWeight.normal),
                              //   ),
                              // ),
                              Visibility(
                                visible: !isFuture,
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
        left: 25.0, right: 25.0, top: 12.0),
                                      child: new Text(
                                        dateSelected !=null && dateSelected.isNotEmpty ? dateSelected : "0",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Visibility(
                                visible: !_status && !isFuture ,

                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),


                                    child: DatePickerWidget(
                                        looping: false,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now().subtract(Duration(days: 0)),
                                        dateFormat: "dd-MMMM-yyyy",
                                        onChange: (DateTime newDate, _) {

                                            _selectedDate = newDate;
                                            setState(() {

                                            });

                                        },
                                        pickerTheme: DateTimePickerTheme(
                                          itemTextStyle: TextStyle(
                                              color: Colors.black, fontSize: 19),
                                          dividerColor: Colors.orange,
                                        )),

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),






                      Visibility(
                        visible: !newUser && isFuture,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0),
                          child: CheckboxListTile(

                            activeColor: Colors.orange,
                            title: Text("Forever",style: TextStyle(fontSize: 16),),
                            value: isFuture,
                            onChanged: (bool value) {
                              if(!_status) {
                                if (userEditDate) {
                                  setState(() {
                                    if (value) {
                                      _selectedDate = null;
                                      userDetails.disclosingDate = "0";
                                    }
                                    isFuture = value;
                                    isToggle = true;
                                  });
                                } else
                                  Fluttertoast.showToast(
                                      msg: "Disclosing date cannot be edited once set",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.blueGrey,
                                      textColor: Colors.white
                                  );
                              }
                             },
                            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                          ),
                        ),
                      ),

                      Visibility(
                        visible: !newUser &&!isFuture,
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 16.0),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  dateSelected !=null && dateSelected.isNotEmpty ? dateSelected : "0",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            )),
                      ),


                    ],
                  ),

                ),
              ),
            ),
          ),
              Center(child: _progressIndicator()),
      ] )
        ;
      }
    );
  }
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();

    super.dispose();
  }


  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  void submit(BuildContext context) {
    // final form = _formKey.currentState;
    // form.save();
    if (_formKey.currentState.validate()) {
      _showIndicator();
      if (_image != null) {
        uploadAttachment(_image);
      } else
        uploadUserDetails();

    }
  }

  Future<void> uploadAttachment(File image) async {
    String fileName = Utility.getRandomString(8) + "." +
        Utility.getFileExtension(_image);
    Reference ref = FirebaseStorage.instance.ref().child("user_account").child(user.email).child(
        "DP").child(fileName);
    // Reference ref = FirebaseStorage.instance.ref().child("Profile_images").child(fileName);

    await ref
        .putFile(_image)
        .then((val) {
      val.ref.getDownloadURL().then((val) {
        print(val);
        thumbnailUrl = val;
        print("Uploaded profile pic");
        uploadUserDetails();

      });
    });
  }
  void  uploadUserDetails(){
    print(dob);
    print(name);
    print(phoneNumber1);
    print(phoneIsoCode);
    print(userDetails.userName);
    print(userDetails.isoCode);
    print(userDetails.contactNumber);
    print(userDetails.dob);
    print(user.uid);
    if(userDetails!=null) {

      Map<String, dynamic> postData = userDetails.toJson();
      FirebaseFirestore.instance
          .collection(StringConstant.USER).doc(userDetails.id)
          .set(postData).then((result) {
        print("user Details uploaded");
        showAlertDialog(context, true);
        setState(() {
          _status = true;
          FocusScope.of(context).requestFocus(new FocusNode());
        });
      }
      ).catchError((err) {
        print(err);
        showAlertDialog(context,false);}).whenComplete(() {
        _showIndicator();
      });
    }
    auth.FirebaseAuth.instance.currentUser.updateProfile(displayName: name,photoURL: thumbnailUrl != null ? thumbnailUrl: null);


  }
  showAlertDialog(BuildContext context, bool status) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.of(context).pushNamed(Routes.setting,
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
  Widget _progressIndicator() {
    if (_loading) {
      return new AlertDialog(
        elevation: 4,
        content: new Row(
          children: [
            CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),),
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
  Future<User.User> fetchUser() async {
    String userId;

    final auth.User user = auth.FirebaseAuth.instance.currentUser;
    userId = user.uid;
    final addRef = FirebaseFirestore.instance.collection(StringConstant.USER).doc(userId).get();
      final userTable =  await addRef.then((userDetails1) {
           return User.User.fromJson(userDetails1.data());
     });
    return userTable;
  }

  Future<void> fetchCurrentUser() async {
    user = auth.FirebaseAuth.instance.currentUser;
  }

  void setData(User.User userDetails) {
    if(name !=null && name.isNotEmpty)
      userDetails.userName = name;
    else
      name = userDetails!=null && userDetails.userName!=null ?userDetails.userName.toString() : "";

    emailId = userDetails!=null && userDetails.emailId!=null ?userDetails.emailId.toString() : "";
    if(dob !=null && dob.isNotEmpty)
      userDetails.dob = dob;
    else
    dob = userDetails!=null && userDetails.dob!=null ?userDetails.dob.toString() : "";

    if(phoneNumber1 !=null && phoneNumber1.isNotEmpty)
      userDetails.contactNumber = phoneNumber1;
    else
      phoneNumber1 = userDetails!=null && userDetails.contactNumber!=null ?userDetails.contactNumber.toString() : "";

    if(phoneIsoCode !=null && phoneIsoCode.isNotEmpty)
      userDetails.isoCode = phoneIsoCode;
    else
      phoneIsoCode = userDetails!=null && userDetails.isoCode!=null ?userDetails.isoCode.toString() : "";


if(!isToggle) {
  if (userDetails != null && userDetails.disclosingDate != null &&
      userDetails.disclosingDate != "0") {
    isFuture = false;
  } else
    isFuture = true;
}
 if(userDetails != null && userDetails.disclosingDate != null) userEditDate = false;
 else userEditDate = true;

    // if(userDetails != null && (userDetails.disclosingDate == null || userDetails.disclosingDate == "0")) newUser = true;else newUser = false;
      if(!isFuture) {

        if(_selectedDate != null)
          dateSelected = new DateFormat.yMMMMd("en_US").format(_selectedDate);
        else
          {
            if(isToggle) dateSelected = new DateFormat.yMMMMd("en_US").format(DateTime.now());
          // if(isToggle) dateSelected = "0";
          else  dateSelected =
          userDetails != null && userDetails.disclosingDate != null ? userDetails
              .disclosingDate.toString() : "0";

        }
        if(dateSelected !=null && dateSelected.isNotEmpty)
          userDetails.disclosingDate = dateSelected;
      }else
        {
         userDetails.disclosingDate = "0";
        }

      if(user != null && user.photoURL != null && _image == null){
        thumbnailUrl = user.photoURL;
        isThumbnail = true;
      }else if(_image !=null){
        thumbnailUrl = null;
        isThumbnail = false;
      }
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
      quality: 85,
      minWidth: width,
      minHeight: height,
      // rotate: 90,
      keepExif: true,
    );

    print(file.lengthSync()/1000);
    print(result.lengthSync()/1000);

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
      _image = imageSelected;
    }

    if(_image !=null && _image.lengthSync()/1000 < 200 ){
      setState(() {
        if (_image != null) {
          isThumbnail = false;
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
          isThumbnail = false;
          print("size");
          print(_image.lengthSync()/1000);

        }
      });
    }
  }


   fetchData() async {
    String userId;
    final auth.User user = auth.FirebaseAuth.instance.currentUser;
    userId = user.uid;
    final addRef = FirebaseFirestore.instance.collection(StringConstant.USER).doc(userId).get();
    final userTable =  await addRef.then((userDetails1) {
      return User.User.fromJson(userDetails1.data());
    });
   if(userTable!=null){
     if(userTable.disclosingDate == null )newUser = true ; else newUser =false;
   }
  }
}

