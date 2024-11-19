import 'package:flutter/material.dart';

class Kisi with ChangeNotifier {
  dynamic id;
  String name;
  DateTime creationDate; //oluşturulma tarihi

  Kisi(this.name,this.creationDate);

  Kisi.fromMap(Map<String,dynamic> map):
        id=map["id"],
        name=map["name"],
        creationDate=map["creationDate"];


  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "name":name,
      "creationDate":creationDate,
    };
  }
  void guncelle(String newName){
    name=newName;
      notifyListeners();
  }
}
