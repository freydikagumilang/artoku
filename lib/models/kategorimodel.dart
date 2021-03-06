import 'package:artoku/dbhelper.dart';

class kategori {
  int kat_id=0;
  String _kat_nama="";
  double _kat_komisi=0.0;

  kategori(
    this._kat_nama,
    this._kat_komisi,
  );
  kategori.map(dynamic obj) {
    this._kat_nama = obj["kat_nama"];
    this._kat_komisi = obj["kat_komisi"];
  }

  String get kat_nama => _kat_nama;
  double get kat_komisi => _kat_komisi;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["kat_nama"] = kat_nama;
    map["kat_komisi"] = kat_komisi;

    return map;
  }

  void setId(int id) {
    this.kat_id = id;
  }
}

class kategoriDAO {
  Future<List<kategori>> getKat(String cari) async {
    var dbClient = await DBHelper().setDb();
    
    
    List<Map> datalist = await dbClient.rawQuery("select * from kategori where kat_nama like '%${cari}%' ");
    List<kategori> listkategori = new List();

    for (var i = 0; i < datalist.length; i++) {
      var row = new kategori(
        datalist[i]['kat_nama'].toString(),
        datalist[i]['kat_komisi'],
      );
      listkategori.add(row);
      row.setId(datalist[i]["kat_id"]);
    }
    return listkategori;
  }
  Future<int> saveKat(kategori kat) async {
    var dbClient = await DBHelper().setDb();
    int res = await dbClient.insert("kategori", kat.toMap());
    return res;
  }
  Future<int> updateKat(kategori kat) async {
    var dbClient = await DBHelper().setDb();
    int res = await dbClient.update("kategori", kat.toMap(),
        where: "kat_id=?", whereArgs: <int>[kat.kat_id]);
    return res;
  }

  Future<int> deleteKat(int idkat) async {
    var dbClient = await DBHelper().setDb();
    int res = await dbClient.rawDelete(
        "delete from kategori where kat_id = ?", [idkat]);
    return res;
  }
}
