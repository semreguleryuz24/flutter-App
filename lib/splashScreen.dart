import 'package:flutter/material.dart';
import 'anasayfa.dart';
import 'package:flutter_makbul1/kategori/productsPage.dart';
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

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        "/": (context) => Anasayfa(),
        "./kategori/urunsayfa": (context) => ProductsPage(
              katId: 0,
              katAd: '',
              katL: 0,
              katAds: [],
              subkatId: 0,
              subkatSAYI: 0,
            ),
      },
    );
  }
}
