import 'package:artoku/ui_view/sysconfig/sysconfig.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/blockapster.dart';
import 'package:artoku/bloc/blockasir.dart';
import 'package:artoku/bloc/blocpelanggan.dart';
import 'package:artoku/bloc/blocproduk.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'package:artoku/global_var.dart';
import 'package:artoku/main.dart';
import 'package:artoku/models/kapstermodel.dart';
import 'package:artoku/models/kasirmodel.dart';
import 'package:artoku/models/kasmodel.dart';
import 'package:artoku/models/pelangganmodel.dart';
import 'package:artoku/models/produkmodel.dart';
import 'package:artoku/txtformater.dart';
import 'package:artoku/ui_view/masterdata/input_pelanggan.dart';
import 'package:artoku/ui_view/produk/input_produk.dart';
import 'package:artoku/ui_view/template/frxappbar.dart';
import 'package:intl/intl.dart';
import 'package:artoku/ui_view/transaksi/printnota.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';

class Kasir extends StatefulWidget {
  @override
  KasirState createState() => KasirState();
}

class KasirState extends State<Kasir> with SingleTickerProviderStateMixin {
  TabController tabct;
  List<kapster> kaps;
  List<produk> prod;
  List<pelanggan> plg;

  _movetabto(int tab_idx) {
    setState(() {
      tabct.animateTo(tab_idx);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    tabct = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabct.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyApp(
                      tab_id: 0,
                    )));
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<Getkapster>(create: (context) => Getkapster(kaps)),
          BlocProvider<SearchItemKasir>(
              create: (context) => SearchItemKasir(prod)),
          BlocProvider<Getpelanggan>(create: (context) => Getpelanggan(plg)),
          BlocProvider<InsertDet>(create: (context) => InsertDet(0.0)),
          BlocProvider<CreateNota>(create: (context) => CreateNota(0)),
          BlocProvider<CreateBukuKas>(create: (context) => CreateBukuKas(0)),
        ],
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: FitnessAppTheme.tosca,
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed("/dashboard");
                }),
            elevation: 0,
            title: Text(
              "Kasir",
              style: TextStyle(fontSize: 25, color: FitnessAppTheme.white),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SysConfig()));
                },
                child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.settings,
                      size: 30,
                    )),
              )
            ],
          ),
          body: TabBarView(controller: tabct, children: [
            SearchItem(_movetabto),
            SearchPelanggan(_movetabto),
            KasirCheckout(_movetabto),
          ]),
          bottomNavigationBar: new Material(
              color: FitnessAppTheme.tosca,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    )
                  ],
                  color: Colors.teal[300].withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: TabBar(
                  controller: tabct,
                  indicatorColor: FitnessAppTheme.yellow,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(icon: Icon(Icons.search), text: "Item"),
                    Tab(
                      icon: Icon(Icons.person),
                      text: "Pelanggan",
                    ),
                    Tab(
                      icon: Icon(Icons.payment_rounded),
                      text: "Bayar",
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class SearchItem extends StatefulWidget {
  final ValueChanged<int> tabnavigator;
  const SearchItem(this.tabnavigator);
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  TextEditingController txtcariprod = TextEditingController();
  List<kapster> kaps;
  @override
  void initState() {
    // TODO: implement initState
    FocusManager.instance.primaryFocus.unfocus();
    Future.delayed(Duration.zero, () {
      SearchItemKasir bloc = BlocProvider.of<SearchItemKasir>(context);
      bloc.add("");
    });
  }

  @override
  Widget build(BuildContext context) {
    var NumFormat = new NumberFormat.compact(locale: "id");
    SearchItemKasir bloc = BlocProvider.of<SearchItemKasir>(context);
    return Container(
      padding: EdgeInsets.all(8),
      color: FitnessAppTheme.tosca,
      child: BlocBuilder<SearchItemKasir, List<produk>>(
        builder: (context, dt_item) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 10,
                  child: Card(
                      color: FitnessAppTheme.white,
                      child: TextFormField(
                        
                        controller: txtcariprod,
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Cari Produk",
                            contentPadding: EdgeInsets.all(8),
                            prefixIcon: Icon(
                              Icons.search,
                              color: FitnessAppTheme.tosca,
                            )),
                        onChanged: (val) {
                          Future.delayed(Duration(milliseconds: 500), () {
                            bloc.add(val);
                          });
                        },
                      )),
                ),
                Flexible(
                  flex: 2,
                  child: FlatButton(
                      padding: EdgeInsets.all(0),
                      height: 48,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      color: FitnessAppTheme.yellow,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InputProduk(
                                      fromkasir: 1,
                                    )));
                      },
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: FitnessAppTheme.white,
                      )),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: (dt_item == null) ? 0 : dt_item.length,
                itemBuilder: (context, idx) {
                  return GestureDetector(
                    onTap: () async {
                      AlertDialog pilKapster = AlertDialog(
                        title: Text(dt_item[idx].kat_nama +
                            " " +
                            dt_item[idx].prod_nama),
                        content:
                            PilihKapster(widget.tabnavigator, dt_item[idx]),
                      );
                      var ret = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BlocProvider<Getkapster>.value(
                              value: Getkapster(kaps),
                              child: BlocProvider<InsertDet>.value(
                                value: InsertDet(0.0),
                                child: pilKapster,
                              ),
                            );
                          });
                      if (ret == true) {
                        AlertDialog AddItemDone = AlertDialog(
                            title: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Berhasil menambahkan item",
                                style: TextStyle(
                                  color: FitnessAppTheme.tosca,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            content: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_outlined,
                                    color: FitnessAppTheme.tosca,
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  Text(dt_item[idx].kat_nama +
                                      " " +
                                      dt_item[idx].prod_nama)
                                ],
                              ),
                            ));
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddItemDone;
                            });
                      } else {
                        print("fail");
                      }
                    },
                    child: Card(
                      color: FitnessAppTheme.white,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 5, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dt_item[idx].kat_nama,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: FitnessAppTheme.grey),
                                ),
                                Text(
                                  dt_item[idx].prod_nama,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            Text(
                              NumFormat.format(dt_item[idx].prod_price)
                                  .toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchPelanggan extends StatefulWidget {
  final ValueChanged<int> tabnavigator;
  const SearchPelanggan(this.tabnavigator);
  @override
  _SearchPelangganState createState() => _SearchPelangganState();
}

class _SearchPelangganState extends State<SearchPelanggan> {
  TextEditingController txtcariplg = TextEditingController();
  List<pelanggan> listplg;

  @override
  Widget build(BuildContext context) {
    Getpelanggan bloc_plg = BlocProvider.of<Getpelanggan>(context);
    return Container(
        padding: EdgeInsets.all(8),
        color: FitnessAppTheme.tosca,
        child: BlocBuilder<Getpelanggan, List<pelanggan>>(
          builder: (context, dt_plg) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 10,
                    child: Card(
                        color: FitnessAppTheme.white,
                        child: TextFormField(
                          controller: txtcariplg,
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Nama / No.HP Pelanggan",
                            contentPadding: EdgeInsets.all(8),
                            prefixIcon: Icon(
                              Icons.search,
                              color: FitnessAppTheme.tosca,
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          onChanged: (val) {
                            Future.delayed(Duration(milliseconds: 500), () {
                              bloc_plg.add(val);
                            });
                          },
                        )),
                  ),
                  Flexible(
                    flex: 2,
                    child: FlatButton(
                        padding: EdgeInsets.all(0),
                        height: 48,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: FitnessAppTheme.yellow,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InputPelanggan(
                                        fromkasir: 1,
                                      )));
                        },
                        child: Icon(
                          Icons.person_add,
                          size: 30,
                          color: FitnessAppTheme.white,
                        )),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: (dt_plg == null) ? 0 : dt_plg.length,
                  itemBuilder: (context, idx) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          global_var.kasirpelanggan = pelanggan(
                              dt_plg[idx].pelanggan_nama,
                              dt_plg[idx].pelanggan_hp,
                              dt_plg[idx].pelanggan_alamat);
                          global_var.kasirpelanggan
                              .setId(dt_plg[idx].pelanggan_id);
                        });
                        widget.tabnavigator(2);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dt_plg[idx].pelanggan_nama,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    dt_plg[idx].pelanggan_hp.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: FitnessAppTheme.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class KasirCheckout extends StatefulWidget {
  final ValueChanged<int> tabnavigator;
  KasirCheckout(this.tabnavigator);
  @override
  _KasirCheckoutState createState() => _KasirCheckoutState();
}

class _KasirCheckoutState extends State<KasirCheckout> {
  String _newInvNo;
  PrinterBluetoothManager _printManager = PrinterBluetoothManager();
  BluetoothManager _bluetoothManager = BluetoothManager.instance;
  var NumFormat = new NumberFormat.decimalPattern("id");
  global_var gb = global_var();
  DateTime selectedDate = DateTime.now();
  final formatter = new DateFormat.yMMMMd();
  final _nominal = NumberFormat.compact(locale: "en");
  String _nama_bisnis = "";
  String _alamat_bisnis = "";
  String _ket_bisnis = "";
  String _terimakasih = "";
  String _default_printer = "";
  @override
  void initState() {
    // TODO: implement initState
    global_var.isSaved = 0;
    _newInvNo = "INV" + DateTime.now().millisecondsSinceEpoch.toString();
    gb.getPref("nama_bisnis").then((val) {
      _nama_bisnis = val;
      setState(() {});
    });
    gb.getPref("alamat_bisnis").then((val) {
      _alamat_bisnis = val;
      setState(() {});
    });
    gb.getPref("ket_bisnis").then((val) {
      _ket_bisnis = val;
      setState(() {});
    });
    gb.getPref("terimakasih_nota").then((val) {
      _terimakasih = val;
      setState(() {});
    });
    gb.getPref("printer_id").then((val) {
      _default_printer = val;
      setState(() {});
    });
    gb.getPref("cetak_nota").then((val) {
      global_var.cetak_nota = (val == "1");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    CreateNota _creatorNota = BlocProvider.of<CreateNota>(context);
    CreateBukuKas _creatorBukukas = BlocProvider.of<CreateBukuKas>(context);
    return Container(
      padding: EdgeInsets.all(10),
      color: FitnessAppTheme.tosca,
      child: ListView(
        children: [
          Card(
            elevation: 3,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text((_nama_bisnis) ?? "Bisnis-ku",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text((_alamat_bisnis) ?? "Alamat"),
                  Text((_ket_bisnis) ?? "-"),
                  Padding(padding: EdgeInsets.all(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "No.Inv",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text("Tgl", style: TextStyle(fontSize: 16)),
                          Text("Pelanggan", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_newInvNo, style: TextStyle(fontSize: 16)),
                          GestureDetector(
                              onTap: () async {
                                final DateTime picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate, // Refer step 1
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2025),
                                  cancelText: "Batal",
                                  confirmText: "Pilih",
                                );
                                if (picked != null && picked != selectedDate) {
                                  selectedDate = picked;
                                  setState(() {});
                                }
                              },
                              child: Text("${formatter.format(selectedDate)}",
                                  style: TextStyle(fontSize: 16))),
                          GestureDetector(
                              onTap: () {
                                widget.tabnavigator(1);
                              },
                              child: Text(
                                ((global_var.kasirpelanggan == null)
                                    ? "Pilih Pelanggan"
                                    : global_var.kasirpelanggan.pelanggan_nama),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: FitnessAppTheme.nearlyBlue),
                              )),
                        ],
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Table(
                    border: TableBorder(
                      top: BorderSide(width: 1),
                    ),
                    columnWidths: {
                      0: FractionColumnWidth(0.5),
                      1: FractionColumnWidth(0.2),
                      2: FractionColumnWidth(0.3)
                    },
                    children: [
                      TableRow(
                          //table header
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            //                   <--- left side
                            color: Colors.black,
                            width: 1.0,
                          ))),
                          children: [
                            Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text(
                                  "Item",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text("Qty",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text("Nominal",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600))),
                          ]),
                      if (global_var.detailkasir != null)
                        for (int idx = 0;
                            idx < global_var.detailkasir.length;
                            idx++)
                          TableRow(children: [
                            Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          child: Icon(
                                            CupertinoIcons.delete_right_fill,
                                            size: 20,
                                            color: FitnessAppTheme.redtext,
                                          ),
                                          onTap: () async {
                                            global_var.total -= global_var
                                                .detailkasir[idx].invdet_total;
                                            await global_var.detailkasir
                                                .removeAt(idx);
                                            setState(() {
                                              global_var.kembalian =
                                                  global_var.pembayaran +
                                                      global_var.diskon -
                                                      global_var.total;
                                            });
                                          },
                                        ),
                                        Flexible(
                                          child: Text(
                                              global_var.detailkasir[idx]
                                                      .invdet_kat_nama +
                                                  " " +
                                                  global_var.detailkasir[idx]
                                                      .invdet_prod_nama,
                                              style: TextStyle(fontSize: 18)),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        "Oleh : " +
                                            (global_var.detailkasir[idx]
                                                    .invdet_kapster_name ??
                                                "-"),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: FitnessAppTheme.grey)),
                                    Text(global_var.detailkasir[idx].invdet_ket,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: FitnessAppTheme.grey))
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                  NumFormat.format(global_var
                                          .detailkasir[idx].invdet_qty)
                                      .toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18)),
                            ),
                            Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text(
                                    NumFormat.format(global_var
                                        .detailkasir[idx].invdet_total),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 18))),
                          ]),
                      TableRow(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),bottom: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          )),color: FitnessAppTheme.tosca.withOpacity(0.4)),
                          children: [
                            Text("Total",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 18,
                                        )),
                           Text(
                                  (global_var.detailkasir == null)
                                      ? "0"
                                      : global_var.detailkasir.length
                                          .toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,)),
                           
                           Text(NumFormat.format(global_var.total),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 18,)),
                          ]),
                      TableRow(children: [
                        Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Text("Potongan",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 18,))),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text("",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,)),
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.all(0.0),
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: FitnessAppTheme.tosca,
                                  ),
                                  Text(
                                      NumFormat.format(
                                          (global_var.diskon ?? 0)),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                              onTap: () async {
                                AlertDialog inputPot = AlertDialog(
                                  title: Text("Potongan"),
                                  content: InputPotongan(),
                                );
                                var setpot = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return inputPot;
                                    });

                                if (setpot) {
                                  setState(() {});
                                }
                              },
                            )),
                      ]),
                      TableRow(children: [
                        Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Text(
                                "Pembayaran",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 18,))),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text("",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18)),
                        ),
                        Padding(
                            padding: EdgeInsets.all(0.0),
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: FitnessAppTheme.tosca,
                                  ),
                                  Text(
                                      NumFormat.format(
                                          (global_var.pembayaran ?? 0)),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 18,)),
                                ],
                              ),
                              onTap: () async {
                                AlertDialog inputBayar = AlertDialog(
                                  title: Text("Pembayaran"),
                                  content: InputBayar(),
                                );
                                var paid = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return inputBayar;
                                    });

                                if (paid == true) {
                                  setState(() {});
                                }
                              },
                            )),
                      ]),
                      TableRow(
                        children: [
                        Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Text(
                                (global_var.kembalian >= 0)
                                    ? "Kembali"
                                    : "Kurang",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 18,))),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text("",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Text(
                              NumFormat.format((global_var.kembalian).abs()),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 18,)),
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(8)),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.teal[300].withOpacity(0.7),
                shape: StadiumBorder(),
                elevation: 3
              ),              
              onPressed: () async {
                if (global_var.kasirpelanggan == null) {
                  AlertDialog _savealert = AlertDialog(
                    backgroundColor: Colors.red[900],
                    title: Text(
                      "Simpan Gagal",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: FitnessAppTheme.white),
                    ),
                    content: Container(
                      child: Text("Harap memilih pelanggan",
                          style: TextStyle(color: FitnessAppTheme.white)),
                    ),
                  );
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _savealert;
                      });
                } else if (global_var.kembalian < 0) {
                  AlertDialog _savealert = AlertDialog(
                    backgroundColor: Colors.red[900],
                    title: Text(
                      "Simpan Gagal",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: FitnessAppTheme.white),
                    ),
                    content: Container(
                      child: Text(
                        "Harap Input Pembayaran",
                        style: TextStyle(color: FitnessAppTheme.white),
                      ),
                    ),
                  );
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _savealert;
                      });
                } else {
                  if (global_var.isSaved == 0) {
                    invoice newInvoice = invoice(
                        _newInvNo,
                        formatter.format(selectedDate),
                        global_var.kasirpelanggan.pelanggan_id,
                        global_var.total,
                        global_var.diskon,
                        global_var.total - global_var.diskon,
                        selectedDate.millisecondsSinceEpoch,
                        0,
                        0,
                        details: global_var.detailkasir);
                    _creatorNota.add(newInvoice); // Simpan Nota
                    double total_bayar = (global_var.pembayaran >
                            global_var.total - global_var.diskon)
                        ? global_var.total - global_var.diskon
                        : global_var.pembayaran;
                    bukukasdet _bukukasdet = bukukasdet(
                        ((global_var.isTunai == 1) ? total_bayar : 0),
                        ((global_var.isTunai == 0) ? total_bayar : 0),
                        "Penjualan Nota : $_newInvNo",
                        selectedDate.millisecondsSinceEpoch,
                        selectedDate.millisecondsSinceEpoch,
                        0);

                    bukukas _bukukas = bukukas(
                        ((global_var.isTunai == 1) ? total_bayar : 0),
                        ((global_var.isTunai == 0) ? total_bayar : 0),
                        DateTime(selectedDate.year, selectedDate.month,
                                selectedDate.day, 0, 0, 0, 0)
                            .millisecondsSinceEpoch, //get today at 00:00:00
                        DateTime(selectedDate.year, selectedDate.month,
                                selectedDate.day, 0, 0, 0, 0)
                            .millisecondsSinceEpoch, //get today at 00:00:00
                        0,
                        detail_bukukas: _bukukasdet);
                    _creatorBukukas.add(_bukukas); // saving buku kas
                    global_var.isSaved = 1;
                    setState(() {});
                    AlertDialog _savealert = AlertDialog(
                      title: Text(
                        "Transaksi Tersimpan",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      content: Container(
                        height: MediaQuery.of(context).size.height / 15,
                        child: Text("Transaksi berhasil disimpan"),
                      ),
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _savealert;
                        });
                  }
                  if (global_var.cetak_nota) {
                    _search_print();
                  } else {
                    //print("tidak perlu cetak");
                    gb.ClearKasir();
                    setState(() {});

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Kasir()));
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_rounded),
                    Text(
                      " Simpan Transaksi",
                      style: TextStyle(fontSize: 20.0, color: FitnessAppTheme.white),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Future<void> _search_print() async {
    _bluetoothManager.state.listen((val) {
      if (!mounted) return;
      if (val == 10) {
        AlertDialog checkbluetooth = AlertDialog(
          title: Text(
            "Bluetooth Nonaktif",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 15,
            child: Text(
                "Harap aktifkan Bluetooth anda untuk terhubung ke printer, jika Anda ingin mencetak nota"),
          ),
          actions: [
            FlatButton(
                onPressed: null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: FitnessAppTheme.yellow,
                child: Text("Tidak Mencetak"))
          ],
        );
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return checkbluetooth;
            });
      } else if (val == 12) {
        if (global_var.default_printer == null) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => CariPrinter()))
              .then((value) {
            if (global_var.default_printer != null)
              _startPrint(global_var.default_printer).then((value) {
                gb.ClearKasir();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Kasir()));
              });
          });
        } else {
          _startPrint(global_var.default_printer).then((value) {
            gb.ClearKasir();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Kasir()));
          });
        }
      }
    });
  }

  Future<void> _startPrint(PrinterBluetooth selprinter) async {
    _printManager.selectPrinter(selprinter);
    final hasil_print =
        await _printManager.printTicket(await _createNota(PaperSize.mm58));
  }

  Future<Ticket> _createNota(PaperSize paper) async {
    final ticket = Ticket(paper);

    ticket.text(
      (_nama_bisnis) ?? "Bisnis-ku",
      styles: PosStyles(
          align: PosAlign.center,
          height: (_nama_bisnis.length < 13)
              ? PosTextSize.size2
              : PosTextSize.size1,
          width: (_nama_bisnis.length < 13)
              ? PosTextSize.size2
              : PosTextSize.size1,
          bold: true,
          fontType: PosFontType.fontA),
      linesAfter: 1,
    ); //judul
    ticket.text(((_alamat_bisnis) ?? "Alamat") + "\n" + ((_ket_bisnis) ?? ""),
        styles: PosStyles(
            align: PosAlign.center, width: PosTextSize.size1)); //Alamat Telp
    ticket.emptyLines(1);
    ticket.row([
      PosColumn(
        text: 'No.Inv',
        width: 4,
      ),
      PosColumn(
        text: _newInvNo,
        width: 8,
      ),
    ]);
    ticket.row([
      PosColumn(
        text: 'Tgl',
        width: 4,
      ),
      PosColumn(
        text: formatter.format(selectedDate),
        width: 8,
      ),
    ]);
    ticket.row([
      PosColumn(
        text: 'Cust',
        width: 4,
      ),
      PosColumn(
        text: global_var.kasirpelanggan.pelanggan_nama,
        width: 8,
      ),
    ]);
    ticket.hr();
    for (var i = 0; i < global_var.detailkasir.length; i++) {
      String layanan =
          (_nominal.format(global_var.detailkasir[i].invdet_qty).toString() +
                  "x " +
                  global_var.detailkasir[i].invdet_kat_nama +
                  " " +
                  global_var.detailkasir[i].invdet_prod_nama)
              .padRight(28, " ")
              .substring(0, 28);
      String harga = _nominal
          .format(global_var.detailkasir[i].invdet_total)
          .toString()
          .padLeft(4, " ");
      ticket.row([
        PosColumn(
          text: layanan + harga,
          width: 12,
        )
      ]);
    }
    ticket.hr();
    String Total = ("Total : ").padLeft(28, " ") +
        _nominal.format(global_var.total).toString().padLeft(4, " ");
    ticket.text(Total,
        styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1));
    if (global_var.diskon > 0) {
      Total = ("Potongan : ").padLeft(28, " ") +
          _nominal.format(global_var.diskon).toString().padLeft(4, " ");
      ticket.text(Total,
          styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1));
    }
    Total = ("Pembayaran : ").padLeft(28, " ") +
        _nominal.format(global_var.pembayaran).toString().padLeft(4, " ");
    ticket.text(Total,
        styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1));

    Total = ("Kembali : ").padLeft(28, " ") +
        _nominal
            .format((global_var.kembalian < 0) ? 0 : global_var.kembalian)
            .toString()
            .padLeft(4, " ");

    ticket.emptyLines(1);
    ticket.text((_terimakasih) ?? "-Terima Kasih-",
        styles: PosStyles(align: PosAlign.center, width: PosTextSize.size1));

    ticket.cut();
    return ticket;
  }
}

