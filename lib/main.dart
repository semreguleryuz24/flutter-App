/*
import 'package:flutter/material.dart';
import 'anasayfa.dart';
import 'package:flutter_makbul1/kategori/urunsayfa.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        "/": (context) => Anasayfa(),
        "./kategori/urunsayfa": (context) => UrunSayfa(
              katId: 0,
              katAd: '',
              katL: 0,
              katAds: [],
            ),
      },
    ),
  );
}
*/

import 'package:flutter/material.dart';
import 'ilksayfa.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => IlkSayfa()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/splash.png"), fit: BoxFit.cover)),
      ),
    );
  }
}
