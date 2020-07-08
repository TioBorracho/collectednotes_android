import 'package:flutter/widgets.dart';
class AlertRequest {
  final String title;
  final String description;
  final List<Button> buttons;
  AlertRequest({
    @required this.title,
    @required this.description,
    @required this.buttons,
  });
}

class Button {
  final String title;
  final String value;

  Button(this.title, this.value);
}

