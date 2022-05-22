import 'package:flutter/cupertino.dart'; //debugprint kullanmak için.. sonra iptal edilebilir..
import 'package:sqflite/sqflite.dart'; //veritabani islemleri icin
import 'dart:io' as io; //klasör ..
import 'package:path_provider/path_provider.dart'; //konum..
import 'package:path/path.dart'; //veritabani islemleri icin
import 'dblocal.dart'; //veritabani islemleri icin

//Bütün veritabanı işlemlerini burada yapıyoruz// yine havalı ingilizce isimler ..
class DbController {
  static final DbController _controller = DbController.inProcess();

  factory DbController() => _controller;

//inProcess ile veritabanımızı ilk olarak oluşturduk
  DbController.inProcess();

//ram de veritabanına yer ayırdık
  static late Database _db;

//sqlite oluştur, oluşturulmadı ise - get metodu ile veritabanını çağırıyoruz
  Future<Database> get dbLocalCart async {
    /*
    if (_db != null) {
      return _db;
    }
    */
    _db = await createDb();
    return _db;
  }

//konum için path, pathprovider kütüphanelerine ihtiyacımız var.
  createDb() async {
    io.Directory filePath = await getApplicationDocumentsDirectory();
    //localCart.db adında veri tabanı oluşturuyoruz.. join ile dosya oluşturulur.
    String dbPath = join(filePath.path, "localCart.db");
    //dosyamızı açıyoruz->ilk açtığımızda onCreate metodu çalışıyor
    var dbLocalCart =
        await openDatabase(dbPath, version: 1, onCreate: _firstOpen);
    //debugPrint("Veritabanı oluşturuldu");
    return dbLocalCart;
  }

  //oncreate teki ilk açılış metodu. İlk açılışta tablolar oluşturduk.
  //Cart isminde tablo içine (5 sütun id, ProdName, ProdQuantity, ProdPrice)
  _firstOpen(Database db, int version) async {
    await db.execute(
        "CREATE TABLE CartTable(id INTEGER PRIMARY KEY AUTOINCREMENT, ProdId INTEGER, ProdName TEXT, ProdQuantity TEXT, ProdPrice TEXT)");
  }

  //Future fonksiyonu - DbCart türünde değer alıyor
  Future<int> cartSave(DbCart cart) async {
    //dbCart adında veritabani değişkeni oluşturuyoruz ve yukarıdaki veritabanını beklemesini istiyoruz
    var dbCart = await dbLocalCart;
    //dbCart oluştuğu anda yukarıda oluşturduğumuz Cart tablosuna sana gönderdiğimiz cart i harita yap(parçala) ve ekle
    int response = await dbCart.insert("CartTable", cart.makeMap());
    return response;
  }

  //DbCart Jeneriğinde bir List olarak getir
  Future<List<DbCart>> cartGet() async {
    var dbCart = await dbLocalCart;

    //Veritabanı geldikten sonra çağırıyoruz.
    List<Map> cartList = await dbCart.rawQuery("SELECT * FROM CartTable");
    //debugPrint("VERİTABANI Cart: $cartList");

    //Sonra Cart listesi oluşturduk
    List<DbCart> carts = [];

    //Üstteki oluşturduğumuz liste deki sayı kadar oluşturduğumuz cart ları yukarıda oluşturduğumuz cart listesine ekliyoruz
    for (int i = 0; i < cartList.length; i++) {
      var cart = DbCart(cartList[i]["ProdId"], cartList[i]["ProdName"],
          cartList[i]["ProdQuantity"], cartList[i]["ProdPrice"]);
      cart.setId(cartList[i]["id"]);
      carts.add(cart);
    }
    return carts;
  }

  //geri dönüş değeri int
  Future<int> cartDelete(String prodName) async {
    var dbCart = await dbLocalCart;
    int response = await dbCart
        .rawDelete("DELETE FROM CartTable WHERE ProdName = ?", [prodName]);
    return response;
  }

  //boolean olarak true/false döndürmesini istiyoruz.
  Future<bool> cartUpdate(DbCart cart) async {
    var dbCart = await dbLocalCart;
    int respone = await dbCart.update("CartTable", cart.makeMap(),
        where: "prodName = ?", whereArgs: <String>[cart.prodName]);

    //cevap 0 dan büyükse true değilse false
    return respone > 0 ? true : false;
  }
}
