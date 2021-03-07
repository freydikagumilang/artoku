import 'package:artoku/dbhelper.dart';
import 'package:artoku/models/kapstermodel.dart';
import 'package:artoku/models/produkmodel.dart';
import 'package:artoku/ui_view/transaksi/kasir.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class invoice {
  int inv_id;
  int _inv_plg_id;
  String _inv_no;
  String _inv_date;
  double _inv_total_bruto;
  double _inv_diskon;
  double _inv_total_net;
  double _inv_paid;
  int _inv_iscash;
  int _inv_created_at;
  int _inv_updated_at;
  int _inv_deleted_at;
  String inv_plg_nama;
  String inv_plg_hp;
  List<invoicedet> details;
  double totalkomisi;
  DateTimeRange periode;
  double total_qty;

  invoice(
      this._inv_no,
      this._inv_date,
      this._inv_plg_id,
      this._inv_total_bruto,
      this._inv_diskon,
      this._inv_total_net,
      this._inv_created_at,
      this._inv_updated_at,
      this._inv_deleted_at,
      {this.inv_plg_nama,
      this.inv_plg_hp,
      this.details,
      this.totalkomisi,
      this.periode,
      this.total_qty});
  invoice.map(dynamic obj) {
    this._inv_no = obj["inv_no"];
    this._inv_date = obj["inv_date"];
    this._inv_plg_id = obj["inv_plg_id"];
    this._inv_total_bruto = obj["inv_total_bruto"];
    this._inv_diskon = obj["inv_diskon"];
    this._inv_total_net = obj["inv_total_net"];
    this._inv_created_at = obj["inv_created_at"];
    this._inv_updated_at = obj["inv_updated_at"];
    this._inv_deleted_at = obj["inv_deleted_at"];
    this.inv_plg_nama = obj["inv_plg_nama"];
    this.inv_plg_hp = obj["inv_plg_hp"];
    this.details = obj["details"];
  }

  String get inv_no => _inv_no;
  String get inv_date => _inv_date;
  int get inv_plg_id => _inv_plg_id;
  double get inv_total_bruto => _inv_total_bruto;
  double get inv_diskon => _inv_diskon;
  double get inv_total_net => _inv_total_net;
  double get inv_paid => _inv_paid;
  int get inv_iscash => _inv_iscash;
  int get inv_created_at => _inv_created_at;
  int get inv_updated_at => _inv_updated_at;
  int get inv_deleted_at => _inv_deleted_at;
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["inv_no"] = inv_no;
    map["inv_date"] = inv_date;
    map["inv_plg_id"] = inv_plg_id;
    map["inv_total_bruto"] = inv_total_bruto;
    map["inv_diskon"] = inv_diskon;
    map["inv_total_net"] = inv_total_net;
    map["inv_paid"] = inv_paid;
    map["inv_iscash"] = inv_iscash;
    map["inv_created_at"] = inv_created_at;
    map["inv_deleted_at"] = inv_deleted_at;

    return map;
  }

  void setId(int id) {
    this.inv_id = id;
  }
}

class invoicedet {
  int invdet_id;
  int invdet_inv_id;
  int _invdet_tmp_id;
  int _invdet_item_id;
  String _invdet_ket;
  double _invdet_qty;
  double _invdet_price;
  double _invdet_total;
  double _invdet_komisi;
  int _invdet_kapster_id;
  int _invdet_created_at;
  int _invdet_updated_at;
  int _invdet_deleted_at;
  String invdet_prod_nama;
  String invdet_kapster_name;
  String invdet_kat_nama;
  double invdet_kat_komisi;
  String invdet_inv_no;
  String invdet_pelanggan_nama;

  invoicedet(
      this._invdet_tmp_id,
      this._invdet_item_id,
      this._invdet_ket,
      this._invdet_qty,
      this._invdet_price,
      this._invdet_total,
      this._invdet_komisi,
      this._invdet_kapster_id,
      this._invdet_created_at,
      this._invdet_updated_at,
      this._invdet_deleted_at,
      {this.invdet_prod_nama,
      this.invdet_kapster_name,
      this.invdet_kat_nama,
      this.invdet_kat_komisi,
      this.invdet_inv_no,
      this.invdet_pelanggan_nama});

