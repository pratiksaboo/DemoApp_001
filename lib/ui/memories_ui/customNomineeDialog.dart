import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memory/Utility/Utility.dart';
import 'package:flutter_memory/Utility/validate.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/RelationNominee.dart';
import 'package:flutter_memory/models/nominee.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../app_localizations.dart';

class CustomNomineeDialogBox extends StatefulWidget {
  final Nominee nominee;

  const CustomNomineeDialogBox({Key key, @required this.nominee}) : super(key: key);

  @override
  _CustomNomineeDialogBoxState createState() => _CustomNomineeDialogBoxState(nominee);
}

class _CustomNomineeDialogBoxState extends State<CustomNomineeDialogBox> {
  final _formKey = GlobalKey<FormState>();
  String name, email;
  bool _loading = false;
  Nominee nominee;
  String phoneNumber1;
  String phoneIsoCode;
  String userId;
  String phoneCountryCode;
  Relation relation;
  String role;
  String _dropDownValue;
  String _dropdownError;

  _CustomNomineeDialogBoxState(this.nominee);

  // void onPhoneNumberChange(
  //     String number, String internationalizedPhoneNumber, String isoCode) {
  //   phoneError = null;
  //   print(number);
  //   setState(() {
  //     phoneNumber1 = number;
  //     phoneIsoCode = isoCode;
  //     confirmedNumber = internationalizedPhoneNumber;
  //     // print(confirmedNumber);
  //   });
  // }
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.sentences,

                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            style: Theme.of(context).textTheme.bodyText2,
                            validator: (value){

                              if(value.isEmpty) return 'Enter Name';
                              else return null;

                            },
                            onSaved: (value) {
                              name = value.trim();
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                labelText: "Name",
                                border: OutlineInputBorder()),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[400],
                                width: 1,
                              ),
                            ),

                            child: Column(
                              children: [
                                // Row(
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Icon(Icons.phone,color: Theme.of(context).iconTheme.color,),
                                //     ),
                                //     Flexible(
                                //       child: Padding(
                                //         padding: const EdgeInsets.all(8.0),
                                //         child: InternationalPhoneInput(
                                //           onPhoneNumberChange:  onPhoneNumberChange,
                                //           initialPhoneNumber: phoneNumber1,
                                //           initialSelection: phoneIsoCode,
                                //           // enabledCountries: ['+91', 'US'],
                                //           showCountryCodes: true,
                                //           showCountryFlags: true,
                                //
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.phone,color: Theme.of(context).iconTheme.color,),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IntlPhoneField(
                                          decoration: InputDecoration(
                                            labelText: 'Phone Number',
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
                                            // _validatePhoneNumber(phoneNumber1,phoneIsoCode);
                                          },

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Visibility(
                                //     visible: phoneError == null? false : true,
                                //     child: Text(phoneError!=null? phoneError:"",style: TextStyle(fontSize: 10,color: Colors.red[900]),)),
                              ],
                            ),
                          ),

                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child:TextFormField(

                            initialValue: email,
                            style: Theme.of(context).textTheme.bodyText2,
                            validator: (value) {
                              return Validate.validateEmail(value);
                            },
                            onSaved: (value) {
                              email = value.trim();
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                labelText: AppLocalizations.of(context).translate("loginTxtEmail"),
                                border: OutlineInputBorder()),
                          ),
                        ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(16,0,16,16),
                      child:Text("Relation With Nominee",style:TextStyle(fontWeight: FontWeight.normal)) ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                            color: Colors.grey, style: BorderStyle.solid, width: 0.80),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16,4,16,4),
                        child: DropdownButton(
                          isExpanded: true,
                          underline: SizedBox(),
                          hint:_dropDownValue == null
                              ? Text('Choose your relation with nominee')
                              : Text(_dropDownValue, style: TextStyle(color: Colors.deepOrangeAccent),
                          ),

                          items: getLanguages.map((RelationNominee lang) {
                            return new DropdownMenuItem<String>(
                              value: lang.name,
                              child: new Text(lang.name),
                            );
                          }).toList(),

                          onChanged: (val) {
                            setState(() {

                              role = val;
                              _dropDownValue = val;
                              _dropdownError = null;
                              print(val);
                            });

                          },

                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: _dropdownError == null
                        ? SizedBox.shrink()
                        : Text(
                      _dropdownError ?? "",
                      style: TextStyle(color: Colors.red,fontSize:12),
                    ),
                  ),
                        // Padding(
                        //     padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                        //
                        //     child:Text("Relation",style:TextStyle(fontWeight: FontWeight.bold)) ),
                        // Column(
                        //
                        //   children: [
                        //     // Padding(
                        //     //   padding: const EdgeInsets.symmetric(vertical: 8),
                        //     //   child:Text("Relation")
                        //     // ),
                        //     ListTile(
                        //       visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        //
                        //       title: const Text(StringConstant.PARENT),
                        //       leading: Radio(
                        //         value: Relation.Parent,
                        //         groupValue: relation,
                        //         onChanged: (Relation value) {
                        //           setState(() {
                        //
                        //             relation = value;
                        //             handleValue(relation.index);
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //     ListTile(
                        //       visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        //
                        //       title: const Text(StringConstant.SPOUSE),
                        //       leading: Radio(
                        //         value: Relation.Spouse,
                        //         groupValue: relation,
                        //         onChanged: (Relation value) {
                        //           setState(() {
                        //
                        //             relation = value;
                        //             handleValue(relation.index);
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //     ListTile(
                        //       visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        //
                        //       title: const Text(StringConstant.CHILDREN),
                        //       leading: Radio(
                        //         value: Relation.Children,
                        //         groupValue: relation,
                        //         onChanged: (Relation value) {
                        //           setState(() {
                        //
                        //             relation = value;
                        //             handleValue(relation.index);
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //     ListTile(
                        //       visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        //
                        //       title: const Text(StringConstant.SIBLING),
                        //       leading: Radio(
                        //         value: Relation.Sibling,
                        //         groupValue: relation,
                        //         onChanged: (Relation value) {
                        //           setState(() {
                        //
                        //             relation = value;
                        //             handleValue(relation.index);
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //     ListTile(
                        //       visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        //
                        //       title: const Text(StringConstant.PARTNER),
                        //       leading: Radio(
                        //         value: Relation.Partner,
                        //         groupValue: relation,
                        //         onChanged: (Relation value) {
                        //           setState(() {
                        //
                        //             relation = value;
                        //             handleValue(relation.index);
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //     ListTile(
                        //       visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        //
                        //       title: const Text(StringConstant.FRIEND),
                        //       leading: Radio(
                        //         value: Relation.Friend,
                        //         groupValue: relation,
                        //         onChanged: (Relation value) {
                        //           setState(() {
                        //
                        //             relation = value;
                        //             handleValue(relation.index);
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //     ListTile(
                        //       visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                        //
                        //       title: const Text(StringConstant.OTHER),
                        //       leading: Radio(
                        //         value: Relation.Other,
                        //         groupValue: relation,
                        //         // onChanged : handleValue(relation.index),
                        //         onChanged: (Relation value) {
                        //           setState(() {
                        //
                        //             relation = value;
                        //             print(relation.index);
                        //             handleValue(relation.index);
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8,16,8,8),
                          child: SizedBox(
                            width: 320.0,
                            child: ElevatedButton(

                              onPressed: () async {
                                _formKey.currentState.save();
                                final form = _formKey.currentState;
                                bool _isValid = form.validate();
                                // if (form.validate()) {
                                if (role == null) {
                                  setState(() => _dropdownError = "Please Select a relation with the nominee!");
                                  _isValid = false;
                                }

                              },
                              child: Text(
                                "ADD",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
      ),
                            ),
                          ),
                        )
                      ],
                    ),

                  ),

                ),

              ),

              _progressIndicator(),
              //your elements here
            ],
          ) ),);
  }

  Widget _progressIndicator() {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),),
      );
    } else {
      return Container();
    }
  }
  void _showIndicator() {
    setState(() {
      _loading = !_loading;
    });
  }
  handleValue(int index) {
    role = StringConstant.RelationString[index];
    print(role);

  }
}
enum Relation
{ Parent,
  Spouse,
  Children,
  Sibling,
  Partner,
  Friend,
  Other
}