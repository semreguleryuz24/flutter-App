import 'package:flutter/material.dart';
import 'package:flutter_makbul1/arasayfa.dart';
import 'package:flutter_makbul1/sepet.dart';
import 'anasayfa.dart';
import 'package:flutter_makbul1/kategori/urunsayfa.dart';
/*
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

class IlkSayfa extends StatefulWidget {
  @override
  _IlkSayfaState createState() => _IlkSayfaState();
}

class _IlkSayfaState extends State<IlkSayfa> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        "/": (context) => Anasayfa(),
        "./kategori/urunsayfa": (context) => UrunSayfa(
              katId: 0,
              katAd: '',
              katL: 0,
              katAds: [],
              subkatId: 0,
              subkatSAYI: 0,
            ),
        "/arasayfa": (context) => AraSayfa(),
        //"/sepet": (context) => Sepet(cartItemList: [],)
      },
    );
  }
}
