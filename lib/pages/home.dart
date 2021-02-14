import 'dart:io';

import 'package:vota_ec/models/candidato.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Candidato> cand = [
    Candidato(id: '1', name: 'Andrés Lelo Arauz', votes: 32),
    Candidato(id: '2', name: 'Lucio Pistolita Gutierrez', votes: 6),
    Candidato(id: '3', name: 'Xavier TikToker Hervas', votes: 16),
    Candidato(id: '4', name: 'Pedro Mushpa Freire', votes: 7),
    Candidato(id: '5', name: 'Yaku Liaste Perez', votes: 19),
    Candidato(id: '6', name: 'Guillermo BanqueroQ Lasso', votes: 19),
    Candidato(id: '7', name: 'JuanFer KanyeWest Velasco', votes: 1),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elecciones',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: cand.length,
        itemBuilder: (context, int i) => _candTile(cand[i]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addNewCand,
      ),
    );
  }

  Widget _candTile(Candidato cand) {
    return Dismissible(
      key: Key(cand.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Borrar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            cand.name.substring(0, 2),
          ),
        ),
        title: Text(cand.name),
        trailing: Text(
          '${cand.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          print(cand.name);
        },
      ),
    );
  }

  addNewCand() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Agregar Candidatos'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Add'),
                onPressed: () => addCandToList(textController.text),
              ),
            ],
          );
        },
      );
    }

    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('Nuevo Candidato'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                child: Text('Add'),
                isDefaultAction: true,
                onPressed: () => addCandToList(textController.text),
              ),
              CupertinoDialogAction(
                child: Text('Dismiss'),
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  void addCandToList(String name) {
    print(name);
    if (name.length > 1) {
      this.cand.add(new Candidato(
            id: DateTime.now().toString(),
            name: name,
            votes: 0,
          ));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
