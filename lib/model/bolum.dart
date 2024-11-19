import 'package:flutter/material.dart';

class Bolum with ChangeNotifier{
  dynamic id;
  int personId;
  String title; //başlık
  String content; //içerik
  DateTime creationDate;

  Bolum(this.personId,this.title,this.creationDate) :content="";

  Bolum.fromMap(Map<String,dynamic> map):
        id=map["id"],
        personId=map["personId"],
        title=map["title"],
        content= map["content"],
        creationDate=map["creationDate"];



  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "personId":personId,
      "title":title,
      "content":content,
      "creationDate":creationDate
    };
  }


}
