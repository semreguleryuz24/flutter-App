class Urun {
  late int urunId;
  late int katId;
  late String kategori;
  late String urunAd;
  late String maksCartWeight;
  late String defCartWeight;
  late String urunAciklama;
  late String mensei;
  late String kaynak;
  late String urunFiyat;
  late String urunResim;
  late String subKatAd;
  late int subKatID;
  //Constructor metodu ile oluşturunca her seferinde girilmesi zorunda bırakıyoruz.
  Urun({
    required this.urunId,
    required this.katId,
    required this.kategori,
    required this.urunAd,
    required this.maksCartWeight,
    required this.defCartWeight,
    required this.urunAciklama,
    required this.mensei,
    required this.kaynak,
    required this.urunFiyat,
    required this.urunResim,
    required this.subKatAd,
    required this.subKatID,
  });

  Urun.fromJson(Map<String, dynamic> json) {
    urunId = json['urunId'];
    katId = json['katId'];
    kategori = json['kategori'];
    urunAd = json['urunAd'];
    maksCartWeight = json['maksCartWeight'];
    defCartWeight = json['defCartWeight'];
    urunAciklama = json['urunAciklama'];
    mensei = json['mensei'];
    kaynak = json['kaynak'];
    urunFiyat = json['urunFiyat'];
    urunResim = json['urunResim'];
    subKatAd = json['subKatAd'];
    subKatID = json['subKatID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['urunId'] = this.urunId;
    data['katId'] = this.katId;
    data['kategori'] = this.kategori;
    data['urunAd'] = this.urunAd;
    data['maksCartWeight'] = this.maksCartWeight;
    data['defCartWeight'] = this.defCartWeight;
    data['urunAciklama'] = this.urunAciklama;
    data['mensei'] = this.mensei;
    data['kaynak'] = this.kaynak;
    data['urunFiyat'] = this.urunFiyat;
    data['urunResim'] = this.urunResim;
    data['subKatAd'] = this.subKatAd;
    data['subKatID'] = this.subKatID;
    return data;
  }
}