  invoicedet.map(dynamic obj) {
    this._invdet_tmp_id = obj["invdet_tmp_id"];
    this._invdet_item_id = obj["invdet_item_id"];
    this._invdet_ket = obj["invdet_ket"];
    this._invdet_qty = obj["invdet_qty"];
    this._invdet_price = obj["invdet_price"];
    this._invdet_total = obj["invdet_total"];
    this._invdet_komisi = obj["invdet_komisi"];
    this._invdet_kapster_id = obj["invdet_kapster_id"];
    this._invdet_created_at = obj["invdet_created_at"];
    this._invdet_updated_at = obj["invdet_updated_at"];
    this._invdet_deleted_at = obj["invdet_deleted_at"];
    this.invdet_prod_nama = obj["invdet_prod_nama"];
    this.invdet_kapster_name = obj["invdet_kapster_name"];
    this.invdet_kat_nama = obj["invdet_kat_nama"];
    this.invdet_kat_komisi = obj["invdet_kat_komisi"];
  }

  int get invdet_tmp_id => invdet_tmp_id;
  int get invdet_item_id => _invdet_item_id;
  String get invdet_ket => _invdet_ket;
  double get invdet_qty => _invdet_qty;
  double get invdet_price => _invdet_price;
  double get invdet_total => _invdet_total;
  double get invdet_komisi => _invdet_komisi;
  int get invdet_kapster_id => _invdet_kapster_id;
  int get invdet_created_at => _invdet_created_at;
  int get invdet_updated_at => _invdet_updated_at;
  int get invdet_deleted_at => _invdet_deleted_at;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["invdet_inv_id"] = invdet_inv_id;
    map["invdet_item_id"] = invdet_item_id;
    map["invdet_ket"] = invdet_ket;
    map["invdet_qty"] = invdet_qty;
    map["invdet_price"] = invdet_price;
    map["invdet_total"] = invdet_total;
    map["invdet_komisi"] = invdet_komisi;
    map["invdet_kapster_id"] = invdet_kapster_id;
    map["invdet_created_at"] = invdet_created_at;
    map["invdet_updated_at"] = invdet_updated_at;
    map["invdet_deleted_at"] = invdet_deleted_at;

    return map;
  }

  void setId(int id) {
    this.invdet_id = id;
  }

  void setInvId(int id) {
    this.invdet_inv_id = id;
  }
}

class salesperday {
  int _sale_date;
  double _sale_total;
  salesperday(this._sale_date, this._sale_total);

  salesperday.map(dynamic obj) {
    this._sale_date = obj["saledate"];
    this._sale_total = obj["saletotal"];
  }

  int get saledate => _sale_date;
  double get saletotal => _sale_total;
}

class salesperitem {
  String _item;
  double _sale_total;
  salesperitem(this._item, this._sale_total);

  salesperitem.map(dynamic obj) {
    this._item = obj["item"];
    this._sale_total = obj["saletotal"];
  }

  String get item => _item;
  double get saletotal => _sale_total;
}

class fltKomisiPegawai{
  DateTimeRange dtr;
  kapster dtkapster;
  fltKomisiPegawai(this.dtr,this.dtkapster);

}

class invoiceDAO {
  Future<List<invoice>> getInv(String cari) async {
    var dbClient = await DBHelper().setDb();
    String sSQL = '''select * 
    from invoice 
    inner join pelanggan
      on inv_plg_id = pelanggan_id
    where (inv_no like "%${cari}%" or pelanggan_nama like "%${cari}%" or 
    pelanggan_hp like "%${cari}%") and  inv_deleted_at = 0''';

    List<Map> datalist = await dbClient.rawQuery(sSQL);
    List<invoice> list_inv = new List();

    for (var i = 0; i < datalist.length; i++) {
      var row = new invoice(
        datalist[i]['inv_no'].toString(),
        datalist[i]['inv_date'].toString(),
        datalist[i]['inv_plg_id'],
        datalist[i]['inv_total_bruto'],
        datalist[i]['inv_diskon'],
        datalist[i]['inv_total_net'],
        datalist[i]['inv_created_at'],
        datalist[i]['inv_updated_at'],
        datalist[i]['inv_deleted_at'],
        inv_plg_hp: datalist[i]['pelanggan_hp'],
        inv_plg_nama: datalist[i]['pelanggan_nama'],
      );
      list_inv.add(row);
      row.setId(datalist[i]["inv_id"]);
    }
    return list_inv;
  }

  Future<int> saveInv(invoice inv) async {
    var dbClient = await DBHelper().setDb();

    int res = await dbClient.insert("invoice", inv.toMap());

    // print("inv_id:" + res.toString());
    List<invoicedet> _details = inv.details;
    for (var i = 0; i < _details.length; i++) {
      int _prod_id = _details[i].invdet_item_id;
      await _details[i].setInvId(res);
      int _detid = await dbClient.insert("invoicedet", _details[i].toMap());
      String sSQLdet =
          '''update produk set prod_sale_retention = prod_sale_retention + 1
                where prod_id = $_prod_id ''';
      await dbClient.rawQuery(sSQLdet);
    }
    return res;
  }