class PilihKapster extends StatefulWidget {
  final ValueChanged<int> tabnavigator;
  final produk add_prod;
  const PilihKapster(this.tabnavigator, this.add_prod);
  @override
  _PilihKapsterState createState() => _PilihKapsterState();
}

class _PilihKapsterState extends State<PilihKapster> {
  final f = NumberFormat("#,###", "id");
  int selectedkapster;
  kapster detkapster;
  TextEditingController txtketItem = TextEditingController();
  TextEditingController txtQty = TextEditingController();
  TextEditingController txtHarga = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    FocusManager.instance.primaryFocus.unfocus();
    Future.delayed(Duration.zero, () {
      Getkapster bloc = BlocProvider.of<Getkapster>(context);
      bloc.add("");
    });
    setState(() {
      txtQty.text = "1";
      txtHarga.text = f.format(widget.add_prod.prod_price);
    });
  }

  @override
  Widget build(BuildContext context) {
    InsertDet _insertDet = BlocProvider.of<InsertDet>(context);

    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      child: BlocBuilder<Getkapster, List<kapster>>(
        builder: (context, snapshot) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Harga ",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: txtHarga,
                    inputFormatters: [NumericTextFormatter()],
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    minLines: 1, //Normal textInputField will be displayed
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "Harga"),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Qty ",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: txtQty,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    minLines: 1, //Normal textInputField will be displayed
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "Qty"),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pegawai ",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField<int>(
                      elevation: 3,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      isExpanded: true,
                      value: selectedkapster,
                      items: (snapshot == null)
                          ? []
                          : snapshot.map((item) {
                              return DropdownMenuItem(
                                child: Text(
                                  item.kapster_nama,
                                  style: TextStyle(fontSize: 18),
                                ),
                                value: (item.kapster_id == null)
                                    ? 0
                                    : item.kapster_id,
                              );
                            }).toList(),
                      hint: Text("Pilih Pegawai"),
                      onChanged: (selItem) {
                        setState(() {
                          selectedkapster = selItem;
                          detkapster = snapshot[snapshot
                              .indexWhere((dt) => dt.kapster_id == selItem)];
                        });
                      }),
                ),
              ],
            ),
            TextFormField(
              controller: txtketItem,
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              minLines: 3, //Normal textInputField will be displayed
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(hintText: "Catatan"),
            ),
            Padding(padding: EdgeInsets.all(6)),
            FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                onPressed: () async {
                  //add to list
                  // double qty = ;
                  produk _prod = widget.add_prod;
                  int _date = DateTime.now().microsecondsSinceEpoch;
                  double harga =
                      double.parse((txtHarga.text).replaceAll(".", ""));
                  invoicedet itemdet = await invoicedet(
                      0,
                      _prod.prod_id,
                      txtketItem.text.toString(),
                      double.parse(txtQty.text),
                      harga,
                      harga * double.parse(txtQty.text),
                      _prod.komisi_kat /
                          100 *
                          harga *
                          double.parse(txtQty.text),
                      selectedkapster,
                      _date,
                      0,
                      0,
                      invdet_prod_nama: _prod.prod_nama,
                      invdet_kapster_name:
                          (detkapster != null) ? detkapster.kapster_nama : "",
                      invdet_kat_nama: _prod.kat_nama,
                      invdet_kat_komisi: _prod.komisi_kat);
                  _insertDet.add(itemdet);
                  Navigator.of(context).pop(true);
                  // widget.tabnavigator(2);
                },
                color: FitnessAppTheme.tosca,
                child: Text(
                  "Tambah Ke List",
                  style:
                      TextStyle(fontSize: 18.0, color: FitnessAppTheme.white),
                ))
          ],
        ),
      ),
    );
  }
}

