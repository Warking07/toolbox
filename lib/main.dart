import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/gender_page.dart';
import 'pages/age_page.dart';
import 'pages/universities_page.dart';
import 'pages/weather_page.dart';
import 'pages/pokemon_page.dart';
import 'pages/wordpress_page.dart';
import 'pages/about_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toolbox App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}
