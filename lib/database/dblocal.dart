//Bu sefer ingilizce değişkenler ;) Sizin standart ne ise ona uyarlayabilirsiniz.
class DbCart {
  late int id; // ürün no..
  late int _prodId; //ürün adı
  late String _prodName; //ürün adı
  late String _prodQuantity; //ürün miktar / adet / kg /..
  late String _prodPrice; // ürün birim fiyat

  //Constructor metodu ile oluşturunca her seferinde girilmesi zorunda bırakıyoruz.
  DbCart(this._prodId, this._prodName, this._prodQuantity, this._prodPrice);

  //Harita map nesnesine çeviriyoruz. Nesne olarak çağırdığımızda parçalı gelmesi için.
  DbCart.map(dynamic dObj) {
    _prodId = dObj["prodId"];
    _prodName = dObj["prodName"];
    _prodQuantity = dObj["prodQuantity"];
    _prodPrice = dObj["prodPrice"];
  }

//Get metodu oluştuyoruz - Gelen değerleri nesneye çevirmek için
  int get prodId => _prodId;
  String get prodName => _prodName;
  String get prodQuantity => _prodQuantity;
  String get prodPrice => _prodPrice;

//Gelen değerleri nesneye çevirmek için
  Map<String, dynamic> makeMap() {
    var map = <String, dynamic>{};
    map["prodId"] = _prodId;
    map["prodName"] = _prodName;
    map["prodQuantity"] = _prodQuantity;
    map["prodPrice"] = _prodPrice;

    return map;
  }

//set metodu ile numara ver - herhangi bir ürüne numara verebiliyoruz
  void setId(int id) {
    this.id = id;
  }
}
