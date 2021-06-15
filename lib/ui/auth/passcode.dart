import 'package:flutter/material.dart';
import 'package:flutter_memory/models/PassCode.dart';


class PassCodeScreen extends StatefulWidget {
  // final  bool isSupported;

  // const PassCodeScreen({Key key, @required this.isSupported}) : super(key: key);

  @override
  _PassCodeScreenState createState() => _PassCodeScreenState();
}

class _PassCodeScreenState extends State<PassCodeScreen> {
  final _formKey = GlobalKey<FormState>();


  // final  bool isSupported;
  TextEditingController _passwordController = TextEditingController(text: "");
  _PassCodeScreenState();


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

                            obscureText: true,
                            maxLength: 4,
                            controller: _passwordController,
                            style: Theme.of(context).textTheme.bodyText2,
                            validator: (value){

                                if (value.isEmpty || value.length < 4)
                                  return 'Please Enter Password';

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
                                border: OutlineInputBorder()),

                          ),
                        ),



                        SizedBox(
                          width: 320.0,
                          child: ElevatedButton(
                            onPressed: () async {
                              _formKey.currentState.save();
                              final form = _formKey.currentState;

                              if (form.validate()) {
                                PassCodes passCode = new PassCodes();
                                passCode.isSystemLock = false;
                                passCode.password = _passwordController.text;
                                // if(!isSystemLock)  passCode.password = _passwordController.text;
                                // else  passCode.password = null;
                                Navigator.pop(context, passCode);
                                // Navigator.pop(context);
                                // Navigator.of(context, rootNavigator: true).pop(passCode);
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