class InputPotongan extends StatefulWidget {
  @override
  _InputPotonganState createState() => _InputPotonganState();
}

class _InputPotonganState extends State<InputPotongan> {
  TextEditingController txtPot = TextEditingController();
  final f = NumberFormat("#,###", "id");

  @override
  void initState() {
    // TODO: implement initState
    txtPot.text = f.format((global_var.diskon ?? 0).round()).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            controller: txtPot,
            style: TextStyle(fontSize: 22.0, color: Colors.black),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Pembayaran"),
          ),
          Padding(padding: EdgeInsets.all(5)),
          FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              onPressed: () {
                setState(() {
                  global_var.diskon = double.parse((txtPot.text == "")
                      ? 0
                      : txtPot.text.replaceAll(".", ""));
                  global_var.kembalian = global_var.pembayaran +
                      global_var.diskon -
                      global_var.total;
                });

                Navigator.of(context).pop(true);
              },
              color: FitnessAppTheme.tosca,
              child: Text(
                "Potongan",
                style: TextStyle(fontSize: 18.0, color: FitnessAppTheme.white),
              ))
        ],
      ),
    );
  }
}

class InputBayar extends StatefulWidget {
  @override
  _InputBayarState createState() => _InputBayarState();
}

class _InputBayarState extends State<InputBayar> {
  TextEditingController txtbayar = TextEditingController();
  bool isTunai = true;
  final f = NumberFormat("#,###", "id");

