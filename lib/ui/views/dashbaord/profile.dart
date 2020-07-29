import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:popart/core/widget/popdrawer.dart';
import 'package:popart/core/widget/popappbar.dart';

class Profile extends StatefulWidget {
  static const String page = 'ProfilePage';
  final String currentUserId;

  Profile({Key key, @required this.currentUserId}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState(currentUserId: currentUserId);
}

class _ProfileState extends State<Profile> {
  _ProfileState({Key key, @required this.currentUserId});
  final String currentUserId;
  FirebaseUser currentUser;

  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: PopDrawer(),
      appBar: PopAppBar(
          title: 'Profile',
          callback: () {
            _drawerKey.currentState.openDrawer();
          }),
      body: Center(
        child: Text('Profile page'),
      ),
    );
  }
}
