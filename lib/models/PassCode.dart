import 'dart:convert';

List<PassCodes> quotesFromJson(String str) => new List<PassCodes>.from(json.decode(str).map((x) => PassCodes.fromJson(x)));

String quotesToJson(List<PassCodes> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));


class PassCodes {

  String password;
  bool isSystemLock;
  bool noPassCode;


  PassCodes({

    this.password,
    this.isSystemLock,
    this.noPassCode,

  });

  factory PassCodes.fromJson(Map<String, dynamic> json) => new PassCodes(

    password: json["password"] == null ? null :json["password"],
    isSystemLock: json["isSystemLock"] == null ? null :json["isSystemLock"],
    noPassCode: json["noPassCode"] == null ? null :json["noPassCode"],
  );

  Map<String, dynamic> toJson() => {

    "password": password,
    "isSystemLock": isSystemLock,
    "noPassCode": noPassCode,

  };
}