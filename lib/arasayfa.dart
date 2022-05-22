//import 'dart:developer';
///import 'dart:io';
//import 'dart:ui';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_makbul1/anasayfa.dart';
//import 'package:flutter/services.dart'; //httpClient
import 'package:flutter_makbul1/kategori/urun.dart';
//import 'package:sticky_headers/sticky_headers.dart'; //üstteki sabit yer -> kategoriler
import 'dart:convert'; //json decode
import 'package:flutter_makbul1/kategori/urun.dart';
import 'dart:async'; //future
import 'package:http/http.dart' as http; //response
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_makbul1/urunDetay.dart';
import 'package:badges/badges.dart'; // bottomnavigation daki badge küçük bildirimler için
//import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sqflite/sqflite.dart';
import 'package:flutter_makbul1/database/dbcontroller.dart';
import 'package:flutter_makbul1/database/dblocal.dart';

class AraSayfa extends StatefulWidget {
  /*
  int katId;
  int subkatId;
  int subkatSAYI;
  final int katL;
  String katAd;
  List<String> katAds;
  Ara(
      {Key? key,
      required this.katId,
      required this.katAd,
      required this.katL,
      required this.katAds,
      required this.subkatId,
      required this.subkatSAYI})
      : super(key: key);
  */
  @override
  State<AraSayfa> createState() => _AraSayfa();
}

//Ana program
class _AraSayfa extends State<AraSayfa> {
  //Degiskenler
  late Future<List<Urun>> urunFuture;
  List<String> kategoriss = [];
  List<int> kategorissId = [];
  List<double> kgDegerUrun = [];
  DbController dbController = DbController(); //Kullanacağımız veritabanı işle..
  List<DbCart> cartItemList = [];
  double toplamTutar = 0;
  String aramaMetni = "";
  //Arama kutusundan odaklanmayi kaldirmak icin
  FocusNode node = FocusNode();

  // shared -> sepetin üstündeki ikonu böyle yapalım ki shared görmüş olursunuz..
  int urunMiktar = 0; // shared de kullanalım
  final Future<SharedPreferences> _sharedP = SharedPreferences.getInstance();

  void kayitYap(sMiktar) async {
    final SharedPreferences sharedP = await _sharedP;
    sharedP.setInt('sepet', sMiktar);
  }

  void kayitGoster() async {
    final SharedPreferences sharedP = await _sharedP;
    final int? sepetMiktar = sharedP.getInt('sepet');
    if (sepetMiktar != null) {
      urunMiktar = sepetMiktar;
    }
  }

//veritananındakileri listele
  cartList() {
    //cartItems = [];
    dbController.cartGet().then((item) {
      setState(() {
        cartItemList = item;
      });
    });
    for (int i = 0; i < cartItemList.length; i++) {
      toplamTutar += (double.parse(cartItemList[i].prodPrice) *
          double.parse(cartItemList[i].prodQuantity));
    }
    debugPrint(cartItemList.toString());
    debugPrint("TOPLAM TUTAR: ${toplamTutar.toString()}");
  }

  //cart icin veritabanindan silme
  cartRemove(String cartDel) {
    dbController.cartDelete(cartDel).then((rspns) {
      //işlem başarılı ise
      if (rspns > 0) {
        cartList();
        Fluttertoast.showToast(
          msg: "$cartDel, sepetten çıkarıldı!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          //backgroundColor: Color.fromRGBO(38, 161, 124, 1.0),
          backgroundColor: Colors.yellow[700],
          textColor: Colors.black,
          fontSize: 16.0,
        );
      }
    });
  }

  //cart icin veritabanindan güncelleme
  cartUpdate(
      int cartId, int prdId, String prdName, String prdQntty, String prdPrice) {
    var cartItem = DbCart(prdId, prdName, prdQntty, prdPrice);
    cartItem.id = cartId;
    dbController.cartUpdate(cartItem).then((rspns) {
      if (rspns) {
        cartList();
        //Navigator.pop(context);
        /*
        Fluttertoast.showToast(
          msg: "$prdName, Miktar: $prdQntty olarak güncellendi!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.yellow[700],
          textColor: Colors.black,
          fontSize: 16.0,
        );
        */
      }
    });
  }

  //cart icin veritabanina ekleme
  cartAdd(int pId, String pName, String pQuantity, String pPrice) {
    dbController.cartSave(DbCart(pId, pName, pQuantity, pPrice)).then((val) {
      //debugPrint("donen deger: ${val.toString()}");
      if (val > 0) {
        //cartItems.add(pName);
        cartList();
        /*
        Fluttertoast.showToast(
          msg: "$pName, sepete eklendi!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.yellow[700],
          textColor: Colors.black,
          fontSize: 16.0,
        );
        */
      }
    });
  }

