import 'package:cloud_firestore/cloud_firestore.dart';
class User {
  DocumentReference reference;
  String id;
  String emailId;
  String userName;
  String isoCode;
  String countryCode;
  String contactNumber;
  String dob;
  String disclosingDate;
//  Nominee nominee;
  String passcode;
  bool isActive = true;
  bool isBlogger = true;
  bool isManagement = false;
  bool isPaidUser = false;
  bool muteAudio = false ;
  String designation;
  String themeColourHex;
  DateTime accountExpiry;
  DateTime lastPayment;
  bool isAgreedTnC = false;
  bool isSystemPasscode = false;
  bool noPasscode = false;

  User(
      {
        this.id,
        this.emailId,
        this.userName,
        this.contactNumber,
        this.countryCode,
        this.isoCode,
        this.dob,
        this.disclosingDate,
//        this.nominee,
        this.passcode,
        this.isActive,
        this.isBlogger,
        this.isManagement,
        this.isPaidUser,
        this.muteAudio,
        this.designation,
        this.themeColourHex,
        this.accountExpiry,
        this.lastPayment,
        this.isAgreedTnC,
        this.isSystemPasscode,
        this.noPasscode
      });
  User.fromMap(Map<String, dynamic> map, {this.reference}) {
    id = map["id"];
    emailId = map["emailId"];
    userName = map["userName"];
    isoCode  = map["isoCode"];
    contactNumber = map["contactNumber"];
    countryCode = map["countryCode"];
    dob = map["dob"];
    disclosingDate = map["disclosingDate"];
//    nominee = map["nominee"];
    passcode = map["passcode"];
    isActive = map["isActive"];
    isBlogger = map["isBlogger"];
    isManagement = map["isManagement"];
    isPaidUser = map["isPaidUser"];
    muteAudio = map["muteAudio"];
    designation = map["designation"];
    themeColourHex = map["themeColourHex"];
    accountExpiry = map["accountExpiry"];
    lastPayment = map["lastPayment"];
    isAgreedTnC = map["isAgreedTnC"];
    isSystemPasscode = map["isSystemPasscode"];
    noPasscode = map["noPasscode"];
  }
  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  toJson() {
    return {'id': id,'emailId':emailId,'userName':userName,'isoCode':isoCode,'contactNumber':contactNumber,'dob':dob , 'disclosingDate':disclosingDate ,
     'countryCode':countryCode,
      'passcode':passcode ,'isActive':isActive , 'isBlogger':isBlogger ,
      'isManagement':isManagement , 'isPaidUser':isPaidUser,  'muteAudio':muteAudio, 'designation':designation, 'themeColourHex':themeColourHex,
      'accountExpiry':accountExpiry, 'lastPayment':lastPayment,'isAgreedTnC':isAgreedTnC,'isSystemPasscode':isSystemPasscode,'noPasscode':noPasscode
    };
  }
  factory User.fromJson(json) => new User(

    id: json["id"] == null ? null :json["id"],
    emailId: json["emailId"] == null ? null :json["emailId"],
    userName: json["userName"] == null ? null :json["userName"],
    contactNumber: json["contactNumber"] == null ? null :json["contactNumber"],
    countryCode: json["countryCode"] == null ? null :json["countryCode"],
    isoCode: json["isoCode"] == null ? null :json["isoCode"],
    dob: json["dob"] == null ? null :json["dob"],
    disclosingDate: json["disclosingDate"] == null ? null :json["disclosingDate"],
    passcode: json["passcode"] == null ? null :json["passcode"],
    isBlogger: json["isBlogger"] == null ? null :json["isBlogger"],
    isManagement: json["isManagement"] == null ? null :json["isManagement"],
    isActive: json["isActive"],
    isPaidUser: json["isPaidUser"] == null ? null :json["isPaidUser"],
    muteAudio: json["muteAudio"] == null ? null :json["muteAudio"],
    designation: json["designation"] == null ? null :json["designation"],
    themeColourHex: json["themeColourHex"] == null ? null :json["themeColourHex"],
    accountExpiry: json["accountExpiry"] == null ? null :json["accountExpiry"],
    lastPayment: json["lastPayment"] == null ? null :json["lastPayment"],
    isAgreedTnC: json["isAgreedTnC"] == null ? null :json["isAgreedTnC"],
    isSystemPasscode: json["isSystemPasscode"] == null ? null :json["isSystemPasscode"],
    noPasscode: json["noPasscode"] == null ? null :json["noPasscode"],
     );
}













