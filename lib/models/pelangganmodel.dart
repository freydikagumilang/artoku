import 'package:artoku/dbhelper.dart';

class pelanggan {
  int pelanggan_id = 0;
  String _pelanggan_nama = "";
  String _pelanggan_hp = "";
  String _pelanggan_alamat = "";
  int fromkasir = 0;
  pelanggan(this._pelanggan_nama, this._pelanggan_hp, this._pelanggan_alamat,
      {this.fromkasir});
  pelanggan.map(dynamic obj) {
    this._pelanggan_nama = obj["pelanggan_nama"];
    this._pelanggan_hp = obj["_pelanggan_hp"];
    this._pelanggan_alamat = obj["_pelanggan_alamat"];
  }

  String get pelanggan_nama => _pelanggan_nama;
  String get pelanggan_hp => _pelanggan_hp;
  String get pelanggan_alamat => _pelanggan_alamat;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["pelanggan_nama"] = pelanggan_nama;
    map["pelanggan_hp"] = pelanggan_hp.toString();
    map["pelanggan_alamat"] = pelanggan_alamat;

    return map;
  }

  void setId(int id) {
    this.pelanggan_id = id;
  }
}

class PelangganDAO {
  Future<List<pelanggan>> getPelanggan(String cari) async {
    var dbClient = await DBHelper().setDb();

    List<Map> datalist = await dbClient.rawQuery(
        "select * from pelanggan where pelanggan_nama like '%${cari}%' or pelanggan_hp like '%${cari}%' order by pelanggan_nama");
    List<pelanggan> listpelanggan = new List();

    for (var i = 0; i < datalist.length; i++) {
      var row = new pelanggan(
        datalist[i]['pelanggan_nama'].toString(),
        datalist[i]['pelanggan_hp'].toString(),
        datalist[i]['pelanggan_alamat'].toString(),
      );
      listpelanggan.add(row);
      row.setId(datalist[i]["pelanggan_id"]);
    }

    return listpelanggan;
  }

  Future<int> savePelanggan(pelanggan pelanggan) async {
    var dbClient = await DBHelper().setDb();
    int res = await dbClient.insert("pelanggan", pelanggan.toMap());
    return res;
  }

  Future<int> updatePelanggan(pelanggan pelanggan) async {
    var dbClient = await DBHelper().setDb();
    int res = await dbClient.update("pelanggan", pelanggan.toMap(),
        where: "pelanggan_id=?", whereArgs: <int>[pelanggan.pelanggan_id]);
    return res;
  }

  Future<int> deletePelanggan(int idpelanggan) async {
    var dbClient = await DBHelper().setDb();
    int res = await dbClient.rawDelete(
        "delete from pelanggan where pelanggan_id = ?", [idpelanggan]);
    return res;
  }
}