  //Urunleri Çek Firebase -> urun.json
  Future<List<Urun>> urunListele() async {
    List<Urun> uruns = [];

    Uri url1 = Uri.parse(
        'https://makbulfirebase-default-rtdb.firebaseio.com/urun.json');
    http.Response cevap1 = await http.get(url1);

    //statuscode = 200 -> başarılı
    if (cevap1.statusCode == 200) {
      List cevapListesi1 = json.decode(cevap1.body);

      for (var eleman in cevapListesi1) {
        Urun urun = Urun.fromJson(eleman);
        uruns.add(urun);
        //tüm ürünlerin mevcut kg değeri ekle
        kgDegerUrun.add(0.0);
      }
    } else {
      debugPrint("Error: ${cevap1.statusCode}");
      throw Exception(
          "Veriler getirilirken hata oluştu. \n Hata kodu: ${cevap1.statusCode}");
    }

    uruns.sort((a, b) => a.subKatID.compareTo(b.subKatID));

    for (int i = 0; i < kgDegerUrun.length; i++) {
      for (int j = 0; j < cartItemList.length; j++) {
        if (cartItemList[j].prodId == uruns[i].urunId) {
          kgDegerUrun[i] = double.parse(cartItemList[j].prodQuantity);
        }
      }
    }

    return (uruns);
  }

  //initstate uygulama ilk açılırken
  @override
  void initState() {
    super.initState();
    kayitGoster();
    urunFuture =
        urunListele(); //tanımlıyoruz. artık değişkeni çağıracağız. diğer türlü sürekli json çağırıp server yük biner.
    cartList();
  }

