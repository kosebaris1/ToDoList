import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/helpers/drawer_navigation.dart';
import 'package:todo_list/local_database.dart';
import 'package:todo_list/view_model/kisi_view_model.dart';
import '../model/kisi.dart';
import 'bolumler_sayfasi.dart';

class HomePage extends StatelessWidget {
  LocalDatabase _db = LocalDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDoList"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      drawer: DrawerNavigation(),
      body: _buildBody(),
      floatingActionButton: _buildKisiEkleFab(context),
    );
  }

  Widget _buildBody() {
    return Consumer<PersonViewModel>(
      builder: (context, viewModel, child) => ListView.builder(
        itemCount: viewModel.kisiler.length,
        itemBuilder: (context, index) {
          return ChangeNotifierProvider.value(
            value: viewModel.kisiler[index],
            child: _buildListItem(context, index),
          );
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    PersonViewModel viewModel = Provider.of<PersonViewModel>(context, listen: false);
    Kisi kisi = viewModel.kisiler[index];
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(kisi.creationDate.toLocal());

    return Consumer<Kisi>(
      builder: (context, kisi, child) => Card(
        elevation: 4, // Gölgelendirme ile öğeyi yükseltme
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Köşeleri yuvarlama
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurple,
            radius: 30,
            child: Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          title: Text(
            kisi.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(
            "Kayıt tarih: $formattedDate",
            style: TextStyle(color: Colors.grey[600]),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  viewModel.updatePerson(context, index);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  viewModel.openWindowDelete(context, index);
                },
              ),
            ],
          ),
          onTap: () {
            viewModel.bolumlerSayfasiniAc(context, index);
          },
        ),
      ),
    );
  }

  Widget _buildKisiEkleFab(BuildContext context) {
    PersonViewModel viewModel = Provider.of<PersonViewModel>(context, listen: false);
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        viewModel.addPerson(context);
      },
    );
  }
}
