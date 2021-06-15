import 'dart:convert';

List<BlogMeta> metaFromJson(String str) => new List<BlogMeta>.from(json.decode(str).map((x) => BlogMeta.fromJson(x)));

String metaToJson(List<BlogMeta> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));


class BlogMeta {

  String authorId;
  String modifiedDate;
  String createdDate;
  DateTime createdTimestamp;
  DateTime lastModifiedTimestamp;
  bool isActive;
  String thumbnail;
  Weather weather;
  BlogLocation blogLocation;

  BlogMeta({

    this.authorId,
    this.modifiedDate,
    this.createdDate,
    this.lastModifiedTimestamp,
    this.createdTimestamp,
    this.isActive,
    this.thumbnail,
    this.weather,
    this.blogLocation,
  });

  factory BlogMeta.fromJson(Map<String, dynamic> json) => new BlogMeta(

    authorId: json["authorId"] == null ? null :json["authorId"],
    modifiedDate: json["modifiedDate"] == null ? null :json["modifiedDate"],
    createdDate: json["createdDate"] == null ? null :json["createdDate"],
    lastModifiedTimestamp: json["lastModifiedTimestamp"] == null ? null :json["lastModifiedTimestamp"].toDate(),
    createdTimestamp: json["createdTimestamp"] == null ? null :json["createdTimestamp"].toDate(),
    isActive: json["isActive"],
    thumbnail: json["thumbnail"] == null ? null :json["thumbnail"],
    weather: json["weather"] == null ? null : Weather.fromJson(json["weather"]),
    blogLocation:  json["blogLocation"] == null ? null : BlogLocation.fromJson(json["blogLocation"]),
   

  );

  Map<String, dynamic> toJson() => {

    "authorId": authorId,
    "modifiedDate": modifiedDate,
    "createdDate": createdDate,
    "createdTimestamp": createdTimestamp,
    "lastModifiedTimestamp": lastModifiedTimestamp,
    "isActive": isActive,
    "thumbnail": thumbnail,
    "weather":  weather == null ? null : weather.toJson(),
    "blogLocation": blogLocation == null ? null : blogLocation.toJson(),

  };


}
List<Weather> weatherFromJson(String str) => new List<Weather>.from(json.decode(str).map((x) => Weather.fromJson(x)));

String weatherToJson(List<Weather> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));
class Weather {
  String address;
  String tempCelsius;


  Weather(
      {this.address,
        this.tempCelsius,
  });
  factory Weather.fromJson(Map<String, dynamic> json) => new Weather(

    address: json["address"] == null ? null :json["address"],
    tempCelsius: json["temp_celsius"] == null ? null :json["temp_celsius"],
      );

  Map<String, dynamic> toJson() => {

    "address": address,
    "temp_celsius": tempCelsius,
     };

}
List<BlogLocation> locationFromJson(String str) => new List<BlogLocation>.from(json.decode(str).map((x) => BlogLocation.fromJson(x)));

String locationToJson(List<BlogLocation> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class BlogLocation {
  String cityName;
  double latitude;
  double longitude;

  BlogLocation(
      {this.cityName,
        this.latitude,
        this.longitude,
      });
  factory BlogLocation.fromJson(Map<String, dynamic> json) => new BlogLocation(

    cityName: json["cityName"] == null ? null :json["cityName"],
    latitude: json["latitude"] == null ? null :json["latitude"],
    longitude: json["longitude"] == null ? null :json["longitude"],


  );

  Map<String, dynamic> toJson() => {

    "cityName": cityName,
    "latitude": latitude,
    "longitude": longitude,


  };
}
