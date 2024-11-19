import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_list/model/istek.dart';

import 'model/bolum.dart';
import 'model/kisi.dart';

class LocalDatabase{
  int? newId;
  LocalDatabase._privateConstructor();


 static final LocalDatabase _nesne=LocalDatabase._privateConstructor();

   factory LocalDatabase(){
     return _nesne;
   }

  Database? _veriTabani;
  String _kisilerTabloAdi="kisi";
  String _kisilerId="id";
  String _kisilerIsim="name";
  String _olusturulmaTarihiKisiler="creationDate";

  String _bolumlerTabloAdi="bolumler";
  String _bolumlerId="id";
  String _kisiIdBolumler="personId";
  String _bolumlerbaslik="title";
  String _bolumlerIcerik="content";
  String _olusturulmaTarihiBolumler="creationDate";

  String _isteklerTabloAdi="istekler";
  String _istekVeOneri="istekler";


  Future<Database?> _veriTabaniGetir() async{
    if(_veriTabani==null){
      String dosyaYolu=await getDatabasesPath();
      String veriTabaniYolu=join(dosyaYolu,"todolist.db");
      _veriTabani=await openDatabase(
        veriTabaniYolu,
        version: 1,
        onCreate:_tabloOlustur,
      //  onUpgrade: tabloGuncelle,
      );
    }
    return _veriTabani;
  }
  Future<void> _tabloOlustur(Database db, int versiyon) async{
    await db.execute(
        """
        CREATE TABLE $_kisilerTabloAdi(
        $_kisilerId INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
        $_kisilerIsim TEXT NOT NULL,
        $_olusturulmaTarihiKisiler INTEGER
        );
        """
    );
   await db.execute(
        """
        CREATE TABLE $_bolumlerTabloAdi(
        $_bolumlerId INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
        $_kisiIdBolumler INTEGER NOT NULL,
        $_bolumlerbaslik TEXT NOT NULL,
        $_bolumlerIcerik TEXT,
        $_olusturulmaTarihiBolumler INTEGER , 
        FOREIGN KEY("$_kisiIdBolumler") REFERENCES "$_kisilerTabloAdi"("$_kisilerId") ON UPDATE CASCADE ON DELETE CASCADE
        );
        """
    );
    //Text DEFAULT CURRENT_TIMESTAMP
    await db.execute(
        """
        CREATE TABLE $_isteklerTabloAdi(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        $_istekVeOneri TEXT
        );
        """
    );
  }
/*
  Future<void> tabloGuncelle(Database db, int oldVersion, int newVersion) async {
    List<String> guncellemeKomutlari=[
      "ALTER TABLE $_isteklerTabloAdi ADD COLUMN $_istekVeOneri TEXT",
    ];
    for(int i=oldVersion-1;i<newVersion-1;i++){
     await db.execute(guncellemeKomutlari[i]);
    }


  }

 */


  Future<int> createKisi(Kisi kisi) async {
    Database? db = await _veriTabaniGetir();
    if (db != null) {
      int id = await db.insert(_kisilerTabloAdi, _kisiToMap(kisi));
      kisi.id = id; // Eklenen kişinin ID'sini ayarla
      return id;
    } else {
      return -1;
    }
  }


  Future<List<Kisi>> readTumKisiler() async{
    Database? db=await _veriTabaniGetir();
    List<Kisi> kisiler=[];
    if(db != null){
      List<Map<String,dynamic>> kisilerMap= await db.query(_kisilerTabloAdi);
      for(Map<String,dynamic> m in kisilerMap){
        Kisi y=_mapToKisi(m);
        kisiler.add(y);
      }
    }
    return kisiler;
  }
  Future<int> updateKisi(Kisi kisi) async{
    Database? db=await _veriTabaniGetir();
    print(db.toString());
    if(db != null){
      return await db.update(
          _kisilerTabloAdi,
          _kisiToMap(kisi),
          where: "$_kisilerId=?",
          whereArgs: [kisi.id]
      );
    }else
      return 0;
  }
  Future<int> deleteKisi(Kisi kisi) async{
    Database? db=await _veriTabaniGetir();
    if(db != null){
      print("database kisi id: ${kisi.id}");
      return await db.delete(
          _kisilerTabloAdi,
          where: "$_kisilerId=?",
          whereArgs: [kisi.id]         // HATA BURDA LİSTEYE YENİ KİŞİ EKLENDİĞİNDE NAME VE CREATİON DATE EKLENİYOR ANCAK İD DATABASE TARAFINDAN ARTTIRILDIĞINDAN LİSTEYE EKLENMİYOR VE _listeler.id yapınca null geliyor.
      );
    }else {
      return 0;
    }
  }


