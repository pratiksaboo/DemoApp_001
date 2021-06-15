import 'dart:convert';

List<Agreements> quotesFromJson(String str) => new List<Agreements>.from(json.decode(str).map((x) => Agreements.fromJson(x)));

String quotesToJson(List<Agreements> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));


class Agreements {

  String title;
  String description;



  Agreements({

    this.title,
    this.description,


  });

  factory Agreements.fromJson(Map<String, dynamic> json) => new Agreements(

    title: json["title"] == null ? null :json["title"],
    description: json["description"] == null ? null :json["description"],

  );

  Map<String, dynamic> toJson() => {

    "title": title,
    "description": description,


  };
}