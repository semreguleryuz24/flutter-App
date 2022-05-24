//ProductsPage.dart - 19.05.2022 - 10:06

//import 'dart:developer';
///import 'dart:io';
//import 'dart:ui';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_makbul1/anasayfa.dart';
//import 'package:flutter/services.dart'; //httpClient
import 'package:flutter_makbul1/kategori/urun.dart';
import 'package:flutter_makbul1/kategori/urunDetay.dart';
//import 'package:sticky_headers/sticky_headers.dart'; //üstteki sabit yer -> kategoriler
import 'dart:convert'; //json decode
import 'urun.dart';
import 'dart:async'; //future
import 'package:http/http.dart' as http; //response
import 'package:fluttertoast/fluttertoast.dart';

import 'package:badges/badges.dart'; // bottomnavigation daki badge küçük bildirimler için
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class ProductsPage extends StatefulWidget {
  int katId;
  int subkatId;
  int subkatSAYI;
  final int katL;
  String katAd;
  List<String> katAds;
  ProductsPage(
      {Key? key,
      required this.katId,
      required this.katAd,
      required this.katL,
      required this.katAds,
      required this.subkatId,
      required this.subkatSAYI})
      : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPage();
}

//Ana program
class _ProductsPage extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  //Degiskenler
  late Future<List<Urun>> urunFuture;
  late TabController _controller;

  int productAmount = 0;

  List<String> categories = [];
  List<int> categoryIds = [];
  List<double> maxCartWeight = [];

  /**
  *  Holds subcategory names as a String List.
  */
  List<String> subCategoryNames = [];

  List<int> subCategoryIds = [];

  List<bool> secSub = [];

  //Urunleri Çek Firebase -> urun.json
  Future<List<Urun>> urunListele() async {
    List<Urun> uruns = [];

    Uri url1 = Uri.parse(
        'https://makbulfirebase-default-rtdb.firebaseio.com/urun.json');
    http.Response cevap1 = await http.get(url1);

    //statuscode = 200 -> başarılı
    if (cevap1.statusCode == 200) {
      //debugPrint("Liste Okuma Başarılı");
      List cevapListesi1 = json.decode(cevap1.body);
      //debugPrint("$cevapListesi1");

      for (var eleman in cevapListesi1) {
        Urun urun = Urun.fromJson(eleman);
        uruns.add(urun);
        //kgDegerUrun.add(urun.defCartWeight);
        maxCartWeight.add(0.0);

        if (!subCategoryNames.contains(urun.subKatAd) &&
            urun.katId == widget.katId) {
          subCategoryNames.add(urun.subKatAd);
        }

        if (!subCategoryIds.contains(urun.subKatID) &&
            urun.katId == widget.katId) {
          subCategoryIds.add(urun.subKatID);
        }
      }
    } else {
      debugPrint("Error: ${cevap1.statusCode}");
      throw Exception(
          "Veriler getirilirken hata oluştu. \n Hata kodu: ${cevap1.statusCode}");
    }
    //debugPrint("1-subkatIdLER : $subKatIDs");
    //debugPrint("1-subkatId : ${widget.subkatId}");
    uruns.sort((a, b) => a.subKatID.compareTo(b.subKatID));
    return (uruns);
  }

  //initstate uygulama ilk açılırken
  @override
  void initState() {
    super.initState();
    urunFuture =
        urunListele(); //tanımlıyoruz. artık değişkeni çağıracağız. diğer türlü sürekli json çağırıp server yük biner.

    _controller = TabController(length: widget.katL, vsync: this);
    // gelen katid(kategori id) ler 1 den başladığı için 1 eksiğini alındı program başlarken
    _controller.index = widget.katId - 1;
    _controller.addListener(() {
      setState(() {
        //_selectedIndex = _controller.index;
        widget.katId = _controller.index + 1;
        //widget.subkatId = 0;
        widget.subkatId = (widget.katId * 10) + 1;
      });
      //debugPrint("Selected Index: " + _controller.index.toString());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TabBar get _tabBar => TabBar(
        indicatorPadding: EdgeInsets.all(5),
        //padding: EdgeInsets.all(7),
        tabs: [
          for (int i = 0; i < widget.katL; i++)
            Tab(
              text: katAdlar[i],
            ),
        ],
        controller: _controller,
        isScrollable: true,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        indicatorColor: Colors.yellow.shade700,
        indicator: BoxDecoration(
          color: Colors.green,

          // border: Border.all( width: 7,color: Colors.yellow.shade700,),
          borderRadius: BorderRadius.circular(9),
        ),
      );

  //Program
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: widget.katL,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ürünler"),
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: Colors.yellow.shade700,
              child: _tabBar,
            ),
          ),
        ),
        body: TabBarView(
          controller: _controller, //ekranı ile de scroll edebilelim.
          children: <Widget>[
            for (int i = 0; i < widget.katL; i++)
              Center(
                child: Center(
                  child: FutureBuilder(
                    builder: (_buildcontext,
                        AsyncSnapshot<List<Urun>> asyncSnapshot) {
                      if (asyncSnapshot.hasData) {
                        List<Urun>? urunss = asyncSnapshot.data;
                        List<Urun>? urunsSub = urunss;
                        //sıfırlamak için listeyi
                        subCategoryNames = [];
                        subCategoryIds = [];
                        secSub = [];

                        for (var i = 0; i < urunss!.length; i++) {
                          if (!categories.contains(urunss[i].kategori)) {
                            categories.add(urunss[i].kategori);
                          }
                        }

                        for (var i = 0; i < urunss.length; i++) {
                          if (!categoryIds.contains(urunss[i].katId)) {
                            categoryIds.add(urunss[i].katId);
                          }
                        }

                        //urunss = urunss.where((x) => x.subKatID == widget.subkatId).toList();

                        urunss = urunss
                            .where((x) => x.katId == widget.katId)
                            .toList();

                        for (var i = 0; i < urunss.length; i++) {
                          if (!subCategoryNames.contains(urunss[i].subKatAd)) {
                            subCategoryNames.add(urunss[i].subKatAd);
                          }

                          if (!subCategoryIds.contains(urunss[i].subKatID)) {
                            subCategoryIds.add(urunss[i].subKatID);
                          }
                        }

                        urunsSub = urunss
                            .where((x) =>
                                x.katId == widget.katId &&
                                x.subKatID == widget.subkatId)
                            .toList();

                        //widget.subkatId = subKatIDs[0];
                        debugPrint("2-subkatIdLER : $subCategoryIds");
/*
                        for (var i = 0; i < subKatAds.length; i++) {
                          if () {
                            secSub.add(false);
                          }
                          else {
                            secSub.add(true);
                          }
                        }
*/
                        debugPrint("2-subkatId : ${widget.subkatId}");
                        //debugPrint("katId:${widget.katId}");
                        //debugPrint("kategoriSayısı:${kategoriss.length}");

                        if (urunss == null) {
                          return Column();
                        }

                        return CustomScrollView(
                          slivers: [
                            SliverStickyHeader(
                              header: Container(
                                height: 40.0,
                                color: Colors.white,
                                //padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    for (var i = 0;
                                        i < subCategoryNames.length;
                                        i++)
                                      if (widget.subkatId == subCategoryIds[i])
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            margin: EdgeInsets.all(5.0),
                                            child: Text(
                                              subCategoryNames[i],
                                              style: const TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            margin: EdgeInsets.all(5.0),
                                            child: Text(
                                              subCategoryNames[i],
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                              sliver: SliverGrid.count(
                                childAspectRatio: 0.55,
                                crossAxisCount: 3,
                                children: <Widget>[
                                  for (int sira = 0;
                                      sira < urunss.length;
                                      sira++)
                                    Card(
                                      child: Container(
                                        //width:(MediaQuery.of(context).size.width /3.2),
                                        //height: (MediaQuery.of(context).size.height / 2),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            //1.satır -,kg,+ butonlar
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  //- button
                                                  SizedBox(
                                                    width:
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width /
                                                                    3) -
                                                                10) /
                                                            4,
                                                    child: ElevatedButton(
                                                      child: const Text(
                                                        "-",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      onPressed: () {
                                                        //Sepetteki kaç çeşit ürün olduğunu gösteren sayıyı azalt.
                                                        if (maxCartWeight[
                                                                sira] ==
                                                            double.parse(urunss![
                                                                    sira]
                                                                .defCartWeight)) {
                                                          setState(() {
                                                            productAmount =
                                                                productAmount -
                                                                    1;
                                                          });
                                                        }
                                                        //ürün kg değerini DEFAULT_CART_WEIGHT kadar azalt.
                                                        if (maxCartWeight[
                                                                sira] >=
                                                            double.parse(urunss[
                                                                    sira]
                                                                .defCartWeight)) {
                                                          setState(() {
                                                            maxCartWeight[
                                                                sira] = maxCartWeight[
                                                                    sira] -
                                                                double.parse(
                                                                    urunss![sira]
                                                                        .defCartWeight);
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  //Text Değişken / lokal değişken, kgdegerUrun de saklanıyor.
                                                  Text(
                                                      "${maxCartWeight[sira]} kg"),
                                                  //+
                                                  SizedBox(
                                                    width:
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width /
                                                                    3) -
                                                                10) /
                                                            4,
                                                    child: ElevatedButton(
                                                      child: const Text(
                                                        "+",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      //ürün MAKSIMUM_CART_WEIGHT e ulaşmadığı sürece kg ını artır.
                                                      onPressed: () {
                                                        if (maxCartWeight[
                                                                sira] <
                                                            double.parse(urunss![
                                                                    sira]
                                                                .maksCartWeight)) {
                                                          setState(() {
                                                            maxCartWeight[
                                                                sira] = maxCartWeight[
                                                                    sira] +
                                                                double.parse(
                                                                    urunss![sira]
                                                                        .defCartWeight);
                                                          });
                                                        } else {
                                                          //ürün MAKSIMUM_CART_WEIGHT i geçerse uyarı mesajı ver.
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                "Maksimum ürün ekleme ağırlığına ulaştınız",
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            backgroundColor:
                                                                Colors.green
                                                                    .shade900,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0,
                                                          );
                                                        }
                                                        //Sepetteki kaç çeşit ürün olduğunu gösteren sayıyı artır.
                                                        if (maxCartWeight[
                                                                sira] ==
                                                            double.parse(urunss[
                                                                    sira]
                                                                .defCartWeight)) {
                                                          setState(() {
                                                            productAmount =
                                                                productAmount +
                                                                    1;
                                                          });
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
                                                    builder: (context) =>
                                                        UrunDetay(
                                                            //UrunDetay sayfasına veri gönderiyoruz.
                                                            urunResim:
                                                                "assets/img/${urunss![sira].urunResim}",
                                                            urunFiyat: double
                                                                .parse(urunss[
                                                                        sira]
                                                                    .urunFiyat),
                                                            urunAd: urunss[sira]
                                                                .urunAd,
                                                            urunAciklama:
                                                                urunss[sira]
                                                                    .urunAciklama,
                                                            urunMensei:
                                                                urunss[sira]
                                                                    .mensei,
                                                            urunKaynak:
                                                                urunss[sira]
                                                                    .kaynak),
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
                                            Text(
                                              '${urunss[sira].subKatID} subkat',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          ],
                        );
                      } else {
                        debugPrint(
                            "Ürünler getirelemedi;Sebep: + ${asyncSnapshot.data}");
                        return Center(
                          //heightFactor: MediaQuery.of(context).size.height / 3,
                          heightFactor: 11.0,
                          //Bekleme işareti spinner
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        );
                      }
                    },
                    future:
                        urunFuture, //her seferinde json ı serverdan çağırıp yük bindirmesin diye.
                  ),
                ),
              ),
          ],
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
                  productAmount.toString(),
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
                debugPrint("Anasayfa");
                break;
              case 1:
                //Navigator.pushNamed(context, "/ara");
                debugPrint("Ara");
                break;
              case 2:
                //Navigator.pushNamed(context, "/sepetim");
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
      ),
    );
  }
}
