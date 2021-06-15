import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_memory/Utility/validate.dart';
import 'package:flutter_memory/app_localizations.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/Agreements.dart';
import 'package:flutter_memory/models/PassCode.dart';
import 'package:flutter_memory/models/user.dart' as User;
import 'package:flutter_memory/models/user_model.dart';
import 'package:flutter_memory/providers/auth_provider.dart';
import 'package:flutter_memory/routes.dart';
import 'package:flutter_memory/ui/memories_ui/selectPassCodeWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

// import 'package:local_auth_device_credentials/local_auth.dart';
import 'AuthExceptionHandler.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // final LocalAuthentication _localAuthentication = LocalAuthentication();
  TextEditingController _nameController;

  TextEditingController _emailController;
  TextEditingController _confirmPasswordController;
  TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Agreements agreementDoc;
  bool checkbox = false;

  String phoneNumber1;
  String phoneIsoCode;
  bool visible = false;

  bool isSystemLock ;
  bool noPassCode ;
  String userPasscode;
  bool isBiometricsAvailable;
  String phoneCountryCode;


  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _nameController = TextEditingController(text: "");

    _confirmPasswordController = TextEditingController(text: "");

     // _localAuthentication
     //    .isDeviceSupported()
     //    .then((isSupported) => setState(() => _isSupported = isSupported));
     // checkBiometric();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildBackground(),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: _buildForm(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
               Card(
                  elevation: 4,
                  shadowColor: Colors.deepOrange,
                  child: Column(
                    children:<Widget> [
                      Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                            crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  'images/icon.png',
                                  height: 50.0,
                                  width: 50.0,
                                  fit: BoxFit.fill,
                                )
                            ),
                              Text("Sign Up",style: TextStyle(color: Colors.deepOrange,fontSize: 22,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                          ],

                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          controller: _nameController,
                          style: Theme.of(context).textTheme.bodyText2,
                          validator: (value) => value.isEmpty
                              ? "Please Enter Name"
                              : null,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.blueGrey,
                              ),
                              labelText: "Name",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width:0.0)),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox( height:4.0),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: TextFormField(
                      //
                      //     maxLength: 10,
                      //     maxLines: 1,
                      //     keyboardType: TextInputType.phone,
                      //     controller: _phoneController,
                      //     style: Theme.of(context).textTheme.bodyText2,
                      //     validator: (value) => value.isEmpty
                      //         ? "Please Enter Contact number"
                      //         : null,
                      //     decoration: InputDecoration(
                      //         prefixIcon: Icon(
                      //           Icons.phone,
                      //           color: Colors.blueGrey,
                      //         ),
                      //         labelText: "Contact Number",
                      //         border: OutlineInputBorder()),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[400],
                              width: 1,
                            ),
                          ),

                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.phone,color: Colors.blueGrey),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:  IntlPhoneField(
                                        decoration: InputDecoration(
                                          labelText: 'Phone Number',
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width:0.0)),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                        initialCountryCode: 'US',
                                        autoValidate: true,
                                        onChanged: (phone) {


                                        },
                                        onSaved:(phone) {
                                          print(phone.completeNumber);
                                          print(phone.countryISOCode);
                                          print(phone.number);
                                          print(phone.countryCode);
                                          phoneNumber1 = phone.number;
                                          phoneIsoCode = phone.countryISOCode;
                                          phoneCountryCode = phone.countryCode;
                                        },

                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),

                      ),
//                  SizedBox( height:2.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp("[ ]"))
                          ],
                          style: Theme.of(context).textTheme.bodyText2,
                          validator: (value) {
                            return Validate.validateEmail(value);
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.blueGrey,
                              ),
                              labelText: AppLocalizations.of(context).translate("loginTxtEmail"),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width:0.0)),
                              border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox( height:4.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          obscureText: true,
                          maxLength: 12,
                          controller: _passwordController,
                          style: Theme.of(context).textTheme.bodyText2,
                          validator: (value) => value.length < 6
                              ? AppLocalizations.of(context).translate("loginTxtErrorPassword")
                              : null,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.blueGrey,
                              ),
                              labelText: AppLocalizations.of(context).translate("loginTxtPassword"),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width:0.0)),
                              border: OutlineInputBorder()),
                        ),
                      ),
