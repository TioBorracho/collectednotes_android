import 'package:flutter/material.dart';
import 'package:flutter_app/datamodel/alert_request.dart';
import 'package:flutter_app/datamodel/alert_response.dart';
import 'package:flutter_app/service/dialogs/dialog_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../service/dialogs/locator.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();
  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
  void _showDialog(AlertRequest request) {
    Alert(
        context: context,
        title: request.title,
        desc: request.description,
        closeFunction: () => _dialogService.dialogComplete(AlertResponse(confirmed: false)),
        buttons: <DialogButton> [
          for (var button in request.buttons)
            DialogButton(
              child: Text(button.title),
              onPressed: () {
                _dialogService.dialogComplete(AlertResponse(confirmed: true, value: button.value));
                Navigator.of(context).pop();
              },
            )
        ]).show();
  }
}