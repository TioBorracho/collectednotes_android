// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/login.dart';
import 'package:flutter_app/screens/loader.dart';
import 'package:flutter_app/screens/notes_page.dart';
import 'package:flutter_app/service/collectednotes/collected_notes_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'managers/dialog_manager.dart';
import 'service/dialogs/locator.dart';

GetIt locator = GetIt();

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => DialogManager(
            child: widget,
          ),
        ),
      ),
      title: 'Collected Notes',
      home: CollectedNotes(),
      theme: ThemeData(
        // Add the 3 lines from here...
        primaryColor: Colors.white,
      ),
    );
  }
}

class CollectedNotes extends StatefulWidget {
  @override
  _CollectedNotesState createState() => _CollectedNotesState();
}

/**
 * Possible initial states.
 */
enum CurrentState {
  WAITING,      // Still checking state.
  LOGIN,        // Invalid ir absent credentials.
  SELECT_SITE,  // No default site chosen.
  NOTES         // Notes list.
}

/**
 * Main page for the app. It will:
 * 1. Check if login credentials are valid.
 *  a. If missing or wrong, will display login screen (add support for offline)
 *  b. will display notes list otherwise.
 */
class _CollectedNotesState extends State<CollectedNotes> {
  CurrentState _state = CurrentState.WAITING;

  @override
  void initState() {
    super.initState();
    
    _setCurrentScreen();
  }

  _updateCurrentScreen() {
    Widget widget;
    switch (_state) {
      case CurrentState.WAITING:
        widget = ColorLoader(colors: [Colors.red, Colors.blue, Colors.yellow], duration: Duration(seconds: 5) );
        break;
      case CurrentState.LOGIN:
        widget = LoginPage();
        break;
      case CurrentState.SELECT_SITE:
      case CurrentState.NOTES:
        widget = NotesPage();
    }
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(
            builder: (BuildContext context) => Scaffold(
                appBar: AppBar(
                  title: Text('Prueba'),
                ),
                body: widget)));
  }

  _setCurrentScreen() async {
    // First check credentials.
    CredentialsValidationResult result = await CollectedNotesService.validateStoredCredentials();
    if (result != CredentialsValidationResult.SUCCESS) {
      _state = CurrentState.LOGIN;
    } else {
      // User's credentials are ok. Does it have a selected site? Does it have more than one?
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('PREFERRED_SITE')) {
        _state = CurrentState.SELECT_SITE;
      } else {
        _state = CurrentState.NOTES;
      }
    }
    _updateCurrentScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
         // IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          IconButton(icon: Icon(Icons.list), onPressed: _login),
        ],
      ),
      body: ColorLoader(colors: [Colors.red, Colors.blue], duration: Duration(seconds: 5),),
    );
  }


  Widget _login() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Login'),
            ),
            body: LoginPage(),
          );
        }, // ...to here.
      ),
    );
  }
}
