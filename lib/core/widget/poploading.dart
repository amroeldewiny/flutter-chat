import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PopLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[600],
      child: Center(
          child: SpinKitChasingDots(
        color: Colors.indigo[200],
        size: 50.0,
      )),
    );
  }
}
