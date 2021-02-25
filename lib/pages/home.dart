import 'dart:io';

import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:vota_ec/providers/socket.dart';
import 'package:vota_ec/models/candidato.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Candidato> cands = [
    // Candidato(id: '1', name: 'Andrés Lelo Arauz', votes: 32),
    // Candidato(id: '2', name: 'Lucio Pistolita Gutierrez', votes: 6),
    // Candidato(id: '3', name: 'Xavier TikToker Hervas', votes: 16),
    // Candidato(id: '4', name: 'Pedro Mushpa Freire', votes: 7),
    // Candidato(id: '5', name: 'Yaku Liaste Perez', votes: 19),
    // Candidato(id: '6', name: 'Guillermo BanqueroQ Lasso', votes: 19),
    // Candidato(id: '7', name: 'JuanFer KanyeWest Velasco', votes: 1),
  ];

  @override
  void initState() {
    final socketService = Provider.of<Socket>(context, listen: false);
    socketService.socket.on('active-cands', (payload) {
      this.cands =
          (payload as List).map((cand) => Candidato.fromMap(cand)).toList();
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<Socket>(context);
    //print(cands.length);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elecciones',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  )
                : Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            width: double.infinity,
            height: 200,
            child: _showGraph(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cands.length,
              itemBuilder: (context, int i) => _candTile(cands[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addNewCand,
      ),
    );
  }

  Widget _candTile(Candidato cand) {
    final socketService = Provider.of<Socket>(context, listen: false);

    return Dismissible(
      key: Key(cand.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          socketService.socket.emit('delete-cand', {'id': cand.id}),
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
          socketService.socket.emit('vote-cand', {'id': cand.id});
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
    final socketService = Provider.of<Socket>(context, listen: false);
    if (name.length > 1) {
      // emitir:

      socketService.socket.emit('add-cand', {'name': name});

      /*
      // CODIGO INICIAL SIN SOCKETS
      this.cands.add(new Candidato(
            id: DateTime.now().toString(),
            name: name,
            votes: 0,
          ));
      setState(() {}); */
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    cands.forEach((cand) {
      dataMap.putIfAbsent(cand.name, () => cand.votes.toDouble());
    });
    return PieChart(
      dataMap: dataMap,
      chartType: ChartType.ring,
    );
  }
}
