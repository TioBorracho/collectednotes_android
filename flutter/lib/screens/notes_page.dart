import 'package:flutter/material.dart';
import 'package:flutter_app/datamodel/collectednotes/note.dart';
import 'package:flutter_app/service/collectednotes/collected_notes_service.dart';

import 'loader.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _updateCurrentScreen();
  }

  _updateCurrentScreen() async {
    _notes = await CollectedNotesService.fetchNotes(1);

    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
            builder: (BuildContext context) => Scaffold(
                appBar: AppBar(
                  title: Text('Prueba'),
                ),
                body:  _buildNotes())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          // IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: ColorLoader(colors: [Colors.red, Colors.blue], duration: Duration(seconds: 5),),
    );
  }

  Widget _buildNotes() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();
          /*2*/

          final index = i ~/ 2; /*3*/
          return _buildRow(_notes[index].title);
        });
  }

  Widget _buildRow(String headline) {
    //final alreadySaved = _saved.contains(pair); // NEW
    return ListTile(
      title: Text(
        headline,
        //style: _biggerFont,
      ),
      trailing: Icon(
        // NEW from here...
        /*alreadySaved ? Icons.favorite : */Icons.favorite_border,
        //color: alreadySaved ? Colors.red : null,
      ), // ... to here.
      onTap: () {
        setState(() {
          /*  if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }*/
        });
      },
    );
  }
}