//                      SizedBox( height: 8.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          obscureText: true,
                          maxLength: 12,
                          controller: _confirmPasswordController,
                          style: Theme.of(context).textTheme.bodyText2,
                          validator: (value){
                            if(value.isEmpty || value.length < 6)
                              return 'Please Enter Confirm Password';
                            if(value != _passwordController.text)
                              return 'Passwords do not match';
                            return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.blueGrey,
                              ),
                              labelText: "Confirm Password",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width:0.0)),
                              border: OutlineInputBorder()),

                        ),
                      ),

                    ],
                  ),
                ),

                  authProvider.status == Status.Registering
                      ? Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  )
                      : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate("loginBtnSignUp"),
                        style: TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        _formKey.currentState.save();
                        if (_formKey.currentState.validate()) {
                          FocusScope.of(context)
                              .unfocus(); //to hide the keyboard - if any
                          showTcDialog(context, authProvider);

                        }
                      }),
                  SizedBox( height: 8.0),
                  authProvider.status == Status.Registering
                      ? Center(
                    child: null,
                  )
                      : Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                        child: Text(
                          AppLocalizations.of(context).translate("loginTxtHaveAccount"),
                          style: TextStyle(color:Colors.blueGrey,fontSize: 18,fontWeight: FontWeight.bold),
                        )),
                  ),
                  authProvider.status == Status.Registering
                      ? Center(
                    child: null,
                  )
                      : TextButton(
                    child: Text(AppLocalizations.of(context).translate("loginBtnLinkSignIn"),style: TextStyle(color:Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.bold),),

                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.login);
                    },
                  ),
