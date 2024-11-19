/*
import 'package:flutter/material.dart';


import '../local_database.dart';
import '../model/bolum.dart';

class NotDetayViewModel{
  final Bolum _bolum;
  LocalDatabase _db = LocalDatabase();
  NotDetayViewModel(this._bolum);

  void _kaydet(String content) async {
    _bolum.content = content;
    await _db.updateBolum(_bolum);

    // Kaydetme işlemi sonrası geri bildirim
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Not başarıyla kaydedildi!"),
        backgroundColor: Colors.green,
      ),
    );
  }
}


 */
