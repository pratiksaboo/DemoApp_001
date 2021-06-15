import 'dart:convert';

List<Nominee> nomineeFromJson(String str) => new List<Nominee>.from(json.decode(str).map((x) => Nominee.fromJson(x)));

String nomineeToJson(List<Nominee> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));


class Nominee {

  String nomineeId;
  String nomineeName;
  String isoCode;
  String countryCode;
  String nomineeContact;
  String nomineeEmail;
  String nomineeRelation;
  DateTime addedOn;
  bool isActive;


  Nominee({

    this.nomineeId,
    this.nomineeName,
    this.isoCode,
    this.countryCode,
    this.nomineeContact,
    this.nomineeEmail,
    this.nomineeRelation,
    this.addedOn,
    this.isActive,

  });

  factory Nominee.fromJson(Map<String, dynamic> json) => new Nominee(

    nomineeId: json["nomineeId"] == null ? null :json["nomineeId"],
    nomineeName: json["nomineeName"] == null ? null :json["nomineeName"],
    isoCode: json["isoCode"] == null ? null :json["isoCode"],
    countryCode: json["countryCode"] == null ? null :json["countryCode"],
    nomineeContact: json["nomineeContact"] == null ? null :json["nomineeContact"],
    nomineeEmail: json["nomineeEmail"] == null ? null :json["nomineeEmail"],
    nomineeRelation: json["nomineeRelation"] == null ? null :json["nomineeRelation"],
    addedOn: json["addedOn"] == null ? null :json["addedOn"].toDate(),
    isActive: json["isActive"],

  );

  Map<String, dynamic> toJson() => {

    "nomineeId": nomineeId,
    "nomineeName": nomineeName,
    "isoCode": isoCode,
    "countryCode": countryCode,
    "nomineeContact": nomineeContact,
    "nomineeEmail": nomineeEmail,
    "nomineeRelation": nomineeRelation,
    "addedOn": addedOn,
    "isActive": isActive,

  };
}

