// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(DartScoreboard());

class DartScoreboard extends StatelessWidget {
  const DartScoreboard({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Dart Scoreboard',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

_write(String text) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/player_names.txt');
  await file.writeAsString(text, mode: FileMode.append);
}

Future<String> _read() async {
  late String text;
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/player_names.txt');
    text = await file.readAsString();
  } catch (e) {
    print("Couldn't read file");
  }
  return text;
}

class Players extends StatefulWidget {
  const Players({Key? key}) : super(key: key);

  @override
  _PlayersState createState() => _PlayersState();
}

class _PlayersState extends State<Players> {
  List<String> players = [];

  _PlayersState() {
    _read().then((val) => setState(() {
          players = val.split(",");
          // print(players);
        }));
  }

  List<Widget> getPlayersWidget() {
    List<Widget> list = [];
    for (var i = 0; i < players.length; i++) {
      String player = players[i];
      if (player.isNotEmpty) {
        list.add(
          Card(
            margin: EdgeInsets.all(4.0),
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                player,
                style: TextStyle(fontSize: 16, letterSpacing: 1),
              ),
            ),
          ),
        );
      }
    }
    return list;
  }

  _navigateToAddPlayer(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPlayer()),
    );

    if (result == true) {
      _read().then(
        (val) => setState(() {
          players = val.split(",");
          print(players);
        }),
      );
    } else {
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Players'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddPlayer(context);
        },
        tooltip: 'Add Player',
        child: Icon(Icons.add),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: getPlayersWidget(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class AddPlayer extends StatelessWidget {
  final name = TextEditingController();

  AddPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
        title: Text("New Player"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _write(name.text + ",");
          Navigator.pop(context, true);
        },
        icon: Icon(Icons.save),
        label: Text("Save"),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                labelText: 'Name *',
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget players = InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Players()),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Players',
            style: TextStyle(fontSize: 32, color: Colors.white),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Dart Board'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(20.0),
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        children: <Widget>[
          InkWell(
            onTap: () {
              print("tapped");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectNoOfPlayers(gameType: '501')),
              );
            },
            child: Card(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'Play',
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      '501',
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              print("tapped");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectNoOfPlayers(gameType: '301')),
              );
            },
            child: Card(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'Play',
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      '301',
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.blue,
            child: players,
          )
        ],
      ),
    );
  }
}

class SelectNoOfPlayers extends StatefulWidget {
  final gameType;
  const SelectNoOfPlayers({Key? key, @required this.gameType}) : super(key: key);

  @override
  _SelectNoOfPlayersState createState() => _SelectNoOfPlayersState();
}

class _SelectNoOfPlayersState extends State<SelectNoOfPlayers> {
  var game;
  int noOfPlayers = 0;
  bool selected = false;
  List<String> players = [];
  @override
  void initState() {
    game = widget.gameType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget playersCheckBox() {
      if (selected) {
        print(players);
        return ListView.builder(
          shrinkWrap: true,
          itemCount: players.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    CheckboxListTile(
                      value: false,
                      title: Text(players[index]),
                      onChanged: (bool? val) {
                        print(index);
                      },
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
      print(selected);
      return Text('Select No of Players');
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('No of Players $game'),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _read().then((val) => setState(() {
                            players = val.split(",");
                            noOfPlayers = 2;
                            selected = true;
                          }));
                    },
                    child: Card(
                      elevation: 2,
                      color: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '2',
                              style: TextStyle(fontSize: 36, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        noOfPlayers = 3;
                        selected = true;
                      });
                    },
                    child: Card(
                      elevation: 2,
                      color: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '3',
                              style: TextStyle(fontSize: 36, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        noOfPlayers = 4;
                        selected = true;
                      });
                    },
                    child: Card(
                      elevation: 2,
                      color: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '4',
                              style: TextStyle(fontSize: 36, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: SizedBox(
        height: 400,
        child: playersCheckBox(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed");
        },
      ),
    );
  }
}
