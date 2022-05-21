class Kategori {
  late int katId;
  late String kategori;
  late String katresim;
  late int subKatg;
  late int subKatSayisi;
  //late List<int> subKatg;

  //Constructor metodu ile oluşturunca her seferinde girilmesi zorunda bırakıyoruz.
  Kategori(
      {required this.katId,
      required this.kategori,
      required this.katresim,
      required this.subKatg,
      required this.subKatSayisi});

  Kategori.fromJson(Map<String, dynamic> json) {
    katId = json['katId'];
    kategori = json['kategori'];
    katresim = json['katresim'];
    subKatg = json['subKatg'];
    subKatSayisi = json['subKatSayisi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['katId'] = this.katId;
    data['kategori'] = this.kategori;
    data['katresim'] = this.katresim;
    data['subKatg'] = this.subKatg;
    data['subKatSayisi'] = this.subKatSayisi;
    return data;
  }
}
