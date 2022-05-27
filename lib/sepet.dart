import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //response

import 'package:flutter_makbul1/database/dbcontroller.dart';
import 'package:flutter_makbul1/database/dblocal.dart';
import 'package:badges/badges.dart';
import 'package:flutter_makbul1/kategori/urun.dart'; // bottomnavigation daki badge küçük bildirimler için

class Sepet extends StatefulWidget {
  final List<DbCart> cartItemList;

  const Sepet({
    Key? key,
    required this.cartItemList,
  }) : super(key: key);

  @override
  State<Sepet> createState() => _SepetState();
}

class _SepetState extends State<Sepet> {
  DbController dbController = DbController();
  double toplamTutar = 0;

  List<String> kategoriss = [];
  List<int> kategorissId = [];
  List<double> kgDegerUrun = [];

  //Urunleri Çek Firebase -> urun.json

  late Future<List<Urun>> urunFuture;
  Future<List<Urun>> urunListele() async {
    List<Urun> uruns = [];
    Uri url = Uri.parse(
        'https://makbulfirebase-default-rtdb.firebaseio.com/urun.json');
    http.Response cevap = await http.get(url);

    //statuscode = 200 -> başarılı
    if (cevap.statusCode == 200) {
      debugPrint("Liste Okuma Başarılı");
      List cevapListesi = json.decode(cevap.body);
      debugPrint("$cevapListesi");

      for (var eleman in cevapListesi) {
        Urun urun = Urun.fromJson(eleman);
        uruns.add(urun);
        //kgDegerUrun.add(urun.defCartWeight);

      }
    } else {
      debugPrint("Error: ${cevap.statusCode}");
      throw Exception(
          "Veriler getirilirken hata oluştu. \n Hata kodu: ${cevap.statusCode}");
    }

    return uruns;
  }

  //Urunleri Çek Firebase -> urun.json
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    urunFuture = urunListele();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sepetim"),
        backgroundColor: Colors.green,
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

              return Stack(
                children: [
                  Container(
                    child: ListView.builder(
                      itemCount: widget.cartItemList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                              child: Column(
                            children: [
                              Card(
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: ListTile(
                                      leading:
                                          Image.asset("assets/img/seftali.png"),
                                      title: Text(
                                          widget.cartItemList[index].prodName),
                                      subtitle: Text(
                                        "${widget.cartItemList[index].prodPrice} TL",
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
                                      trailing: Column(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  debugPrint(
                                                      '+ butonuna bastı');
                                                },
                                                child: Text('+'),
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.amber),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Text(widget
                                                  .cartItemList[index]
                                                  .prodQuantity),
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                child: Text('-'),
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.amber),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),

                                  /*       
                                      Container(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: ((MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3) -
                                                        10) /
                                                    4,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text('-'),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              Colors.amber),
                                                ),
                                              ),
                                              SizedBox(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(widget
                                                      .cartItemList[index]
                                                      .prodQuantity),
                                                ),
                                              ),
                                              SizedBox(
                                                width: ((MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3) -
                                                        10) /
                                                    4,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text("+"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              Colors.amber),
                                                ),
                                              ),
                                            ]),
                                      ) */
                                ),
                              ),
                            ],
                          )),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: ListTile(
                          leading: const Text('Toplam Fiyat: '),
                          trailing: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Sepetimi Onayla'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange.shade400),
                          ),
                        )),
                  )
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
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.add_shopping_cart_rounded,
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
              Navigator.pushNamed(context, "/arasayfa");
              debugPrint("Arasayfa");
              break;
            case 2:
              //Navigator.pushNamed(context, "/sepetim");
              //sepetEkraniAc();
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
