import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:popart/core/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:popart/core/widget/popbutton.dart';
import 'package:popart/core/widget/popinput.dart';
import 'package:popart/core/widget/poploading.dart';
import 'package:popart/ui/views/dashbaord/dashboard.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  static const String page = 'RegisterPage';

  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  String email;
  String name;
  String password;
  String conPass;

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

  SharedPreferences prefs;
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

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
                      validator: (value) =>
                          value.isEmpty ? 'Enter your name' : null,
                      onChanged: (value) => setState(() => name = value.trim()),
                      decoration: PopInputDecoration(
                          "Enter your name....", Icons.person),
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
                    TextFormField(
                      style: PopFieldStyle(),
                      autocorrect: false,
                      obscureText: true,
                      onChanged: (value) => setState(() => conPass = value),
                      decoration: PopInputDecoration(
                          "Confirm your password....", Icons.vpn_key),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    PopButton(
                      text: 'Register',
                      callback: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          if (password == conPass) {
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                          } else {
                            loading = false;
                            print('Your password did\'t match');
                          } // End if else confirm password
                        } // End form validate
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
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
                            "SignIn now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
