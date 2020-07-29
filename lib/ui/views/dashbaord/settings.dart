import 'package:flutter/material.dart';
import 'package:popart/core/widget/popdrawer.dart';
import 'package:popart/core/widget/popappbar.dart';

class Settings extends StatefulWidget {
  static const String page = 'ProfilePage';
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: PopDrawer(),
      appBar: PopAppBar(
          title: 'Settings',
          callback: () {
            _drawerKey.currentState.openDrawer();
          }),
      body: Center(
        child: Text('Settings page'),
      ),
    );
  }
}
