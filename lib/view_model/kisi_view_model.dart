import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/view_model/bolum_view_model.dart';

import '../local_database.dart';
import '../model/kisi.dart';
import '../screens/bolumler_sayfasi.dart';

class PersonViewModel with ChangeNotifier{
  LocalDatabase _db = LocalDatabase();

  List<Kisi> _kisiler=[];

  List<Kisi> get kisiler=> _kisiler;

  PersonViewModel(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bringAllPerson();
    });
  }

  void addPerson(BuildContext context) async {
    String? kisiAdi = await openWindow(context);
    if (kisiAdi != null) {
      Kisi yeniKisi = Kisi(kisiAdi, DateTime.now());
      int kisiId = await _db.createKisi(yeniKisi); // Veritabanına ekle
      yeniKisi.id = kisiId; // ID'yi ayarla
      _kisiler.add(yeniKisi); // Güncellenmiş kişi nesnesini listeye ekle
      notifyListeners();
    }
  }

  void updatePerson(BuildContext context, int index) async {
    String? yeniKisiAdi= await openWindowUpdate(context);
    if(yeniKisiAdi != null){
      Kisi kisi=_kisiler[index];
      kisi.name=yeniKisiAdi;
      notifyListeners();
      int guncellenenSatirSayisi=await _db.updateKisi(kisi);

      if(guncellenenSatirSayisi >0){
      }
    }
  }
  void deletePerson(int index) async{
    Kisi kisi=_kisiler[index];
    print("deleteperson kisi id:${kisi.id}");
    print(kisi.name);
    int silinenSatirSayisi=await _db.deleteKisi(kisi);
    print("Silinen satir sayisi : $silinenSatirSayisi");
    if(silinenSatirSayisi>0){
      _kisiler.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> bringAllPerson() async {
    _kisiler = await _db.readTumKisiler();
    notifyListeners();
  }

  Future<String?> openWindow(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        String? sonuc;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Kişi Ekleyiniz",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          content: TextField(
            decoration: InputDecoration(
              labelText: "İsim ve soyisim giriniz",
              labelStyle: TextStyle(color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.blueAccent, width: 2),
              ),
              suffixIcon: Icon(
                Icons.person,
                color: Colors.blueAccent,
              ),
            ),
            onChanged:(yeniDeger){
              sonuc=yeniDeger;
            },
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                textStyle: TextStyle(fontSize: 16),
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
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Onayla"),
              onPressed: () {
                Navigator.pop(context,sonuc);
              },
            ),
          ],
        );
      },
    );

  }
  Future<String?> openWindowUpdate(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        String? sonuc;

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Kişi Güncelle",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          content: TextField(
            decoration: InputDecoration(
              labelText: "İsim ve soyisim giriniz",
              labelStyle: TextStyle(color: Colors.blueAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.blueAccent, width: 2),
              ),
              suffixIcon: Icon(
                Icons.person,
                color: Colors.blueAccent,
              ),
            ),
            onChanged: (yeniDeger) {
              sonuc = yeniDeger;
            },
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                textStyle: TextStyle(fontSize: 16),
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
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Onayla"),
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
                deletePerson(index);
                print("Kişinin listedeki indeksi : $index");
              },
            ),
          ],
        );
      },
    );

  }

  void bolumlerSayfasiniAc(BuildContext context, int index){
    MaterialPageRoute pageRoute=MaterialPageRoute(
      builder: (context){
        return ChangeNotifierProvider(
          create: (context)=>BolumViewModel(_kisiler[index]),
          child: BolumlerSayfasi(),
        );
      },
    );
    Navigator.push(context, pageRoute);
  }


}