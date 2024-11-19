import 'package:flutter/material.dart';

class Settings extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setttings"),
        backgroundColor: Colors.red,
      ),
      body: Card(
        child: Column(
          children: [
            Row(
              children: [
                Text("Karanlık moda geç"),
                IconButton(
                    onPressed: (){

                    },
                    icon: Icon(Icons.change_circle_outlined))
              ],
            )
          ],
        ),
      ),
    );
  }

}