  Future<int> updateInv(invoice inv) async {
    var dbClient = await DBHelper().setDb();
    int res = await dbClient.update("invoice", inv.toMap(),
        where: "inv_id=?", whereArgs: <int>[inv.inv_id]);
    return res;
  }

  Future<int> deleteInv(int inv_id) async {
    var dbClient = await DBHelper().setDb();
    int res = await dbClient.rawDelete(
        "update invoice deleted_at = strftime('%s', 'now')  where inv_id = ?",
        [inv_id]);
    await dbClient.rawDelete(
        "update invoicedet deleted_at = strftime('%s', 'now')  where invdet_inv_id = ?",
        [inv_id]);
    return res;
  }

  Future<List<invoicedet>> getInvDet(int invdet_inv_id) async {
    var dbClient = await DBHelper().setDb();
    String sSQL = '''Create table IF NOT EXISTS invoicedet (
      invdet_id INTEGER PRIMARY KEY autoincrement,
      invdet_inv_id int,invdet_item_id int,
      invdet_ket string, invdet_qty real, invdet_price real,invdet_total real,
      invdet_komisi real,invdet_kapster_id integer,invdet_created_at integer,invdet_updated_at integer DEFAULT 0 ,
      invdet_deleted_at integer DEFAULT 0  )''';

    await dbClient.rawQuery(sSQL);
    sSQL = '''select * 
    from invoicedet 
    inner join produk
      on invdet_item_id = prod_id
    inner join kategori
      on kat_id = prod_kat_id
    inner join kapster
      on kapster_id = invdet_kapster_id
    where invdet_inv_id like "%${invdet_inv_id}%" and invdet_deleted_at = 0''';

    List<Map> datalist = await dbClient.rawQuery(sSQL);
    List<invoicedet> list_invdet = new List();

    for (var i = 0; i < datalist.length; i++) {
      var row = new invoicedet(
        datalist[i]['invdet_inv_id'],
        datalist[i]['invdet_item_id'],
        datalist[i]['invdet_ket'],
        datalist[i]['invdet_qty'],
        datalist[i]['invdet_price'],
        datalist[i]['invdet_total'],
        datalist[i]['invdet_komisi'],
        datalist[i]['invdet_kapster_id'],
        datalist[i]['invdet_created_at'],
        datalist[i]['invdet_updated_at'],
        datalist[i]['invdet_deleted_at'],
        invdet_prod_nama: datalist[i]['prod_nama'],
        invdet_kapster_name: datalist[i]['kapster_nama'],
        invdet_kat_komisi: datalist[i]['kat_komisi'],
        invdet_kat_nama: datalist[i]['kat_nama'],
      );
      list_invdet.add(row);
      row.setId(datalist[i]["invdet_id"]);
    }
    return list_invdet;
  }

  Future<List<salesperday>> GetSalelast7Days(List<int> cari) async {
    var dbClient = await DBHelper().setDb();

    List<salesperday> _sales7days = [];
    int _start_date = 0;
    int _end_date = 0;
    salesperday baris;
    for (int i = 0; i < cari.length; i += 2) {
      _start_date = cari[i];
      _end_date = cari[(i + 1)];
      String sSQL =
          '''select sum(inv_total_net) total,inv_created_at from invoice where inv_created_at between $_start_date and $_end_date; ''';

      List<Map> datalist = await dbClient.rawQuery(sSQL);

      if (datalist[0]['total'] != null) {
        baris = new salesperday(
          datalist[0]['inv_created_at'],
          datalist[0]['total'],
        );
        // print("found baris ke $i :"+baris.saletotal.toString());
      } else {
        baris = new salesperday(cari[i], 0);
        // print("baris ke $i :"+baris.saletotal.toString());
      }

      _sales7days.add(baris);
    }
    return _sales7days;
  }

  Future<List<salesperitem>> GetSalesPerItem(DateTimeRange dtrange) async {
    int _start_date;
    int _end_date;
    _start_date = DateTime(dtrange.start.year, dtrange.start.month,
            dtrange.start.day, 0, 0, 0, 0, 0)
        .millisecondsSinceEpoch;
    _end_date = DateTime(dtrange.end.year, dtrange.end.month, dtrange.end.day,
            23, 59, 59, 0, 0)
        .millisecondsSinceEpoch;

    var dbClient = await DBHelper().setDb();

    String sSQL = '''
          select invdet_item_id,sum(invdet_total) total,
                 prod_nama
          from invoice 
          inner join invoicedet
            on invdet_inv_id = inv_id
          inner join produk
            on invdet_item_id = prod_id
          where inv_created_at between $_start_date and $_end_date
          group by invdet_item_id; ''';

    List<Map> datalist = await dbClient.rawQuery(sSQL);
    List<salesperitem> listperitem = [];

    for (var i = 0; i < datalist.length; i++) {
      var row = new salesperitem(
        datalist[i]["prod_nama"],
        datalist[i]["total"],
      );
      listperitem.add(row);
    }
    return listperitem;
  }

