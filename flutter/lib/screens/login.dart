import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/datamodel/collectednotes/credentials.dart';
import 'package:flutter_app/service/collectednotes/collected_notes_service.dart';
import 'package:flutter_app/service/dialogs/dialog_service.dart';
import 'package:flutter_app/service/dialogs/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datamodel/alert_request.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    keyController.dispose();
    super.dispose();
  }

  //Loading counter value on start
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = (prefs.getString('UserEmail') ?? '');
      keyController.text = (prefs.getString('UserKey') ?? '');
    });
  }

  //Incrementing counter after click
  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('UserEmail', emailController.text);
      prefs.setString('UserKey', keyController.text);
    });
  }


  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      obscureText: false,
      style: style,
      controller: emailController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final keyField = TextField(
      obscureText: true,
      style: style,
      controller: keyController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Key",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          validateAndSave(emailController.text, keyController.text);
        },
        child: Text("Save",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );


    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "assets/collected_notes_icon.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                keyField,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateAndSave(email, var key) async {
    CredentialsValidationResult result = await CollectedNotesService.validateCredentials(Credentials(email: email, key: key));
    _validateAndSave(result);
  }

  void _validateAndSave(CredentialsValidationResult result) {
    var title;
    var description;
    switch(result) {
      case CredentialsValidationResult.SUCCESS:
        title = 'Yay! you are in.';
        description = 'Your credentials match!';
        _saveData();
        break;
      case CredentialsValidationResult.WRONG_CREDENTIALS:
        title = 'Nay! you are out.';
        description = 'Check your email or your key';
        break;
      default:
        title = 'Meh!, something is wrong.';
        description = 'Probably conenctivity issues, try again later.';
    };
    DialogService _dialogService = locator<DialogService>();
    Future doThings() async {
      var dialogResult = await _dialogService.showDialog(title: title, description: description, buttons: [Button('Ok', 'OK'), Button('Exit', 'EXIT')]);
      if (/*result != CredentialsValidationResult.SUCCESS && */dialogResult.value == 'EXIT') {
        SystemNavigator.pop();
      } else {
        Navigator.pop(context, result == CredentialsValidationResult.SUCCESS);
      }
    }
    doThings();
  }
}