import 'package:flutter/material.dart';
import '../model/bolum.dart';
import '../local_database.dart';

class NotDetaySayfasi extends StatefulWidget {
  final Bolum _bolum;

  NotDetaySayfasi(this._bolum, {super.key});

  @override
  State<NotDetaySayfasi> createState() => _NotDetaySayfasiState();
}

class _NotDetaySayfasiState extends State<NotDetaySayfasi> {
  LocalDatabase _db = LocalDatabase();

  TextEditingController _icerikController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: _buildSaveButton(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        widget._bolum.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.deepPurpleAccent,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            _icerikController.clear();  // Metin alanını temizler
          },
          tooltip: "Metni Sil",
        ),
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () {
            _kaydet(context);
          },
          tooltip: "Kaydet",
        ),
      ],
    );
  }

  Widget _buildBody() {
    _icerikController.text = widget._bolum.content;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Notunuzu Düzenleyin:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadowColor: Colors.deepPurple.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _icerikController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: "Notunuzu buraya yazın...",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  cursorColor: Colors.deepPurpleAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        _kaydet(context);
      },
      label: Text("Kaydet"),
      icon: Icon(Icons.save),
      backgroundColor: Colors.deepPurpleAccent,
    );
  }

  void _kaydet(BuildContext context) async {
    widget._bolum.content = _icerikController.text;
    await _db.updateBolum(widget._bolum);


    // Kaydetme işlemi sonrası geri bildirim
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Not başarıyla kaydedildi!"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
