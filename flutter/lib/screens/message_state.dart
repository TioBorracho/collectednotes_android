import 'package:flutter/widgets.dart';

class MessageState<T extends StatefulWidget> extends State<T> {
  String _message;

  /// Setter for the message variable
  set setMessage(String message) => setState(() {
    _message = message;
  });

  /// Getter for the message variable
  String get getMessage => _message;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}