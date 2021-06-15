import 'dart:convert';


List<AppSettings> quotesFromJson(String str) => new List<AppSettings>.from(json.decode(str).map((x) => AppSettings.fromJson(x)));

String quotesToJson(List<AppSettings> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));


class AppSettings {

  bool showQuoteByDate = false;
  // String splashUrl;
  int quoteFontSize = 14;
  String minAppVersion;



  AppSettings({

    this.showQuoteByDate,
    // this.splashUrl,
    this.quoteFontSize,
    this.minAppVersion,

  });

  factory AppSettings.fromJson(Map<String, dynamic> json) => new AppSettings(

    showQuoteByDate: json["showQuoteByDate"] == null ? null :json["showQuoteByDate"],
    // splashUrl: json["splashUrl"] == null ? null :json["splashUrl"],
    quoteFontSize: json["quoteFontSize"] == null ? null :json["quoteFontSize"],
    minAppVersion: json["minAppVersion"] == null ? null :json["minAppVersion"],
  );

  Map<String, dynamic> toJson() => {

    "showQuoteByDate": showQuoteByDate,
    // "splashUrl": splashUrl,
    "quoteFontSize": quoteFontSize,
    "minAppVersion": minAppVersion,

  };
}