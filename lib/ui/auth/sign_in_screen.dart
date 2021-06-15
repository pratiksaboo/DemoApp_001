import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_memory/Utility/validate.dart';
import 'package:flutter_memory/app_localizations.dart';
import 'package:flutter_memory/providers/auth_provider.dart';
import 'package:flutter_memory/routes.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          _buildBackground(),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: _buildForm(context),
          ),
        ],
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

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//              Center(
//                      child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Image.asset(
//                        'images/icon.png',
//                        height: 70.0,
//                        width: 70.0,
//                        fit: BoxFit.fill,
//                      )
//                    ),
//                  ),
//
                Card(
                  elevation: 4,
                  shadowColor: Colors.deepOrange,
                  margin: EdgeInsets.only(bottom: 24.0),
                  child: Padding(
                    // padding: const EdgeInsets.fromLTRB(8,8,8,16),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'images/icon.png',
                                height: 70.0,
                                width: 70.0,
                                fit: BoxFit.fill,
                              )
                          ),
                        ),
                     TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                       inputFormatters: [
                         FilteringTextInputFormatter.deny(RegExp("[ ]"))
                       ],
                        style: Theme.of(context).textTheme.bodyText2,
                        validator: (value) {
                          return Validate.validateEmail(value.trim());
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.blueGrey,
                            ),
                            labelText: AppLocalizations.of(context)
                                .translate("loginTxtEmail"),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width:0.0)),
                            border: OutlineInputBorder()),
                      ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: TextFormField(
                            obscureText: true,
                            maxLength: 12,
                            controller: _passwordController,
                            style: Theme.of(context).textTheme.bodyText2,
                            validator: (value) => value.length < 6
                                ? AppLocalizations.of(context)
                                .translate("loginTxtErrorPassword")
                                : null,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blueGrey,
                                ),
                                labelText: AppLocalizations.of(context)
                                    .translate("loginTxtPassword"),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width:0.0)),
                                border: OutlineInputBorder()),
                          ),
                        ),
                        authProvider.status == Status.Authenticating
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
                              AppLocalizations.of(context)
                                  .translate("loginBtnSignIn"),
                              style: TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                FocusScope.of(context)
                                    .unfocus(); //to hide the keyboard - if any

                                bool status =
                                await authProvider.signInWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text);

                                if (!status) {
                                  ScaffoldFeatureController controller = ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(AppLocalizations.of(context)
                                        .translate("loginTxtErrorSignIn"))),
                                  );
                                  final result = await controller.closed;
                                  print(result);
                                  // _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  //   content: Text(AppLocalizations.of(context)
                                  //       .translate("loginTxtErrorSignIn")),
                                  // ));
                                }
                              }
                            }),
                        authProvider.status == Status.Authenticating
                            ? Center(
                          child: null,
                        )
                            : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("loginTxtDontHaveAccount"),
                                style: TextStyle(color:Colors.blueGrey,fontSize: 18,fontWeight: FontWeight.bold),
                              )),
                        ),
                        authProvider.status == Status.Authenticating
                            ? Center(
                          child: null,
                        )
                            : TextButton(
                          child: Text(AppLocalizations.of(context)
                              .translate("loginBtnLinkCreateAccount"),style: TextStyle(color:Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.bold)),
//                        textColor: Theme.of(context).iconTheme.color,
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.register);
                          },
                        ),

                        TextButton(
                          child: Text("Forgot Password? Reset It",style: TextStyle(color:Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.bold)),
//                        textColor: Theme.of(context).iconTheme.color,
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.resetPassword);
                          },
                        )
               ], ),
                  ),
                ),
//                Padding(
//                  padding: const EdgeInsets.symmetric(vertical: 16),
//                  child: TextFormField(
//                    obscureText: true,
//                    maxLength: 12,
//                    controller: _passwordController,
//                    style: Theme.of(context).textTheme.bodyText2,
//                    validator: (value) => value.length < 6
//                        ? AppLocalizations.of(context)
//                            .translate("loginTxtErrorPassword")
//                        : null,
//                    decoration: InputDecoration(
//                        prefixIcon: Icon(
//                          Icons.lock,
//                          color: Colors.blueGrey,
//                        ),
//                        labelText: AppLocalizations.of(context)
//                            .translate("loginTxtPassword"),
//                        border: OutlineInputBorder()),
//                  ),
//                ),
//                authProvider.status == Status.Authenticating
//                    ? Center(
//                        child: CircularProgressIndicator(),
//                      )
//                    : ElevatedButton(
//                        child: Text(
//                          AppLocalizations.of(context)
//                              .translate("loginBtnSignIn"),
//                          style: TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
//                        ),
//                        onPressed: () async {
//                          if (_formKey.currentState.validate()) {
//                            FocusScope.of(context)
//                                .unfocus(); //to hide the keyboard - if any
//
//                            bool status =
//                                await authProvider.signInWithEmailAndPassword(
//                                    _emailController.text,
//                                    _passwordController.text);
//
//                            if (!status) {
//                              _scaffoldKey.currentState.showSnackBar(SnackBar(
//                                content: Text(AppLocalizations.of(context)
//                                    .translate("loginTxtErrorSignIn")),
//                              ));
//                            }
//                          }
//                        }),
//                authProvider.status == Status.Authenticating
//                    ? Center(
//                        child: null,
//                      )
//                    : Padding(
//                        padding: const EdgeInsets.only(top: 20),
//                        child: Center(
//                            child: Text(
//                          AppLocalizations.of(context)
//                              .translate("loginTxtDontHaveAccount"),
//                              style: TextStyle(color:Colors.blueGrey,fontSize: 18,fontWeight: FontWeight.bold),
//                        )),
//                      ),
//                authProvider.status == Status.Authenticating
//                    ? Center(
//                        child: null,
//                      )
//                    : TextButton(
//                        child: Text(AppLocalizations.of(context)
//                            .translate("loginBtnLinkCreateAccount"),style: TextStyle(color:Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.bold)),
////                        textColor: Theme.of(context).iconTheme.color,
//                        onPressed: () {
//                          Navigator.of(context)
//                              .pushReplacementNamed(Routes.register);
//                        },
//                      ),
//                 Center(
//                     child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       Provider.of<Flavor>(context).toString(),
//                       style: Theme.of(context).textTheme.bodyText2,
//                     ),
//                   ],
//                 )),
              ],
            ),
          ),
        ));
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
