import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String title;

  PopAppBar({this.title}) : preferredSize = Size.fromHeight(60.0);
  @override
  final Size preferredSize;
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigo,
      elevation: 0,
      title: Text(title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            //Navigator.of(context).pushNamed(Settings.page);
          },
        ),
      ],
      /*leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context, false),
      ),*/
      centerTitle: true,
    );
  }
}
