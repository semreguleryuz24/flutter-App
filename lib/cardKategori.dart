import 'package:flutter/material.dart';
import 'kategori/productsPage.dart';

class CardKat extends StatelessWidget {
  String imageUrl = "";
  String title = "";
  int categoryId = 0;
  int katLength = 0;
  int subKATid = 0;
  int subKATSay = 0;
  List<String> katAdlar = [];

  //Constructor
  CardKat(this.imageUrl, this.title, this.categoryId, this.katLength, this.katAdlar, this.subKATid, this.subKATSay);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigator.pushNamed(context, rota);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsPage(
                katAd: title,
                katId: categoryId,
                katL: katLength,
                katAds: katAdlar,
                subkatId: subKATid,
                subkatSAYI: subKATSay), //.. veri gönderiyoruz. Kategori Adını gönderiyoruz..
          ),
        );
      },
      child: Card(
        child: Container(
          width: (MediaQuery.of(context).size.width / 3.2),
          height: (MediaQuery.of(context).size.height / 4.3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image(
                image: AssetImage("assets/Kategori/$imageUrl"),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/$resim"),
              fit: BoxFit.fill,
            ),
          ),
          //alignment: Alignment.bottomCenter,
          child: Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.skewY(0.0),
            child: Container(
              //width: double.infinity,
              padding: const EdgeInsets.all(9.0),
              color: const Color(0xCDFFC1D3),
              child: Text(
                baslik,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        */