  Future<int> createBolum(Bolum bolum) async{
    Database? db=await _veriTabaniGetir();
    if(db != null){
      return await db.insert(_bolumlerTabloAdi, _bolumToMap(bolum));
    }else
      return -1;
  }

  Future<List<Bolum>> readTumBolumler(int kisiId) async{
    Database? db=await _veriTabaniGetir();
    List<Bolum> bolumler=[];
    if(db != null){
      List<Map<String,dynamic>> bolumlerMap= await db.query(
          _bolumlerTabloAdi,
        where: "$_kisiIdBolumler=?",
        whereArgs: [kisiId]
      );
      for(Map<String,dynamic> m in bolumlerMap){
        Bolum b=_mapToBolum(m);
        bolumler.add(b);
      }
    }
    return bolumler;
  }
  Future<int> updateBolum(Bolum bolum) async{
    Database? db=await _veriTabaniGetir();
    if(db != null){
      print("veri tabanı null degil");
      return await db.update(
          _bolumlerTabloAdi,
          _bolumToMap(bolum),
          where: "$_bolumlerId=?",
          whereArgs: [bolum.id]
      );
    }else
      return 0;

  }
  Future<int> deleteBolum(Bolum bolum) async{
    Database? db=await _veriTabaniGetir();
    if(db != null){
      return await db.delete(
          _bolumlerTabloAdi,
          where: "$_bolumlerId=?",
          whereArgs: [bolum.id]
      );
    }else
      return 0;
  }

  Future<int> createIstek(Istek istek) async{
    Database? db=await _veriTabaniGetir();
    if(db != null){
      return await db.insert(_isteklerTabloAdi, istek.toMap());
    }else
      return -1;
  }

  Map<String, dynamic> _kisiToMap(Kisi kisi) {
    Map<String,dynamic> kisiMap=kisi.toMap();
    DateTime? creationDate=kisiMap["creationDate"];
    if(creationDate != null){
      kisiMap["creationDate"]=creationDate.millisecondsSinceEpoch;
    }
    return kisiMap;
  }

  Kisi _mapToKisi(Map<String, dynamic> m) {
    Map<String, dynamic> kisiMap = Map.from(m); // Geçici kopya oluştur
    int? creationDate = kisiMap["creationDate"];
    if (creationDate != null) {
      kisiMap["creationDate"] = DateTime.fromMillisecondsSinceEpoch(
        creationDate,
      );
    }
    return Kisi.fromMap(kisiMap);
  }
}
Map<String, dynamic> _bolumToMap(Bolum bolum) {
  Map<String, dynamic> bolumMap = bolum.toMap();
  DateTime? creationDate = bolumMap["creationDate"];

  // Eğer creationDate null ise, 0 veya geçerli bir değer atayın
  if (creationDate != null) {
    bolumMap["creationDate"] = creationDate.millisecondsSinceEpoch;
  } else {
    bolumMap["creationDate"] = 0;  // Veya başka bir geçerli varsayılan değer
  }

  return bolumMap;
}


Bolum _mapToBolum(Map<String, dynamic> m) {
  Map<String, dynamic> bolumMap = Map.from(m); // Geçici kopya oluştur
  int? creationDate = bolumMap["creationDate"];
  if (creationDate != null) {
    bolumMap["creationDate"] = DateTime.fromMillisecondsSinceEpoch(
      creationDate,
    );
  }
  return Bolum.fromMap(bolumMap);
}





