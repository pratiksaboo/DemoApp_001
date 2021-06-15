import 'dart:convert';
import 'dart:core';

import 'package:flutter_memory/models/BlogMeta.dart';
import 'package:flutter_memory/models/nominee.dart';

List<Blog> blogFromJson(String str) => new List<Blog>.from(json.decode(str).map((x) => Blog.fromJson(x)));

String blogToJson(List<Blog> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));


class Blog {

  String blogId;
  String authorId;
  String selectedDate;
  DateTime createdTimestamp;
  DateTime modifiedTimestamp;
  bool isActive;
  bool isCherishedMemory;
  bool isPublished;
  BlogMeta meta;
  Nominee nominee;
  Nominee nominee2;
  BlogContent content;

  Blog({

    this.blogId,
    this.authorId,
    this.selectedDate,
    this.createdTimestamp,
    this.modifiedTimestamp,
    this.isActive,
    this.isCherishedMemory,
    this.isPublished,
    this.nominee,
    this.nominee2,
    this.meta,
    this.content,
  });

  factory Blog.fromJson(Map<String, dynamic> json) => new Blog(

    blogId: json["blogId"] == null ? null :json["blogId"],
    authorId: json["authorId"] == null ? null :json["authorId"],
    selectedDate: json["selectedDate"] == null ? null :json["selectedDate"],
    createdTimestamp: json["createdTimestamp"] == null ? null :json["createdTimestamp"].toDate(),
    modifiedTimestamp: json["modifiedTimestamp"] == null ? null :json["modifiedTimestamp"].toDate(),
    isActive: json["isActive"],
    isCherishedMemory: json["isCherishedMemory"],
    isPublished: json["isPublished"],
    nominee: json["nominee"] == null ? null : Nominee.fromJson(json["nominee"]),
    nominee2: json["nominee2"] == null ? null : Nominee.fromJson(json["nominee2"]),
    meta: json["meta"] == null ? null : BlogMeta.fromJson(json["meta"]),
    content: json["content"] == null ? null : BlogContent.fromJson(json["content"]),

  );

  Map<String, dynamic> toJson() => {

    "blogId": blogId ,
    "authorId": authorId,
    "selectedDate": selectedDate,
    "createdTimestamp": createdTimestamp,
    "modifiedTimestamp": modifiedTimestamp,
    "isActive": isActive,
    "isCherishedMemory": isCherishedMemory,
    "isPublished": isPublished,

    "meta": meta == null ? null : meta.toJson(),
    "nominee": nominee == null ? null : nominee.toJson(),
    "nominee2": nominee2 == null ? null : nominee2.toJson(),
    "content": content == null ? null : content.toJson()

  };
}

List<BlogContent> blogcontentFromJson(String str) => new List<BlogContent>.from(json.decode(str).map((x) => BlogContent.fromJson(x)));

String blogcontentToJson(List<BlogContent> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class BlogContent {
  String title;
  String body;
  String thumbnailUrl;


  BlogContent(
      {this.title,
        this.body,
        this.thumbnailUrl,
      });

  factory BlogContent.fromJson(Map<String, dynamic> json) => new BlogContent(

    title: json["title"] == null? null :json["title"],
    body: json["body"]== null? null :json["body"],
    thumbnailUrl: json["thumbnailUrl"]== null? null :json["thumbnailUrl"],


  );

  Map<String, dynamic> toJson() => {

    "title": title,
    "body": body,
    "thumbnailUrl": thumbnailUrl,

  };

}





