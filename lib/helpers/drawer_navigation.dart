import 'package:flutter/material.dart';
import 'package:todo_list/screens/about.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({super.key});

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Drawer(
        child: Material(
          color: Colors.blueGrey[50], // Drawer arka plan rengi
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // User account header kısmı
              const UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("assets/logooooo.png"),
                ),
                accountName: Text(
                  "TO DO LIST",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  "Yapılacaklar Listesi",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // About kısmını ortalayalım
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => About()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_circle_outlined, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Text(
                            "About",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Kullanıcıya açıklama metni
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text(
                  "Uygulamayı kullanırken karşılaştığınız herhangi bir sorun, öneri veya geri bildiriminiz için bu bölümden bizlere ulaşabilirsiniz. Amacımız kullanıcı deneyiminizi en üst düzeye çıkarmak ve uygulamamızı daha verimli hale getirmek. Her türlü öneriniz bizim için değerlidir ve en kısa sürede değerlendirilip geri dönüş sağlanacaktır.",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Divider(thickness: 1, color: Colors.grey[300]),
              // Versiyon numarası
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Version 1.0.0",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
