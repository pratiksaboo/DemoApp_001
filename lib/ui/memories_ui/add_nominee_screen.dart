import 'package:flutter/widgets.dart';
import 'package:flutter_memory/Utility/Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memory/Utility/validate.dart';
import 'package:flutter_memory/constants/string.dart';
import 'package:flutter_memory/models/Blog.dart';
import 'package:flutter_memory/models/nominee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../app_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_memory/models/RelationNominee.dart';

class AddNomineeScreen extends StatefulWidget {
  final Nominee nominee;


  AddNomineeScreen({Key key, @required this.nominee}) : super(key: key);

  @override
  _AddNomineeScreenState createState() => _AddNomineeScreenState(nominee);
}

class _AddNomineeScreenState extends State<AddNomineeScreen> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Nominee nominee;
  String name,  email;
  String roleRelation;
  bool _loading = false;

  String phoneNumber1;
  String phoneIsoCode;
  String phoneCountryCode;
  bool visible = false;
  String confirmedNumber = '';
  bool _status = true;
  String userId;
  // String phoneError;
  List<Blog> blogList = [];

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'IN';
  bool isValidNumber = false;
  String title;

  FocusNode _focusNode;
  Relation relation;
  String role;
  bool changeRole = false;
  bool relationTab = false ;

  String _dropDownValue;
  String _dropdownError;
  _AddNomineeScreenState(this.nominee);


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
  void initState() {
    super.initState();
    getUser();
    if(nominee ==null)_status = false;
    _focusNode = new FocusNode();

  }
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  warnDeleteDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Nominee?'),
            content: Text('Are you sure of deleting nominee?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: ()  {
                  Navigator.pop(context);
                  getBlogs();


                  // Firestore.instance
                  //     .collection('USER').document(userId).collection(StringConstant.NOMINEE)
                  //     .document(nominee.nomineeId)
                  //     .delete().then((result) {
                  //   showDeleteAlertDialog(context, true);
                  // }
                  // )
                  //     .catchError((err) {
                  //   showDeleteAlertDialog(context, false);
                  //   print(err);
                  // });

                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(nominee ==null?"Add Nominee":"Manage Nominee",style: TextStyle(color: Colors.white)),
        // title: Text("Manage Nominee",style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          Visibility(
            visible: false,
            // visible: nominee!=null?true: false,
            child: IconButton(
                icon: Icon(Icons.edit, color: Colors.white,),
                onPressed: () {

                  setState(() {
                    _status = false;
                    FocusScope.of(context).requestFocus(_focusNode);
                    // _focusNode.requestFocus();
                  });

                }),
          ),
          Visibility(
            visible: false,
            // visible: nominee!=null?true: false,
            child: IconButton(
                icon: Icon(Icons.delete, color: Colors.white,),
                onPressed: () {
                  if(nominee !=null && userId !=null){
                    warnDeleteDialog();

                  }


                }),
          ),
        ],
      ),
      body:  Center(

        child: _buildForm(context),

      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(8,8,8,10),
        child: Visibility(
          visible: !_status,
          child: Container(

              child: SizedBox(
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    _formKey.currentState.save();




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
                  // shape: OutlineInputBorder(
                  //     borderRadius: BorderRadius.circular(10)),
                ),
              )
            // This align moves the children to the bottom
          ),
        ),
      ),

    );
  }


  Widget _buildForm(BuildContext context) {

    name = widget.nominee != null &&  widget.nominee.nomineeName != null ?widget.nominee.nomineeName :"";
    email = widget.nominee != null &&  widget.nominee.nomineeEmail != null ?widget.nominee.nomineeEmail :"";

    if(widget.nominee != null &&  widget.nominee.nomineeContact != null){
      phoneNumber1 = widget.nominee.nomineeContact!=null ? widget.nominee.nomineeContact.toString() : "";
      phoneIsoCode = widget.nominee.isoCode!=null ? widget.nominee.isoCode.toString() : "";
      // number = PhoneNumber(phoneNumber:phoneNumber1,isoCode: phoneIsoCode);
    }

    roleRelation = widget.nominee != null &&  widget.nominee.nomineeRelation != null ? widget.nominee.nomineeRelation :"";
    if(!changeRole && roleRelation !=null && roleRelation.isNotEmpty) {
      _dropDownValue = roleRelation;
      role = roleRelation;
    }

    return new Container(

      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
          child:Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
//      mainAxisAlignment: MainAxisAlignment.end,
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
                            enabled: !_status,
                            focusNode: _focusNode,
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.sentences,
                           initialValue: name,
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
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width:0.0)),
                                border: OutlineInputBorder()),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: AbsorbPointer(
                            absorbing: _status? true : false,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[400],
                                  width: 1,
                                ),
                              ),

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

                                      initialCountryCode: phoneIsoCode!=null && phoneIsoCode.isNotEmpty ? phoneIsoCode:'US',
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
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child:TextFormField(
                            enabled: !_status,
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
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width:0.0)),
                                border: OutlineInputBorder()),
                          ),
                        ),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(16,16,16,16),
                            child:Text("Relation With Nominee",style:TextStyle(fontWeight: FontWeight.normal)) ),
                  Align(
                    alignment: Alignment.center,
                    child: IgnorePointer(
                      ignoring:  _status,
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
                                changeRole = true;
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
                  ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _dropdownError == null
                              ? SizedBox.shrink()
                              : Text(
                            _dropdownError ?? "",
                            style: TextStyle(color: Colors.red,fontSize:12),
                          ),
                        ),


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




  showSelectDeleteDialog(BuildContext context, bool status) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Stories And Nominee"),
      onPressed: () {
        for(Blog blogs in blogList)
          {

            if(blogs.content.thumbnailUrl !=null){
              deleteStorage(blogs.content.thumbnailUrl,blogs);
              // FirebaseStorage.instance
              //     .refFromURL(blogs.content.thumbnailUrl).delete().then((value) => deleteFromGallery(blogs)).catchError((e) => print(e));
            }
            else {
              deleteBlog(blogs);
            }
          }
        deleteNominee();

        Navigator.pop(context);

      },
    );
    Widget okButton2 = TextButton(
      child: Text("Only Nominee"),
      onPressed: () {
        deleteNominee();

        Navigator.pop(context);

      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Stories associated with this nominees are found",style: TextStyle(color: Colors.redAccent)),
      content: Text("Please select the action below."),
      actions: [
        TextButton(
          child: Text('Cancel',style: TextStyle(color: Colors.redAccent)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        okButton,
        okButton2,
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
  showDeleteAlertDialog(BuildContext context, bool status) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.of(context).pop();
        // Navigator.of(context).pushNamed(Routes.nomineeList,
        // );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(status ? "Success" : "Error"),
      content: Text(status
          ? "Deleted Successfully"
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
  showAlertDialog(BuildContext context,bool status) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.of(context).pop();
        // Navigator.of(context).pushNamed(Routes.nomineeList,
        // );

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(status?"Success":"Error"),
      content: Text(status?"Saved Successfully":"Error in Saving. Please try again later"),
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

  Future<void> getUser() async {

    // final auth.User user = auth.FirebaseAuth.instance.currentUser;
    final auth.User user = auth.FirebaseAuth.instance.currentUser;
    userId = user.uid;
    print(userId);
  }

  Future<void> getBlogs() async {
    final auth.User user = auth.FirebaseAuth.instance.currentUser;
    final addRef = FirebaseFirestore.instance.collection(StringConstant.BLOGS).where(
        "authorId", isEqualTo: user.uid).get();
    List<Blog> list = [];
    await addRef.then((QuerySnapshot snapshot) {
      list = snapshot.docs.map((DocumentSnapshot documentSnapshot) {
        return Blog.fromJson(documentSnapshot.data());
      }).toList();

    });

    blogList.clear();
    if(list.length>0){
      for(Blog blog in list){

        if((blog.nominee != null && blog.nominee.nomineeId !=null && blog.nominee.nomineeId== nominee.nomineeId) || (blog.nominee2 != null && blog.nominee2.nomineeId !=null  && blog.nominee2.nomineeId== nominee.nomineeId) ) {
          blogList.add(blog);
          print(blog.blogId);
        }
      }
    }
    if(blogList.length>0)
      showSelectDeleteDialog(context, true);
    else
      deleteNominee();
    }

  Future<void> deleteFromGallery(Blog blogs) async {
    final auth.User user = auth.FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('GALLERY').doc(user.uid).collection("IMAGE").doc(blogs.blogId)
        .delete().then((result) {
      // showAlertDialog(context, true);
      deleteBlog(blogs);
    }
    )
        .catchError((err) {
      print(err);
    });
  }
  void deleteBlog(Blog blogs) {
    FirebaseFirestore.instance
        .collection(StringConstant.BLOGS).doc(blogs.blogId)
        .delete().then((result) {
      // showAlertDialog(context, true);
    }
    )
        .catchError((err) {
      print(err);
    });
  }

  void deleteNominee() {
    FirebaseFirestore.instance
        .collection('USER').doc(userId).collection(StringConstant.NOMINEE)
        .doc(nominee.nomineeId)
        .delete().then((result) {
      showDeleteAlertDialog(context, true);
    }
    )
        .catchError((err) {
      showDeleteAlertDialog(context, false);
      print(err);
    });
  }

  handleValue(int index) {
    role = StringConstant.RelationString[index];
    print(role);

  }

  Relation getRelation(int index) {
    switch(index){
      case 0:
        relation = Relation.Parent;
      break;
      case 1:
        relation = Relation.Spouse;
        break;
      case 2:
        relation = Relation.Children;
        break;
      case 3:
        relation = Relation.Sibling;
        break;
      case 4:
        relation = Relation.Partner;
        break;
      case 5:
        relation = Relation.Friend;
        break;
      case 6:
        relation = Relation.Other;
        break;

    }
    return relation;
  }

  Future<void> deleteStorage(String thumbnailUrl, Blog blog) async {
    String fileName = thumbnailUrl.replaceAll("/o/", "*").replaceAll("%40", "@").replaceAll("%2F", "/");
    fileName = fileName.replaceAll("?", "*");
    fileName = fileName.split("*")[1];
    print(fileName);
    Reference storageReferance = FirebaseStorage.instance.ref();
    storageReferance
        .child(fileName)
        .delete()
        .then((_) => print('Successfully deleted $fileName storage item'))
        .then((value) => deleteFromGallery(blog));
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
