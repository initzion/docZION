import 'package:fast_turtle_v2/screens/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast-Anadolu Project.ss',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: WelcomePage(),
    );
  }
}
