import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/screens/home_page.dart';
import 'package:todo_list/view_model/kisi_view_model.dart';

void main() {
  runApp(AnaUygulama());
}

class AnaUygulama extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => PersonViewModel()),  // PersonViewModel sağlanıyor
        ],
        child: HomePage(),  // HomePage widget'ı burada sağlanıyor
      ),
    );
  }
}
