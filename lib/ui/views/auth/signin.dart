import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:popart/core/widget/popbutton.dart';
import 'package:popart/core/widget/popinput.dart';
import 'package:popart/core/widget/poploading.dart';
import 'package:popart/ui/views/dashbaord/dashboard.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  static const String page = 'SignInPage';

  final Function toggleView;
  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool loading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  String email;
  String password;

  //final FirebaseAuth _auth = FirebaseAuth.instance;
  //SharedPreferences prefs;

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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences prefs;
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future loginUser(String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;

      if (user != null) {
        final QuerySnapshot result = await userCollection
            .where('userId', isEqualTo: user.uid)
            .getDocuments();
        currentUser = user;
        await prefs.setString('userId', currentUser.uid);
        await prefs.setString('name', currentUser.displayName);
      }

      this.setState(() {
        loading = false;
      });

      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    currentUserId: user.uid,
                  )));
      return user.uid;
    } catch (error) {
      loading = false;
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? PopLoading()
        : Scaffold(
            backgroundColor: Colors.indigo[600],
            appBar: AppBar(
              backgroundColor: Colors.indigo[600],
              elevation: 0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.lock_open),
                  onPressed: () {},
                ),
              ],
              //leading: Container(),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Pop Art',
                      style: TextStyle(
                          fontSize: 60.0,
                          fontFamily: 'GreatVibes',
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      style: PopFieldStyle(),
                      validator: (value) =>
                          value.isEmpty ? 'Enter an email' : null,
                      onChanged: (value) =>
                          setState(() => email = value.trim()),
                      decoration: PopInputDecoration(
                          "Enter your email....", Icons.email),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      style: PopFieldStyle(),
                      autocorrect: false,
                      obscureText: true,
                      validator: (value) => value.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      onChanged: (value) =>
                          setState(() => password = value.trim()),
                      decoration: PopInputDecoration(
                          "Enter your password....", Icons.vpn_key),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    PopButton(
                      text: 'Login',
                      callback: () async {
                        try {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            await loginUser(email, password);
                          } else {
                            loading = false;
                          }
                        } catch (e) {
                          loading = false;
                          print(e.message.toString());
                          //Scaffold.of(context).showSnackBar(bar);
                          //_key.currentState.showSnackBar(bar);
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account? ",
                          style: TextStyle(
                            color: Colors.indigo[200],
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: Text(
                            "Register now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
