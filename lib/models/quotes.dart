import 'dart:convert';
List<Quotes> quotesFromJson(String str) => new List<Quotes>.from(json.decode(str).map((x) => Quotes.fromJson(x)));

String quotesToJson(List<Quotes> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));


class Quotes {

  String quoteId;
  String quoteMessage;
  String date;
  String userId;
  String approvedBy;
  bool isActive;
  DateTime createdTimestamp;
  DateTime modifiedTimestamp;

  Quotes({

  this.quoteId,
  this.quoteMessage,
   this.date,
    this.userId,
    this.approvedBy,
    this.isActive,
    this.createdTimestamp,
    this.modifiedTimestamp,
  });

  factory Quotes.fromJson(Map<String, dynamic> json) => new Quotes(

    quoteId: json["quoteId"] == null ? null :json["quoteId"],
    quoteMessage: json["quoteMessage"] == null ? null :json["quoteMessage"],
    date: json["date"] == null ? null :json["date"],
    userId:json["userId"] == null ? null : json["userId"],
    approvedBy:json["approvedBy"] == null ? null : json["approvedBy"],
    isActive: json["isActive"] == null ? null : json["isActive"],
    createdTimestamp: json["createdTimestamp"] == null ? null :json["createdTimestamp"].toDate(),
    modifiedTimestamp: json["modifiedTimestamp"] == null ? null :json["modifiedTimestamp"].toDate(),
  );

  Map<String, dynamic> toJson() => {

    "quoteId": quoteId,
    "quoteMessage": quoteMessage,
    "date": date,
    "userId": userId,
    "approvedBy": approvedBy,
    "isActive": isActive,
    "createdTimestamp": createdTimestamp,
    "modifiedTimestamp": modifiedTimestamp,
  };
}