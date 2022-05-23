//yorum 23.05.2022 github
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; //slider banner için
import 'package:flutter_makbul1/cardKategori.dart'; //card düzeni tek sayfadan düzenlenebilsin
import 'dart:convert'; //json decode
import 'dart:async'; //future
import 'package:http/http.dart' as http; //get-response
import 'package:fluttertoast/fluttertoast.dart'; //uyarı,bildirimler için
import 'package:badges/badges.dart'; // bottomnavigation daki badge küçük bildirimler için
import 'kategori/kategori.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_makbul1/database/dbcontroller.dart';
import 'package:flutter_makbul1/database/dblocal.dart';

class Anasayfa extends StatefulWidget {
  //const Anasayfa({Key? key}) : super(key: key);
  @override
  State<Anasayfa> createState() => _Anasayfa();
}

List<String> katAdlar = [];

class _Anasayfa extends State<Anasayfa> {
  //Degiskenler
  late Future<List<Kategori>> kategoriFuture;
  DbController dbController = DbController(); //Kullanacağımız veritabanı işle..
  //List<String> cartItems = [];
  List<DbCart> cartItemList = [];
  //int urunMiktar = 0;
  double toplamTutar = 0;
  //final Future<SharedPreferences> _sharedP = SharedPreferences.getInstance();

/*
  void kayitGoster() async {
    final SharedPreferences sharedP = await _sharedP;
    final int? sepetMiktar = sharedP.getInt('sepet');

    if (sepetMiktar != null) {
      urunMiktar = sepetMiktar;
    }
  }
*/
  //veritananındakileri listele
  cartList() {
    //cartItems = [];
    dbController.cartGet().then((item) {
      setState(() {
        cartItemList = item;
        /*
        for (int i = 0; i < item.length; i++) {
          cartItems.add(item[i].prodName);
        }
        */
      });
    });

    for (int i = 0; i < cartItemList.length; i++) {
      toplamTutar += (double.parse(cartItemList[i].prodPrice) *
          double.parse(cartItemList[i].prodQuantity));
    }
  }

  //Kategorileri Çek Firebase -> kategori.json
  Future<List<Kategori>> kategoriListele() async {
    List<Kategori> kategoris = [];

    //Önce internet bağlantısı kontrol edilebilir..
    Uri url = Uri.parse(
        'https://makbulfirebase-default-rtdb.firebaseio.com/kategori.json');

    http.Response cevap = await http.get(url);

    //statuscode = 200 -> başarılı
    if (cevap.statusCode == 200) {
      //debugPrint("Liste Okuma Başarılı");
      List cevapListesi = json.decode(cevap.body);
      //debugPrint("$cevapListesi");

      for (var eleman in cevapListesi) {
        Kategori kategori = Kategori.fromJson(eleman);
        kategoris.add(kategori);
        katAdlar.add(kategori.kategori);
      }
    } else {
      debugPrint("Error: ${cevap.statusCode}");
      throw Exception(
          "Veriler getirilirken hata oluştu. \n Hata kodu: ${cevap.statusCode}");
    }
    //debugPrint("${uruns[0].urunId} / ${uruns[0].urunAd}");

    return (kategoris);
  }

//initstate uygulama ilk açılırken
  @override
  void initState() {
    super.initState();
    //kayitGoster();
    kategoriFuture = kategoriListele();
    cartList();
  }

  void sepetEkraniAc() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            padding: EdgeInsets.all(9.0),
            color: Colors.red,
            child: Text(
              "Sepettekilerim",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          content: StatefulBuilder(
            builder: (context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    for (int i = 0; i < cartItemList.length; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "${cartItemList[i].prodName}",
                            style: TextStyle(
                              //color: Color.fromRGBO(103, 148, 105, 1.0),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${cartItemList[i].prodQuantity} kg",
                          ),
                          Text(
                            "${cartItemList[i].prodPrice} TL",
                          ),
                          Text(
                            "${double.parse(cartItemList[i].prodPrice) * double.parse(cartItemList[i].prodQuantity)} TL",
                          )
                          /*
                          Expanded(
                            child: Container(),
                          ),
                          */
                        ],
                      ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "TOPLAM TUTAR: $toplamTutar",
                          style: TextStyle(
                            //color: Color.fromRGBO(103, 148, 105, 1.0),
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () {
                //Devam işlemler -> checkout
                Navigator.pop(context);
              },
              child: Text('AlışVerişe Devam'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              onPressed: () {
                //Devam işlemler -> checkout
                Navigator.pop(context);
              },
              child: Text('ÖDEME'),
            ),
          ],
        );
      }, //builder
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Makbülü Makbül",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                height: 174,
                autoPlay: true,
                viewportFraction: 1,
                initialPage: 0,
                //aspectRatio: 10 / 4,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items: [
                Image.asset("assets/slide1.jpg"),
                Image.asset("assets/slide2.jpg"),
                Image.asset("assets/slide3.jpg"),
              ],
            ),
            FutureBuilder(
              builder:
                  (_buildcontext, AsyncSnapshot<List<Kategori>> asyncSnapshot) {
                if (asyncSnapshot.hasData) {
                  List<Kategori>? kategoriss = asyncSnapshot.data;
                  if (kategoriss == null) {
                    return Column();
                  }
                  return Column(
                    children: <Widget>[
                      //her satırda 3 kategori
                      for (int satir = 0;
                          satir < (kategoriss.length / 3).ceil();
                          satir++)
                        Row(
                          children: <Widget>[
                            for (int sira = 0; sira < 3; sira++)
                              if ((satir * 3) + sira < kategoriss.length)
                                CardKat(
                                    kategoriss[(satir * 3) + sira].katresim,
                                    kategoriss[(satir * 3) + sira].kategori,
                                    kategoriss[(satir * 3) + sira].katId,
                                    kategoriss.length,
                                    katAdlar,
                                    kategoriss[(satir * 3) + sira].subKatg,
                                    kategoriss[(satir * 3) + sira]
                                        .subKatSayisi),
                          ],
                        ),
                    ],
                  );
                } else {
                  debugPrint(
                      "Kategoriler getirelemedi;Sebep: + ${asyncSnapshot.data}");
                  return Center(
                    heightFactor: 11.0,
                    //Bekleme işareti spinner
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                }
              },
              future: kategoriFuture,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        currentIndex: 0,
        //backgroundColor: Color.fromRGBO(81, 129, 162, 1.0),
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.blueGrey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_max_rounded,
            ),
            label: 'Anasayfa',
            tooltip: "Anasayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search_rounded,
            ),
            label: 'Ara',
            tooltip: "Ara",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart_rounded,
            ),
            label: 'Sepetim',
            tooltip: "Sepetim",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_box_rounded,
            ),
            label: 'Hesabım',
            tooltip: "Hesabım",
          ),
        ],
        onTap: (int i) {
          switch (i) {
            case 0:
              debugPrint("Anasayfa");
              break;
            case 1:
              Navigator.pushNamed(context, "/arasayfa");
              debugPrint("Arasayfa");
              break;
            case 2:
              sepetEkraniAc();
              debugPrint("Sepetim");
              break;
            case 3:
              //Navigator.pushNamed(context, "/hesap");
              debugPrint("Hesabım");
              break;
            default:
              debugPrint("Yok");
              break;
          }
        },
      ),
    );
  }
}
