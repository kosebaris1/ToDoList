import 'package:flutter/material.dart';

import '../local_database.dart';
import '../model/istek.dart';

class About extends StatelessWidget {
  LocalDatabase db = LocalDatabase();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Uygulama Hakkında"),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _oneriEkle(context);
        },
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          // Uygulama Hakkında Bilgi Kartı
          _bilgiKart(
            icon: Icons.info_outline,
            title: "Uygulama Amacı",
            description:
            "Bu uygulama, kullanıcıların günlük yaşamlarını organize etmelerine ve bilgilerini düzenli bir şekilde saklamalarına yardımcı olmak için tasarlanmış kullanıcı dostu bir uygulamadır. ",
          ),
          SizedBox(height: 20),

          // Kullanım Bilgisi Kartı
          _bilgiKart(
            icon: Icons.settings,
            title: "Kullanım Bilgisi",
            description:
            "Uygulamayı kullanarak kişileri ekleyebilir, her biri için notlar oluşturabilirsiniz. Bu notlar, günlük hayatta ve iş yerlerinde  yaptığınız çalışmaları kaydetmek için idealdir.",
          ),
          SizedBox(height: 20),

          // İletişim Kartı
          _bilgiKart(
            icon: Icons.contact_mail,
            title: "İletişim",
            description:
            "Herhangi bir sorun veya öneri için bizimle iletişime geçebilirsiniz. Email: destekTalep@gmail.com",
          ),
        ],
      ),
    );
  }

  Widget _bilgiKart({
    required IconData icon, // İkon parametresi eklendi
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 8, // Daha yüksek gölge efekti
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Kenarları daha yuvarlak
      ),
      shadowColor: Colors.deepPurple.withOpacity(0.5), // Gölgenin rengi
      child: Padding(
        padding: EdgeInsets.all(20), // İçerik kenar boşluğu genişletildi
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // İkon
                Icon(
                  icon,
                  size: 30,
                  color: Colors.deepPurple,
                ),
                SizedBox(width: 10),

                // Başlık
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple, // Başlık rengi
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Açıklama Metni
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                height: 1.5, // Satır arası boşluk
                color: Colors.black87, // Açıklama metni rengi
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _oneriEkle(BuildContext context) async {
    String? istek=await _pencereAc(context);
    if(istek !=null ){
      Istek yeniIstek=Istek(istek);
      print(yeniIstek);
      int bolumId = await db.createIstek(yeniIstek);
    }
  }

  Future<String?> _pencereAc(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        String? sonuc;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "İstek ve Öneri",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.blueGrey,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Görüşlerinizi paylaşarak bize yardımcı olabilirsiniz.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 15),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "İsteğinizi veya önerinizi yazınız",
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  alignLabelWithHint: true,
                  suffixIcon: Icon(
                    Icons.feedback,
                    color: Colors.blueAccent,
                  ),
                ),
                onChanged: (yeniDeger) {
                  sonuc = yeniDeger;
                },
              ),
            ],
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
              child: Text("Gönder"),
              onPressed: () {
                Navigator.pop(context, sonuc);
              },
            ),
          ],
        );
      },
    );
  }
}
