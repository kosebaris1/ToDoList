import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/view_model/bolum_view_model.dart';
import '../helpers/drawer_navigation.dart';
import '../model/bolum.dart';
import '../model/kisi.dart';
import '../local_database.dart';
import '../view_model/kisi_view_model.dart';

class BolumlerSayfasi extends StatelessWidget {

  LocalDatabase db = LocalDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: DrawerNavigation(),
      body: _buildBody(),
      floatingActionButton: _buildBolumEkleFab(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    BolumViewModel viewModel = Provider.of<BolumViewModel>(
      context,
      listen: false,
    );
    return AppBar(
      title: Text(viewModel.kisi.name),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            // Önceki sayfaya git
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<BolumViewModel>(
      builder: (context, viewModel, child) => ListView.builder(
        itemCount: viewModel.bolumler.length,
        itemBuilder: (BuildContext context, int index) {
          return ChangeNotifierProvider.value(
            value: viewModel.bolumler[index],
            child: _buildListItem(context, index),
          );
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    BolumViewModel viewModel = Provider.of<BolumViewModel>(
      context,
      listen: false,
    );
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(
      viewModel.bolumler[index].creationDate.toLocal(),
    );
    return Consumer<Bolum>(
      builder: (context, bolum, child) => GestureDetector(
        onTap: () {
          viewModel.notDetaySayfasiniAc(context, index);
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.deepPurpleAccent,
                      radius: 30,
                      child: Icon(
                        Icons.note,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        bolum.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1),
                Text(
                  bolum.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black54),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Kayıt Tarihi: $formattedDate",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(width: 72),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () {
                        viewModel.updateBolum(context, index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        viewModel.openWindowDelete(context, index);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBolumEkleFab(BuildContext context) {
    BolumViewModel viewModel = Provider.of<BolumViewModel>(
      context,
      listen: false,
    );
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        viewModel.addBolum(context);
      },
    );
  }
}