/*
class LocalDatabase{
  LocalDatabase._privateConstructor();

 static final LocalDatabase _nesne=LocalDatabase._privateConstructor();

   factory LocalDatabase(){
     return _nesne;
   }

  Database? _veriTabani;
  String _kisilerTabloAdi="kisi";
  String _kisilerId="id";
  String _kisilerIsim="name";
  String _olusturulmaTarihiKisiler="creationDate";

  String _bolumlerTabloAdi="bolumler";
  String _bolumlerId="id";
  String _kisiIdBolumler="personId";
  String _bolumlerbaslik="title";
  String _bolumlerIcerik="content";
  String _olusturulmaTarihiBolumler="creationDate";

  String _isteklerTabloAdi="istekler";
  String _istekVeOneri="istekler";


  Future<Database?> _veriTabaniGetir() async{
    if(_veriTabani==null){
      String dosyaYolu=await getDatabasesPath();
      String veriTabaniYolu=join(dosyaYolu,"todolist.db");
      _veriTabani=await openDatabase(
        veriTabaniYolu,
        version: 2,
        onCreate:_tabloOlustur,
        onUpgrade: tabloGuncelle,
      );
    }
    return _veriTabani;
  }
  Future<void> _tabloOlustur(Database db, int versiyon) async{
    await db.execute(
        """
        CREATE TABLE $_kisilerTabloAdi(
        $_kisilerId INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
        $_kisilerIsim TEXT NOT NULL,
        $_olusturulmaTarihiKisiler INTEGER
        );
        """
    );
   await db.execute(
        """
        CREATE TABLE $_bolumlerTabloAdi(
        $_bolumlerId INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
        $_kisiIdBolumler INTEGER NOT NULL,
        $_bolumlerbaslik TEXT NOT NULL,
        $_bolumlerIcerik TEXT,
        $_olusturulmaTarihiBolumler INTEGER ,
        FOREIGN KEY("$_kisiIdBolumler") REFERENCES "$_kisilerTabloAdi"("$_kisilerId") ON UPDATE CASCADE ON DELETE CASCADE
        );
        """
    );
    //Text DEFAULT CURRENT_TIMESTAMP
    await db.execute(
        """
        CREATE TABLE $_isteklerTabloAdi(
        id INTEGER PRIMARY KEY AUTOINCREMENT
        );
        """
    );
  }

  Future<void> tabloGuncelle(Database db, int oldVersion, int newVersion) async {
    List<String> guncellemeKomutlari=[
      "ALTER TABLE $_isteklerTabloAdi ADD COLUMN $_istekVeOneri TEXT",
    ];
    for(int i=oldVersion-1;i<newVersion-1;i++){
     await db.execute(guncellemeKomutlari[i]);
    }


  }


  Future<int> createKisi(Kisi kisi) async{
    Database? db=await _veriTabaniGetir();
    if(db != null){
      return await db.insert(_kisilerTabloAdi, kisi.toMap());
    }else
      return -1;
  }

  Future<List<Kisi>> readTumKisiler() async{
    Database? db=await _veriTabaniGetir();
    List<Kisi> kisiler=[];
    if(db != null){
      List<Map<String,dynamic>> kisilerMap= await db.query(_kisilerTabloAdi);
      for(Map<String,dynamic> m in kisilerMap){
        Kisi y=Kisi.fromMap(m);
        kisiler.add(y);
      }
    }
    return kisiler;
  }
  Future<int> updateKisi(Kisi kisi) async{
    Database? db=await _veriTabaniGetir();
    if(db != null){
      return await db.update(
          _kisilerTabloAdi,
          kisi.toMap(),
          where: "$_kisilerId=?",
          whereArgs: [kisi.id]
      );
    }else
      return 0;
  }
  Future<int> deleteKisi(Kisi kisi) async{
    Database? db=await _veriTabaniGetir();
    if(db != null){
      return await db.delete(
          _kisilerTabloAdi,
          where: "$_kisilerId=?",
          whereArgs: [kisi.id]
      );
    }else
      return 0;
  }


  Future<int> createBolum(Bolum bolum) async{
    Database? db=await _veriTabaniGetir();
    if(db != null){
      return await db.insert(_bolumlerTabloAdi, bolum.toMap());
    }else
      return -1;
  }

  Future<List<Bolum>> readTumBolumler(int kisiId) async{
    Database? db=await _veriTabaniGetir();
    List<Bolum> bolumler=[];
    if(db != null){
      List<Map<String,dynamic>> bolumlerMap= await db.query(
          _bolumlerTabloAdi,
        where: "$_kisiIdBolumler=?",
        whereArgs: [kisiId]
      );
      for(Map<String,dynamic> m in bolumlerMap){
        Bolum b=Bolum.fromMap(m);
        bolumler.add(b);
      }
    }
    return bolumler;
  }
  Future<int> updateBolum(Bolum bolum) async{
    Database? db=await _veriTabaniGetir();
    if(db != null){
      return await db.update(
          _bolumlerTabloAdi,
          bolum.toMap(),
          where: "$_bolumlerId=?",
          whereArgs: [bolum.id]
      );
    }else
      return 0;
  }
  Future<int> deleteBolum(Bolum bolum) async{
    Database? db=await _veriTabaniGetir();
    if(db != null){
      return await db.delete(
          _bolumlerTabloAdi,
          where: "$_bolumlerId=?",
          whereArgs: [bolum.id]
      );
    }else
      return 0;
  }

  Future<int> createIstek(Istek istek) async{
    Database? db=await _veriTabaniGetir();
    if(db != null){
      return await db.insert(_isteklerTabloAdi, istek.toMap());
    }else
      return -1;
  }
 */
