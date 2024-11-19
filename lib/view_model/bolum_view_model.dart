
import 'package:flutter/material.dart';
import 'package:todo_list/local_database.dart';
import '../model/bolum.dart';
import '../model/kisi.dart';
import '../screens/not_detay_sayfasi.dart';

class BolumViewModel with ChangeNotifier{
  final Kisi _kisi;
  LocalDatabase db=LocalDatabase();
  List<Bolum> _bolumler=[];
  List<Kisi> _kisiler=[];
  Kisi get kisi=>_kisi;
  List<Bolum> get bolumler=>_bolumler;

  BolumViewModel(this._kisi){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bringAllBolumler();
    });
  }


  void addBolum(BuildContext context) async{
    String? bolumBasligi=await _openWindow(context);
    int? kisiId =_kisi.id;


    print("addBolum metodundaki kisiid:$kisiId");
    print("addBolum metodundaki kisiid:${_kisi.name}");
    print("addBolum metodundaki kisiid:$kisiId");
    print("addBolumdeki bolumbasliği: ${_kisi.name}");


    if(bolumBasligi !=null && kisiId != null){
      Bolum yeniBolum=Bolum(kisiId,bolumBasligi,DateTime.now());
      int bolumId = await db.createBolum(yeniBolum);
      yeniBolum.id=bolumId; // Burdada bolumler id database tarafında otomatik arttırılıyor listeye kendi elimizle eklememiz gerek
        _bolumler.add(yeniBolum);
        notifyListeners();
    }
  }
  void updateBolum(BuildContext context, int index) async {
    String? yeniBolumBasligi= await _openWindowUpdate(context);
    if(yeniBolumBasligi != null){
      Bolum bolum=_bolumler[index];
      bolum.title=yeniBolumBasligi;
      notifyListeners();
      int guncellenenSatirSayisi=await db.updateBolum(bolum);
      if(guncellenenSatirSayisi >0){
       // setState(() {});
      }
    }
  }
  void _deleteBolum(int index) async{

    Bolum bolum=_bolumler[index];
    int silinenSatirSayisi=await db.deleteBolum(bolum);

      _bolumler.removeAt(index);
      notifyListeners();

  }

  Future<void> bringAllBolumler() async {
    int? kisiId=_kisi.id;
    if(kisiId != null){
      _bolumler = await db.readTumBolumler(kisiId);
      print("Bolumler: $_bolumler");
      notifyListeners();
    }
   // setState(() {});

  }

  Future<String?> _openWindow(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        String? sonuc;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: Text(
            "Başlık Girin",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          content: TextField(
            decoration: InputDecoration(
              labelText: "Başlık",
              labelStyle: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.blueAccent,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            onChanged: (yeniDeger) {
              sonuc = yeniDeger;
            },
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              child: Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              ),
              child: Text(
                "Onayla",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Navigator.pop(context, sonuc);
              },
            ),
          ],
        );

      },
    );

  }
  Future<String?> _openWindowUpdate(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        String? sonuc;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: Text(
            "Başlık Güncelle",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          content: TextField(
            decoration: InputDecoration(
              labelText: "Başlık",
              labelStyle: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.blueAccent,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            onChanged: (yeniDeger) {
              sonuc = yeniDeger;
            },
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              child: Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              ),
              child: Text(
                "Onayla",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Navigator.pop(context, sonuc);
              },
            ),
          ],
        );

      },
    );
  }
  Future<String?> openWindowDelete(BuildContext context, int index) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        String? sonuc;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              SizedBox(width: 8),
              Text(
                "Kişiyi Sil",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Text(
            "Bu işlemi geri alamayabilirsiniz. Silmek istediğinizden emin misiniz?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey, padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text("Hayır"),
              onPressed: () {
                Navigator.pop(context, sonuc);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                "Evet",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context, sonuc);
                _deleteBolum(index);
              },
            ),
          ],
        );
      },
    );

  }

  void notDetaySayfasiniAc(BuildContext context, int index){
    MaterialPageRoute pageRoute=MaterialPageRoute(
      builder: (context){
        return NotDetaySayfasi(_bolumler[index]);
      },
    );
    Navigator.push(context, pageRoute);

  }
}

