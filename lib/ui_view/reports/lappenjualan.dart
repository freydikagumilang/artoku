import 'package:artoku/main.dart';
import 'package:artoku/models/kasirmodel.dart';
import 'package:artoku/ui_view/template/frxappbar.dart';
import 'package:flutter/material.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:artoku/bloc/blockasir.dart';

class LapPenjualan extends StatefulWidget {
  @override
  _LapPenjualanState createState() => _LapPenjualanState();
}

class _LapPenjualanState extends State<LapPenjualan> {
  List<invoice> _initListInvoices;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context, rootNavigator: true).pushNamed("/menulaporan");
        },
        child: Scaffold(
            backgroundColor: FitnessAppTheme.tosca,
            appBar: FrxAppBar("Laporan Penjualan", backroute: "/menulaporan"),
            body: BlocProvider<GetSalesDataPeriodic>(
                create: (BuildContext context) =>
                    GetSalesDataPeriodic(_initListInvoices),
                child: Container(
                    padding: EdgeInsets.all(8), child: ResultLapPenjualan()))));
  }
}

class ResultLapPenjualan extends StatefulWidget {
  @override
  _ResultLapPenjualanState createState() => _ResultLapPenjualanState();
}

class _ResultLapPenjualanState extends State<ResultLapPenjualan> {
  DateTime _now = DateTime.now();
  DateTimeRange selectedDate;
  var formatter = new DateFormat.yMMMMd();
  var NumCompact = new NumberFormat.compactLong(locale: "id");
  double total_jual = 0, total_komisi = 0, total_laba = 0;
  @override
  void initState() {
    // TODO: implement initState
    selectedDate = DateTimeRange(
        start: DateTime(_now.year, _now.month, _now.day, 0, 0, 0, 0, 0),
        end: DateTime(_now.year, _now.month, _now.day, 23, 59, 59, 0, 0));

    Future.delayed(Duration.zero, () {
      GetSalesDataPeriodic _bloc =
          BlocProvider.of<GetSalesDataPeriodic>(context);
      _bloc.add(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    GetSalesDataPeriodic _bloc = BlocProvider.of<GetSalesDataPeriodic>(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          BlocBuilder<GetSalesDataPeriodic, List<invoice>>(
            builder: (context, inv) {
              total_jual = 0; 
              total_komisi = 0; 
              total_laba = 0;
              if (inv != null)
                for (int idx = 0; idx < inv.length; idx++) {
                  total_jual += inv[idx].inv_total_net;
                  total_komisi += inv[idx].totalkomisi;
                  total_laba += inv[idx].inv_total_net - inv[idx].totalkomisi;
                }
              return Table(
                border: TableBorder(
                  top: BorderSide(width: 1, color: FitnessAppTheme.white),
                ),
                columnWidths: {
                  0: FractionColumnWidth(0.4),
                  1: FractionColumnWidth(0.2),
                  2: FractionColumnWidth(0.2),
                  3: FractionColumnWidth(0.2),
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
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: FitnessAppTheme.white,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("Total",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: FitnessAppTheme.white,
                              )),
                        ),
                        Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text("Komisi",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: FitnessAppTheme.white,
                                ))),
                        Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text("Laba",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: FitnessAppTheme.white,
                                ))),
                      ]),
                  if (inv != null)
                    for (int idx = 0; idx < inv.length; idx++)
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
                                    inv[idx].inv_plg_nama,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: FitnessAppTheme.white,
                                    ),
                                  ),
                                  Text(
                                    inv[idx].inv_no,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: FitnessAppTheme.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    NumCompact.format(inv[idx].inv_total_net),
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
                                  NumCompact.format(inv[idx].totalkomisi),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: FitnessAppTheme.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 4, 3, 4),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  NumCompact.format(inv[idx].inv_total_net -
                                      inv[idx].totalkomisi),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: FitnessAppTheme.white,
                                  ),
                                ),
                              ),
                            )
                          ]),
                  TableRow(
                    decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                        //                   <--- left side
                        color: FitnessAppTheme.white,
                        width: 1.0,
                      ))),
                    children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(3, 8, 0, 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 18,
                            color: FitnessAppTheme.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            NumCompact.format(total_jual),
                            style: TextStyle(
                              fontSize: 18,
                              color: FitnessAppTheme.white,
                            ),
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          NumCompact.format(total_komisi),
                          style: TextStyle(
                            fontSize: 18,
                            color: FitnessAppTheme.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 8, 3, 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          NumCompact.format(total_laba),
                          style: TextStyle(
                            fontSize: 18,
                            color: FitnessAppTheme.white,
                          ),
                        ),
                      ),
                    )
                  ])
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