  @override
  void dispose() {
    super.dispose();
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
              child: Text('TAMAM'),
            ),
          ],
        );
      }, //builder
    );
  }

  //Program
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context, true);
            setState(() {});
          },
        ),
        title: TextField(
          focusNode: node,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.blueGrey[100],
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          onChanged: (veri) => setState(() => aramaMetni = veri),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          builder: (_buildcontext, AsyncSnapshot<List<Urun>> asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              List<Urun>? urunss = asyncSnapshot.data;

              for (int i = 0; i < urunss!.length; i++) {
                if (!kategoriss.contains(urunss[i].kategori)) {
                  kategoriss.add(urunss[i].kategori);
                }
              }

              for (int i = 0; i < urunss.length; i++) {
                if (!kategorissId.contains(urunss[i].katId)) {
                  kategorissId.add(urunss[i].katId);
                }
              }

              //urunss = urunss.where((x) => x.subKatID == widget.subkatId).toList();

              //urunss = urunss.where((x) => x.katId == widget.katId).toList();
              /*
              urunss = urunss
                  .where((x) =>
                      x.urunAd.toLowerCase().contains(aramaMetni.toLowerCase()))
                  .toList();
                  */
              for (int i = 0; i < urunss.length; i++) {
                kgDegerUrun.add(0);
              }

              if (aramaMetni.length > 1 && urunss != null) {
                //Küçük büyük harf duyarlılığı kalksın diye toLowerCase kullanıyoruz.
                urunss = urunss
                    .where((x) => x.urunAd
                        .toLowerCase()
                        .contains(aramaMetni.toLowerCase()))
                    .toList();
              }
              /*
              for (int i = 0; i < kgDegerUrun.length; i++) {
                for (int j = 0; j < cartItemList.length; j++) {
                  if (cartItemList[j].prodId == urunss[i].urunId) {
                    kgDegerUrun[i] = double.parse(cartItemList[j].prodQuantity);
                  }
                }
              }
                */
              if (urunss == null) {
                return Column();
              }

              return CustomScrollView(
                slivers: <Widget>[
                  SliverGrid.count(
                    childAspectRatio: 0.55,
                    crossAxisCount: 3,
                    children: <Widget>[
                      for (int sira = 0; sira < urunss.length; sira++)
                        Card(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                //1.satır -,kg,+ butonlar
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      //azalt - button
                                      SizedBox(
                                        width: ((MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3) -
                                                10) /
                                            4,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                          ),
                                          child: const Text(
                                            "-",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          onPressed: () {
                                            //Sepetteki kaç çeşit ürün olduğunu gösteren sayıyı azalt.
                                            //ürün kg değerini DEFAULT_CART_WEIGHT kadar azalt.
                                            if (kgDegerUrun[sira] >=
                                                double.parse(urunss![sira]
                                                    .defCartWeight)) {
                                              setState(() {
                                                kgDegerUrun[sira] =
                                                    kgDegerUrun[sira] -
                                                        double.parse(
                                                            urunss![sira]
                                                                .defCartWeight);
                                              });

                                              //sepetigüncelle
                                              if (kgDegerUrun[sira] > 0) {
                                                cartUpdate(
                                                    urunss[sira].urunId,
                                                    urunss[sira].urunId,
                                                    urunss[sira].urunAd,
                                                    kgDegerUrun[sira]
                                                        .toString(),
                                                    urunss[sira].urunFiyat);
                                              }

                                              //sepetten kaldır 0 a kadar düşerse
                                              if (kgDegerUrun[sira] == 0) {
                                                setState(() {
                                                  urunMiktar = urunMiktar - 1;
                                                });

                                                cartRemove(urunss[sira].urunAd);
                                                kayitYap(urunMiktar);
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      //Text Değişken / lokal değişken, kgdegerUrunKat de saklanıyor.
                                      if (kgDegerUrun[sira] == 0)
                                        Text(
                                          "${kgDegerUrun[sira]} kg",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      else
                                        Text(
                                          "${kgDegerUrun[sira]} kg",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      //+
                                      SizedBox(
                                        width: ((MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3) -
                                                10) /
                                            4,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                          ),
                                          child: const Text(
                                            "+",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          //ürün MAKSIMUM_CART_WEIGHT e ulaşmadığı sürece kg ını artır.
                                          onPressed: () {
                                            if (kgDegerUrun[sira] <
                                                double.parse(urunss![sira]
                                                    .maksCartWeight)) {
                                              setState(() {
                                                kgDegerUrun[sira] =
                                                    kgDegerUrun[sira] +
                                                        double.parse(
                                                            urunss![sira]
                                                                .defCartWeight);
                                                //varsayılan kg deger 0 dan yüksekse sepeti güncelle
                                                if (kgDegerUrun[sira] > 0) {
                                                  cartUpdate(
                                                      urunss[sira].urunId,
                                                      urunss[sira].urunId,
                                                      urunss[sira].urunAd,
                                                      kgDegerUrun[sira]
                                                          .toString(),
                                                      urunss[sira].urunFiyat);
                                                }
                                              });
                                            } else {
                                              //ürün MAKSIMUM_CART_WEIGHT i geçerse uyarı mesajı ver.
                                              Fluttertoast.showToast(
                                                msg:
                                                    "Maksimum ürün ekleme ağırlığına ulaştınız",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.CENTER,
                                                backgroundColor:
                                                    Colors.green.shade900,
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            }
                                            //Sepetteki kaç çeşit ürün olduğunu gösteren sayıyı artır.
                                            if (kgDegerUrun[sira] ==
                                                double.parse(urunss[sira]
                                                    .defCartWeight)) {
                                              //ürün başlangıç 0 ise -> sepete ekle
                                              cartAdd(
                                                  urunss[sira].urunId,
                                                  urunss[sira].urunAd,
                                                  kgDegerUrun[sira].toString(),
                                                  urunss[sira].urunFiyat);
                                              setState(() {
                                                urunMiktar = urunMiktar + 1;
                                              });
                                              kayitYap(urunMiktar);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //2.satır Ürün Resim
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UrunDetay(
                                            //UrunDetay sayfasına veri gönderiyoruz.
                                            urunResim:
                                                "assets/img/${urunss![sira].urunResim}",
                                            urunFiyat: double.parse(
                                                urunss[sira].urunFiyat),
                                            urunAd: urunss[sira].urunAd,
                                            urunAciklama:
                                                urunss[sira].urunAciklama,
                                            urunMensei: urunss[sira].mensei,
                                            urunKaynak: urunss[sira].kaynak),
                                      ),
                                    );
                                  },
                                  child: Image(
                                    image: AssetImage(
                                        "assets/img/${urunss[sira].urunResim}"),
                                    //width: (MediaQuery.of(context).size.width / 3) - 10,
                                  ),
                                ),
                                //3. satır Ürün İsim + Fiyat
                                Text(
                                  '${urunss[sira].urunAd} / kg',
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '${urunss[sira].urunFiyat} TL',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            } else {
              debugPrint("Ürünler getirelemedi;Sebep: + ${asyncSnapshot.data}");
              return Center(
                //heightFactor: MediaQuery.of(context).size.height / 3,
                heightFactor: 11.0,
                //Bekleme işareti spinner
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              );
            }
          },
          future:
              urunFuture, //her seferinde json ı serverdan çağırıp yük bindirmesin diye.
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        currentIndex: 0,
        //backgroundColor: Color.fromRGBO(81, 129, 162, 1.0),
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.blueGrey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home_max_rounded,
            ),
            label: 'Anasayfa',
            tooltip: "Anasayfa",
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.search_rounded,
            ),
            label: 'Ara',
            tooltip: "Ara",
          ),
          BottomNavigationBarItem(
            icon: Badge(
              shape: BadgeShape.circle,
              position: BadgePosition.topEnd(),
              borderRadius: BorderRadius.circular(100),
              child: Icon(
                Icons.add_shopping_cart_rounded,
              ),
              badgeContent: Text(
                urunMiktar.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            label: 'Sepetim',
            tooltip: "Sepetim",
          ),
          const BottomNavigationBarItem(
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
              Navigator.pushNamed(context, "/");
              debugPrint("Anasayfa");
              break;
            case 1:
              //Navigator.pushNamed(context, "/arasayfa");
              debugPrint("Arasayfa");
              break;
            case 2:
              //Navigator.pushNamed(context, "/sepetim");
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
