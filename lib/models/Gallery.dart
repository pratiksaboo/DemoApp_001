import 'dart:convert';

List<Gallery> galleryFromJson(String str) => new List<Gallery>.from(json.decode(str).map((x) => Gallery.fromJson(x)));

String galleryToJson(List<Gallery> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));


class Gallery {

  String imageURL;
  String blogId;
  String fileCategory;
  String extension;
  DateTime postingDate;



  Gallery({

    this.imageURL,
    this.blogId,
    this.fileCategory,
    this.extension,
    this.postingDate,


  });

  factory Gallery.fromJson(Map<String, dynamic> json) => new Gallery(

    imageURL: json["imageURL"] == null ? null :json["imageURL"],
    blogId: json["blogId"] == null ? null :json["blogId"],
    fileCategory: json["fileCategory"] == null ? null :json["fileCategory"],
    extension:json["extension"] == null ? null : json["extension"],
    postingDate:json["postingDate"] == null ? null :json["postingDate"].toDate(),


  );

  Map<String, dynamic> toJson() => {

    "imageURL": imageURL,
    "blogId": blogId,
    "fileCategory": fileCategory,
    "extension": extension,
    "postingDate": postingDate,


  };
}


