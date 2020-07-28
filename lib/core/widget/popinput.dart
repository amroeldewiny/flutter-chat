import 'package:flutter/material.dart';

// Input Style decoration widget
// ignore: non_constant_identifier_names
InputDecoration PopInputDecoration(String hintText, icon) {
  return InputDecoration(
    hintText: hintText,
    prefixIcon: Icon(
      icon,
      color: Colors.indigo[200],
    ),
    hintStyle: TextStyle(color: Colors.indigo[200]),
    filled: true,
    fillColor: Colors.indigo[500],
    border: const OutlineInputBorder(),
    enabledBorder: new UnderlineInputBorder(
      borderSide: new BorderSide(color: Colors.indigo[600]),
      //borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.indigo[700]),
      //borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent[100])),
    errorStyle: TextStyle(color: Colors.redAccent[100]),
  );
}

// TextInput Style decoration widget
// ignore: non_constant_identifier_names
TextStyle PopFieldStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 14.0,
  );
}
