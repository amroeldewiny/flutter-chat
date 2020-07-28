import 'package:flutter/material.dart';

class PopButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final String icon;

  const PopButton({Key key, this.callback, this.text, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      buttonColor: Colors.orangeAccent[400],
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: RaisedButton(
        onPressed: callback,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