  Future<List<invoicedet>> CommissionBydate(DateTimeRange periode) async {
    int _startdate = periode.start.millisecondsSinceEpoch;
    int _enddate = DateTime(periode.end.year,periode.end.month,periode.end.day,23,59,59,0).millisecondsSinceEpoch;
    var dbClient = await DBHelper().setDb();

    String sSQL = '''select 
    kapster_id,kapster_nama,ifnull(komisi,0) nominal_komisi, ifnull(pekerjaan,0) total_pekerjaan
    from kapster  
    left join (select invdet_kapster_id,sum(invdet_komisi) komisi,count(invdet_id) pekerjaan
      from invoicedet        
      inner join invoice
        on  inv_id = invdet_inv_id          
      where invdet_deleted_at = 0 and inv_deleted_at = 0
        and inv_created_at between $_startdate and $_enddate
      group by invdet_kapster_id
      )x
      on kapster_id = invdet_kapster_id
    group by kapster_id ''';

    List<Map> datalist = await dbClient.rawQuery(sSQL);
    List<invoicedet> ListInvdet = [];

    for (var i = 0; i < datalist.length; i++) {
      var row = new invoicedet(
          0,
          0,
          '',
          datalist[i]['total_pekerjaan'] * 1.0,
          0,
          0,
          datalist[i]['nominal_komisi'] * 1.0,
          datalist[i]['kapster_id'],
          _startdate,
          0,
          0,
          invdet_kapster_name: datalist[i]['kapster_nama']);
      ListInvdet.add(row);
    }
    return ListInvdet;
  }

  Future<List<invoicedet>> TruncateTransactions() async {
    var dbClient = await DBHelper().setDb();
    String sSQL = "delete from invoice";
    await dbClient.rawQuery(sSQL);
    sSQL = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='invoice'";
    await dbClient.rawQuery(sSQL);
    sSQL = "delete from invoicedet";
    await dbClient.rawQuery(sSQL);
    sSQL = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='invoicedet'";
    await dbClient.rawQuery(sSQL);
    sSQL = "delete from bukukas";
    await dbClient.rawQuery(sSQL);
    sSQL = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='bukukas'";
    await dbClient.rawQuery(sSQL);
    sSQL = "delete from bukukasdet";
    await dbClient.rawQuery(sSQL);
    sSQL = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='bukukasdet'";
    await dbClient.rawQuery(sSQL);
    sSQL = "update produk set prod_sale_retention = 0";
    await dbClient.rawQuery(sSQL);
  }

  Future<List<invoicedet>> TruncateMaster() async {
    var dbClient = await DBHelper().setDb();
    String sSQL = "delete from produk";
    await dbClient.rawQuery(sSQL);
    sSQL = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='produk'";
    await dbClient.rawQuery(sSQL);
    sSQL = "delete from kapster";
    await dbClient.rawQuery(sSQL);
    sSQL = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='kapster'";
    await dbClient.rawQuery(sSQL);
    sSQL = "delete from kategori";
    await dbClient.rawQuery(sSQL);
    sSQL = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='kategori'";
    await dbClient.rawQuery(sSQL);
    sSQL = "delete from pelanggan";
    await dbClient.rawQuery(sSQL);
    sSQL = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='pelanggan'";
    await dbClient.rawQuery(sSQL);
  }

  Future<List<invoice>> GetSalesPeriodic(DateTimeRange periode) async {
    var dbClient = await DBHelper().setDb();
    int _start;
    int _end;
    _start = periode.start.millisecondsSinceEpoch;
    _end = DateTime(periode.end.year, periode.end.month, periode.end.day, 23,
            59, 59, 0, 0)
        .millisecondsSinceEpoch;

    String sSQL =
        ''' select *,ifnull(sum(ifnull(invdet_komisi,0)),0) komisi, invdet_inv_id
    from invoice 
    inner join pelanggan
      on pelanggan_id = inv_plg_id
    inner join invoicedet
      on invdet_inv_id = inv_id
    where inv_deleted_at = 0 and inv_created_at between $_start and $_end
    group by inv_id
    order by inv_created_at''';
    List<Map> datalist = await dbClient.rawQuery(sSQL);
    List<invoice> _result = [];
    for (int i = 0; i < datalist.length; i++) {
      invoice baris = new invoice(
        datalist[i]["inv_no"],
        datalist[i]["inv_date"],
        datalist[i]["inv_plg_id"],
        datalist[i]["inv_total_bruto"],
        datalist[i]["inv_diskon"],
        datalist[i]["inv_total_net"],
        datalist[i]["inv_created_at"],
        datalist[i]["inv_updated_at"],
        datalist[i]["inv_deleted_at"],
        inv_plg_nama: datalist[i]["pelanggan_nama"],
        inv_plg_hp: datalist[i]["pelanggan_hp"].toString(),
        totalkomisi: datalist[i]["komisi"],
      );
      _result.add(baris);
    }
    return _result;
  }

