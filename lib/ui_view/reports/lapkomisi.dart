import 'package:artoku/main.dart';
import 'package:artoku/models/kapstermodel.dart';
import 'package:artoku/models/kasirmodel.dart';
import 'package:artoku/ui_view/masterdata/kapster.dart';
import 'package:artoku/ui_view/template/frxappbar.dart';
import 'package:flutter/material.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:artoku/bloc/blockasir.dart';

class LapKomisi extends StatefulWidget {
  @override
  _LapKomisiState createState() => _LapKomisiState();
}

class _LapKomisiState extends State<LapKomisi> {
  @override
  Widget build(BuildContext context) {
    List<invoicedet> _initListInvdet;
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context, rootNavigator: true).pushNamed("/menulaporan");
        },
        child: Scaffold(
            backgroundColor: FitnessAppTheme.tosca,
            appBar: FrxAppBar("Laporan Komisi Penjualan",
                backroute: "/menulaporan"),
            body: BlocProvider<GetCommissionBydate>(
                create: (BuildContext context) =>
                    GetCommissionBydate(_initListInvdet),
                child: Container(
                    padding: EdgeInsets.all(8), child: ResultLapKomisi()))));
  }
}

class ResultLapKomisi extends StatefulWidget {
  @override
  _ResultLapKomisiState createState() => _ResultLapKomisiState();
}

class _ResultLapKomisiState extends State<ResultLapKomisi> {
  DateTime _now = DateTime.now();
  DateTimeRange selectedDate;
  var formatter = new DateFormat.yMMMMd();
  var NumCompact = new NumberFormat.compactLong(locale: "id");
  double total_jual = 0, total_komisi = 0;

  @override
  void initState() {
    selectedDate = DateTimeRange(
        start: DateTime(_now.year, _now.month, _now.day, 0, 0, 0, 0, 0),
        end: DateTime(_now.year, _now.month, _now.day, 23, 59, 59, 0, 0));
    Future.delayed(Duration.zero, () {
      GetCommissionBydate _bloc = BlocProvider.of<GetCommissionBydate>(context);
      _bloc.add(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    GetCommissionBydate _bloc = BlocProvider.of<GetCommissionBydate>(context);
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final DateTimeRange picked = await showDateRangePicker(
                  context: context,
                  initialDateRange: DateTimeRange(
                      start: selectedDate.start, end: selectedDate.end),
                  firstDate: DateTime(2019),
                  lastDate: DateTime.now().add(Duration(days: 1)),
                  confirmText: "Pilih",
                  cancelText: "Batal",
                  saveText: "Pilih",
                  helpText: "Pilih Tanggal");
              if (picked != null && picked != selectedDate) {
                selectedDate = picked;
                setState(() {
                  _bloc.add(picked);
                });
              }
            },
            child: Text(
              "${formatter.format(selectedDate.start)} s/d \n${formatter.format(selectedDate.end)}",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: FitnessAppTheme.white),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 25)),
          BlocBuilder<GetCommissionBydate, List<invoicedet>>(
              builder: (context, det) {
            return Table(
                border: TableBorder(
                  top: BorderSide(width: 1, color: FitnessAppTheme.white),
                ),
                columnWidths: {
                  0: FractionColumnWidth(0.4),
                  1: FractionColumnWidth(0.3),
                  2: FractionColumnWidth(0.3),
                },
                children: [
                  TableRow(
                      //table header
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        //                   <--- left side
                        color: FitnessAppTheme.white,
                        width: 1.0,
                      ))),
                      children: [
                        Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              "Pegawai",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: FitnessAppTheme.white,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("Pekerjaan",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: FitnessAppTheme.white,
                              )),
                        ),
                        Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text("Komisi",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: FitnessAppTheme.white,
                                ))),
                      ]),
                  if (det != null)
                    for (int idx = 0; idx < det.length; idx++)
                      TableRow(
                          decoration: new BoxDecoration(
                            color: (idx % 2 == 0)
                                ? FitnessAppTheme.tosca
                                : Colors.white24,
                          ),
                          children: [
                            TableRowInkWell(
                              onTap: () {
                                kapster _dtkapster = new kapster(
                                    det[idx].invdet_kapster_name, "", "");
                                _dtkapster.setId(det[idx].invdet_kapster_id);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailKomisi(
                                            selectedDate, _dtkapster)));
                              },
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(3, 4, 0, 4),
                                  child: Text(
                                    det[idx].invdet_kapster_name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: FitnessAppTheme.white,
                                    ),
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    NumCompact.format(det[idx].invdet_qty),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: FitnessAppTheme.white,
                                    ),
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    NumCompact.format(det[idx].invdet_komisi),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: FitnessAppTheme.white,
                                    ),
                                  )),
                            ),
                          ])
                ]);
          })
        ],
      ),
    );
  }
}