//                  SizedBox(
//                    height: MediaQuery.of(context).viewInsets.bottom,
//                  ),
              ],
            )),
      ),
    );
  }

  Widget _buildBackground() {
    return ClipPath(
      clipper: SignInCustomClipper(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }

  showTcDialog(BuildContext context, AuthProvider authProvider) {
    // set up the button
    Widget okButton =
    TextButton(
      child: Text("ACCEPT AND PROCEED ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
      onPressed: () async {
        if(checkbox){
          // uploadData(authProvider);
            Navigator.pop(context);
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => SelectPassCodeWidget(isSupported:true,isBiometricsAvailable: isBiometricsAvailable,),
          ).then((value){
            PassCodes passCodes = value;
            isSystemLock = passCodes.isSystemLock;
            userPasscode = passCodes.password;
            noPassCode = passCodes.noPassCode;
            uploadData(authProvider);
          });
        }else{
          Fluttertoast.showToast(

              msg: "Please select checkbox",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white
          );

        }
          
      },
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {

              return  StatefulBuilder(
                  builder: (context, setState) {
                return FutureBuilder <Agreements>(
                    future: fetchAgreement(),
                    builder:(context, snapshot) {
                      if (!snapshot.hasData) return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),));
                      agreementDoc = snapshot.data;

                    return AlertDialog(
                      title:Card(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text( agreementDoc != null && agreementDoc.title != null ? agreementDoc.title:"",style: TextStyle(
                                fontWeight: FontWeight.bold,  color: Colors.black87),textAlign: TextAlign.justify,),
                          ),
                        ),

                      ),
                      content:  SingleChildScrollView(
                        child: Container(
                          // height: 400,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text( agreementDoc != null && agreementDoc.description != null ? agreementDoc.description:"",style: TextStyle(
                                  fontWeight: FontWeight.normal,  color: Colors.black87,
                                   ),textAlign: TextAlign.justify,),
                            ),

                          ),
                        ),
                      ),
                      actions: <Widget> [
                        Container(
                          width: 400,
                          child: Column(
                            children: <Widget> [
                              CheckboxListTile(
                                title: Text("I HEREBY AGREE THE ABOVE TERMS AND CONDITIONS",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                                value: checkbox,
                                onChanged: (bool value) {
                                  setState(() {
                                    checkbox = value;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                              ),
                            ],
                          ),
                        ),

                        Container(
                          color: Colors.orange,
                          child: SizedBox(
                             width: 400,
                              child: okButton),
                        ),
                      ],

                    );
                  }
                );},
              )
              ;
            }


    );
  }

  Future<Agreements> fetchAgreement() async {

    final addRef = FirebaseFirestore.instance.collection(StringConstant.APP_SETTING).doc("TC_USER_AGREEMENT").get();
    agreementDoc =  await addRef.then((agreement1) {
      return Agreements.fromJson(agreement1.data());
    });
    return agreementDoc;
  }

  Future<void> uploadData(AuthProvider authProvider) async {

    UserModel userModel = await authProvider.registerWithEmailAndPassword(
        _emailController.text,
        _passwordController.text);
    print(authProvider.resultStatus);

    if(authProvider.status == Status.Unauthenticated){

      final errorMsg = AuthExceptionHandler.generateExceptionMessage(
          authProvider.resultStatus);
      print(authProvider.resultStatus);
    if (errorMsg != null) {
      ScaffoldFeatureController controller = ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(errorMsg)),
      );
      final result = await controller.closed;
      print(result);
    }

      }
    else
    if (userModel == null) {
      ScaffoldFeatureController controller = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)
            .translate("loginTxtErrorSignIn"))),
      );
      final result = await controller.closed;
      print(result);

    }else
      {
    // if (userModel != null){
      print(phoneIsoCode);

      User.User userDetail = new User.User();
      userDetail.id = userModel.uid;
      userDetail.userName = _nameController.text;
      userDetail.isoCode = phoneIsoCode;
      userDetail.countryCode = phoneCountryCode;
      userDetail.contactNumber = phoneNumber1;
      userDetail.emailId = _emailController.text;
      userDetail.isActive = true;
      userDetail.isAgreedTnC = true;
      userDetail.isManagement = false;
      userDetail.isBlogger = false;
      userDetail.isPaidUser = false;
      userDetail.muteAudio = false;

      userDetail.isSystemPasscode = isSystemLock;
      userDetail.passcode = userPasscode;
      userDetail.noPasscode = noPassCode;
      Map<String, dynamic> postData = userDetail.toJson();
      FirebaseFirestore.instance
          .collection(StringConstant.USER).doc(userModel.uid)
          .set(postData) .then((result) =>
      {
      FirebaseFirestore.instance
          .collection(StringConstant.USER).doc(userModel.uid)
          .set({
        'countryCode': phoneCountryCode
      },SetOptions(merge: true)) .then((result) =>
      {

      FirebaseAuth.instance.currentUser.updateProfile(displayName:_nameController.text).then((val) async {
      try {

      await FirebaseAuth.instance.currentUser.sendEmailVerification();
      return FirebaseAuth.instance.currentUser.uid;
      } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
      }

      })



      }
      )

        // FirebaseAuth.instance.currentUser.updateProfile(displayName:_nameController.text).then((val) async {
        //   try {
        //
        //     await FirebaseAuth.instance.currentUser.sendEmailVerification();
        //     return FirebaseAuth.instance.currentUser.uid;
        //   } catch (e) {
        //     print("An error occured while trying to send email verification");
        //     print(e.message);
        //   }
        //
        // })



      }
      )
          .catchError((err) => print(err));
    }
  }
}




class SignInCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    var firstEndPoint = Offset(size.width / 2, size.height - 95);
    var firstControlPoint = Offset(size.width / 6, size.height * 0.45);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height / 2 - 50);
    var secondControlPoint = Offset(size.width, size.height + 15);

    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
