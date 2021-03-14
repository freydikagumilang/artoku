import 'package:artoku/global_var.dart';
import 'package:artoku/ui_view/bukukas/bukukas.dart';
import 'package:artoku/ui_view/intro.dart';
import 'package:artoku/ui_view/reports/lapkomisi.dart';
import 'package:artoku/ui_view/reports/lappenjualan.dart';
import 'package:flutter/material.dart';
import 'package:artoku/homescreen.dart';
import 'package:artoku/ui_view/masterdata/kapster.dart';
import 'package:artoku/ui_view/masterdata/pelanggan.dart';
import 'package:artoku/ui_view/produk/produk.dart';
import 'package:artoku/ui_view/produk/kategori.dart';
import 'package:artoku/ui_view/sysconfig/sysconfig.dart';
import 'package:artoku/ui_view/transaksi/kasir.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  final int tab_id;
  final DateTime datetime;
  MyApp({this.tab_id = -1, this.datetime = null});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int mytab = 0;
  global_var gb = global_var();
  @override
  void initState() {

    if(gb.getPref("nama_bisnis")!=null && gb.getPref("alamat_bisnis")!=null && 
      gb.getPref("ket_bisnis")!=null && gb.getPref("terimakasih_nota")!=null && widget.tab_id==-1){
        mytab=-1;
    }
    print(mytab);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/dashboard': (context) => new MyApp(
                tab_id: 0,
                datetime: widget.datetime,
              ), //Kategori(),
          '/masterdata': (context) => new MyApp(
                tab_id: 1,
              ), //Kategori(),
          '/menulaporan': (context) => new MyApp(
                tab_id: 3,
              ), //Kategori(),
          '/sysconfig': (context) => new SysConfig(), //Kategori(),
          '/company_profile': (context) => new CompanyConfig(), //Kategori(),
          '/printer_config': (context) => new PrinterConfig(), //Kategori(),
          '/database_config': (context) => new DatabaseConfig(), //Kategori(),
          '/kategori': (context) => new Kategori(), //Kategori(),
          '/produk': (context) => new Produk(), //Produk(),
          '/pelanggan': (context) => new Pelanggan(),
          '/kapster': (context) => new Kapster(),
          '/kasir': (context) => new Kasir(),
          '/bukukas': (context) => new BukuKas(),
          '/lappenjualan': (context) => new LapPenjualan(),
          '/lapkomisi': (context) => new LapKomisi(),
        },
        theme: ThemeData(
            cursorColor: Colors.grey,
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(primary: Colors.tealAccent[700]),
            textSelectionColor: Colors.grey,
            fontFamily: 'Nunito'),
        home: (mytab==-1)?IntroPageView():HomeScreen(
          tab_id: mytab,
          datetime: widget.datetime,
        ),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