class DetailKomisi extends StatefulWidget {
  DateTimeRange dtr;
  kapster dtkapster;
  DetailKomisi(this.dtr, this.dtkapster);
  @override
  _DetailKomisiState createState() => _DetailKomisiState();
}

class _DetailKomisiState extends State<DetailKomisi> {
  var formatter = new DateFormat.yMMMMd();
  fltKomisiPegawai param;

  List<invoicedet> _initListInvdet;

  @override
  void initState() {
    param = fltKomisiPegawai(widget.dtr, widget.dtkapster);
    //   Future.delayed(Duration.zero, () {
    //     param = fltKomisiPegawai(widget.dtr, widget.dtkapster);
    //     GetSalesbyPegawaiPeriodic _bloc =
    //         BlocProvider.of<GetSalesbyPegawaiPeriodic>(context);
    //     _bloc.add(param);
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FitnessAppTheme.tosca,
        appBar:
            FrxAppBar("Laporan Komisi Penjualan"),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${formatter.format(widget.dtr.start)} s/d \n${formatter.format(widget.dtr.end)}",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: FitnessAppTheme.white),
              ),
              Padding(padding: EdgeInsets.only(bottom: 3)),
              Text(
                "Pegawai : " + widget.dtkapster.kapster_nama,
                style: TextStyle(fontSize: 25, color: FitnessAppTheme.white),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              BlocProvider<GetSalesbyPegawaiPeriodic>(
                  create: (BuildContext context) =>
                      GetSalesbyPegawaiPeriodic(_initListInvdet),
                  child: ResultDetailKomisi(param))
            ],
          ),
        ));
  }
}

class ResultDetailKomisi extends StatefulWidget {
  fltKomisiPegawai dtWhere;
  ResultDetailKomisi(this.dtWhere);
  @override
  _ResultDetailKomisiState createState() => _ResultDetailKomisiState();
}

class _ResultDetailKomisiState extends State<ResultDetailKomisi> {
  var NumCompact = new NumberFormat.compactLong(locale: "id");
  double total_jual = 0, total_komisi = 0;
  void initState() {
    Future.delayed(Duration.zero, () {
      GetSalesbyPegawaiPeriodic _bloc =
          BlocProvider.of<GetSalesbyPegawaiPeriodic>(context);
      _bloc.add(widget.dtWhere);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child:
        BlocBuilder<GetSalesbyPegawaiPeriodic, List<invoicedet>>(
            builder: (context, det) {
              total_komisi=0;
              if (det != null){
                for (int idx = 0; idx < det.length; idx++){
                  total_komisi+=det[idx].invdet_komisi;
                }  
              }
              
      return Table(
          border: TableBorder(
            top: BorderSide(width: 1, color: FitnessAppTheme.white),
          ),
          columnWidths: {
            0: FractionColumnWidth(0.4),
            1: FractionColumnWidth(0.4),
            2: FractionColumnWidth(0.2),
          },
          children: [
            TableRow(
                //table header
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  //                   <--- left side
                  color: FitnessAppTheme.white,
                  width: 1.0,
                ))),
                children: [
                  Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Nota",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: FitnessAppTheme.white,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text("Item",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: FitnessAppTheme.white,
                        )),
                  ),
                  Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text("Komisi",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: FitnessAppTheme.white,
                          ))),
                ]),
            if (det != null)
              for (int idx = 0; idx < det.length; idx++)
                TableRow(
                    decoration: new BoxDecoration(
                      color: (idx % 2 == 0)
                          ? FitnessAppTheme.tosca
                          : Colors.white24,
                    ),
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(3, 4, 0, 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                det[idx].invdet_pelanggan_nama,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: FitnessAppTheme.white,
                                ),
                              ),
                              Text(
                                det[idx].invdet_inv_no,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: FitnessAppTheme.white,
                                ),
                              ),
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              det[idx].invdet_kat_nama +
                                  " " +
                                  det[idx].invdet_prod_nama,
                              style: TextStyle(
                                fontSize: 18,
                                color: FitnessAppTheme.white,
                              ),
                            )),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              NumCompact.format(det[idx].invdet_komisi),
                              style: TextStyle(
                                fontSize: 18,
                                color: FitnessAppTheme.white,
                              ),
                            )),
                      ),
                    ]),
            TableRow(
                //table header
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                          color: FitnessAppTheme.white,
                          width: 1.0,
                        ),
                        bottom: BorderSide(
                          color: FitnessAppTheme.white,
                          width: 1.0,
                        ))),
                children: [
                  Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        "Total Komisi",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: FitnessAppTheme.white,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text("",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: FitnessAppTheme.white,
                        )),
                  ),
                  Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(NumCompact.format(total_komisi),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: FitnessAppTheme.white,
                          ))),
                ]),
          ]);
    }));
  }
}
