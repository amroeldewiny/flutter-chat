import 'package:flutter/material.dart';
import 'package:popart/core/helper/authenticate.dart';
import 'package:popart/ui/views/dashbaord/dashboard.dart';

import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(PopApp());

class PopApp extends StatefulWidget {
  @override
  _PopAppState createState() => _PopAppState();
}

class _PopAppState extends State<PopApp> {
  bool userIsLoggedIn = false;
  FirebaseUser currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PopUp Art',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Lato'),
      home: userIsLoggedIn != null
          ? userIsLoggedIn
              ? Dashboard(
                  currentUserId: currentUser.uid,
                )
              : Authenticate()
          : Container(
              child: Center(
                child: Authenticate(),
              ),
            ),
    );
  }
}
