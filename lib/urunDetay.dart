import 'package:flutter/material.dart';

//Program tanimlama
class UrunDetay extends StatefulWidget {
  final String urunResim;
  final double urunFiyat;
  final String urunAd;
  final String urunAciklama;
  final String urunMensei;
  final String urunKaynak;

  const UrunDetay({
    Key? key,
    required this.urunResim,
    required this.urunFiyat,
    required this.urunAd,
    required this.urunAciklama,
    required this.urunMensei,
    required this.urunKaynak,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UrunDetaySayfa();
  }
}

//Ana Program
class UrunDetaySayfa extends State<UrunDetay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
        title: const Text(
          "Ürün Detay",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(3.0),
                    child: Image(
                      image: AssetImage(
                        widget.urunResim,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text("${widget.urunFiyat} TL"),
                  ),
                  Container(
                    margin: EdgeInsets.all(3.0),
                    child: Text("${widget.urunAd} / kg"),
                  ),
                ],
                //width: MediaQuery.of(context).size.width - 10,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              color: Colors.white,
              child: ExpansionTile(
                title: Text('Ürün Açıklaması'),
                children: <Widget>[
                  ListTile(
                    title: Text(widget.urunAciklama),
                  ),
                  ListTile(
                    title: Text(
                      "Menşei",
                    ),
                    subtitle: Text(widget.urunMensei),
                  ),
                  ListTile(
                    title: Text(
                      "Kaynak Ülke",
                    ),
                    subtitle: Text(widget.urunKaynak),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height / 13,
        color: Colors.amber,
        child: Text(
          "Alt Kısım",
        ),
      ),
    );
  }
}

//body: Text("Gönderdiğin rakam ${widget.urunId}"),