  Future<List<invoice>> GetSalesPerCustomer(invoice where) async {
    var dbClient = await DBHelper().setDb();
    DateTimeRange periode = where.periode;
    int _start;
    int _end;
    _start = periode.start.millisecondsSinceEpoch;
    _end = DateTime(periode.end.year, periode.end.month, periode.end.day, 23,
            59, 59, 0, 0)
        .millisecondsSinceEpoch;
    List<invoice> _result = [];
    String sSQL = ''' select inv_plg_id,pelanggan_nama,pelanggan_hp,
                      ifnull(sum(inv_total_net),0) total_net,
                      ifnull(sum(invdet_qty),0) qty
    from pelanggan
    inner join invoice
      on pelanggan_id = inv_plg_id
    inner join invoicedet
      on invdet_inv_id = inv_id
    where inv_deleted_at = 0 and inv_created_at between $_start and $_end''';

    if(where.inv_plg_id!=0){
      sSQL += ''' and inv_plg_id = '''+where.inv_plg_id.toString();
    }
    sSQL += ''' group by inv_plg_id
    order by qty desc''';
    List<Map> datalist = await dbClient.rawQuery(sSQL);

    for (int i = 0; i < datalist.length; i++) {
      invoice baris = new invoice(
        "",
        periode.start.toString(),
        datalist[i]["inv_plg_id"],
        0,
        0,
        datalist[i]["total_net"],
        0,
        0,
        0,
        inv_plg_nama: datalist[i]["pelanggan_nama"],
        inv_plg_hp: datalist[i]["pelanggan_hp"].toString(),
        total_qty: datalist[i]["qty"]
      );
      _result.add(baris);
    }
    return _result;
  }

  Future<List<invoicedet>> GetSalesbyPegawai(fltKomisiPegawai where) async {
    int _startdate = where.dtr.start.millisecondsSinceEpoch;
    int _enddate = DateTime(where.dtr.end.year,where.dtr.end.month,where.dtr.end.day,23,59,59,0).millisecondsSinceEpoch;
    int kap_id = where.dtkapster.kapster_id;
    var dbClient = await DBHelper().setDb();

    String sSQL = '''select *
      from invoicedet        
      inner join invoice
        on  inv_id = invdet_inv_id        
      inner join kapster
        on  kapster_id = invdet_kapster_id
      inner join produk
        on prod_id = invdet_item_id
      inner join kategori
        on kat_id = prod_kat_id 
      inner join pelanggan
        on pelanggan_id = inv_plg_id
      where invdet_deleted_at = 0 and inv_deleted_at = 0
        and inv_created_at between $_startdate and $_enddate 
        and invdet_kapster_id = $kap_id ''';
      

    List<Map> datalist = await dbClient.rawQuery(sSQL);
    List<invoicedet> ListInvdet = [];

    for (var i = 0; i < datalist.length; i++) {
      var row = new invoicedet(0,  datalist[i]["invdet_item_id"], datalist[i]["invdet_ket"], 
                datalist[i]["invdet_qty"], datalist[i]["invdet_price"], 
                datalist[i]["invdet_total"], datalist[i]["invdet_komisi"], datalist[i]["invdet_kapster_id"], 
                datalist[i]["invdet_created_at"], datalist[i]["invdet_updated_at"], 
                datalist[i]["invdet_deleted_at"],
                invdet_prod_nama: datalist[i]["prod_nama"],
                invdet_kapster_name: datalist[i]["kapster_nama"],
                invdet_kat_nama: datalist[i]["kat_nama"],
                invdet_inv_no: datalist[i]["inv_no"],
                invdet_pelanggan_nama: datalist[i]["pelanggan_nama"],
                );
      ListInvdet.add(row);
      print(datalist[i]["pelanggan_nama"]);
    }
    return ListInvdet;
  }


}