  @override
  void initState() {
    // TODO: implement initState
    txtbayar.text = f.format((global_var.pembayaran ?? 0).round()).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Tunai",
                style: TextStyle(fontSize: 18),
              ),
              // Switch(
              //     activeColor: FitnessAppTheme.tosca,
              //     inactiveTrackColor: FitnessAppTheme.nearlyBlack,
              //     inactiveThumbColor: FitnessAppTheme.grey,
              //     value: isTunai,
              //     onChanged: (newVal) {
              //       setState(() {
              //         isTunai = newVal;
              //       });
              //     }),
            ],
          ),
          TextFormField(
            controller: txtbayar,
            inputFormatters: [NumericTextFormatter()],
            style: TextStyle(fontSize: 22.0, color: Colors.black),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Pembayaran"),
          ),
          Padding(padding: EdgeInsets.all(5)),
          FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              onPressed: () {
                setState(() {
                  global_var.pembayaran = double.parse((txtbayar.text == "")
                      ? 0
                      : txtbayar.text.replaceAll(".", ""));
                  global_var.isTunai = (isTunai) ? 1 : 0;
                  global_var.kembalian = global_var.pembayaran +
                      global_var.diskon -
                      global_var.total;
                });
                Navigator.of(context).pop(true);
              },
              color: FitnessAppTheme.tosca,
              child: Text(
                "Bayar",
                style: TextStyle(fontSize: 18.0, color: FitnessAppTheme.white),
              ))
        ],
      ),
    );
  }
}
