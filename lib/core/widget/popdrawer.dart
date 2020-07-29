import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:popart/core/helper/authenticate.dart';

import 'package:popart/ui/views/dashbaord/dashboard.dart';
import 'package:popart/ui/views/dashbaord/profile.dart';
import 'package:popart/ui/views/dashbaord/settings.dart';
import 'package:popart/ui/views/auth/signin.dart';

class PopDrawer extends StatefulWidget {
  @override
  _PopDrawerState createState() => _PopDrawerState();
}

class _PopDrawerState extends State<PopDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences prefs;
  bool loading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      loading = false;
    });
    prefs = await SharedPreferences.getInstance();

    if (isLoggedIn) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Dashboard(currentUserId: prefs.getString('userId'))));
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      FirebaseUser user = await _auth.currentUser();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8.0, 50.0, 8.0, 8.0),
            color: Colors.white,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.asset(
                    "assets/images/no_user.png",
                    width: 60.0,
                    height: 60.0,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "User Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',
                            color: Colors.grey[600])),
                    TextSpan(
                        text: "@username",
                        style: TextStyle(
                            fontFamily: 'Lato', color: Colors.grey[600]))
                  ]),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[300],
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  title: Text(
                    "Home",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  leading: Icon(Icons.home),
                  onTap: () async {
                    await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Dashboard(
                                currentUserId: prefs.getString('userId'))));
                  },
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    "Profile",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  leading: Icon(Icons.person),
                  onTap: () async {
                    await Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  },
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    "Settings",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  leading: Icon(Icons.settings),
                  onTap: () async {
                    await Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                ),
                ListTile(
                  dense: true,
                  title: Text(
                    "Logout",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  leading: Icon(Icons.exit_to_app),
                  onTap: () async {
                    signOut();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
