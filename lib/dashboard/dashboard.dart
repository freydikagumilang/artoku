import 'package:artoku/bloc/blockasir.dart';
import 'package:artoku/models/kasirmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:artoku/bloc/blockas.dart';
import 'package:artoku/dashboard/dashboardchart.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/main.dart';
import 'package:artoku/models/kasmodel.dart';

class Dashboard extends StatefulWidget {
  final DateTime dt;
  Dashboard({this.dt});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime selectedDate = DateTime.now();
  var formatter = new DateFormat.yMMMMd();
  List<bukukas> _initbk;
  List<int> myint;
  List<invoicedet> _initinvdet;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.dt != null) {
      selectedDate = widget.dt;
    }
    myint = [
      DateTime(
              selectedDate.subtract(Duration(days: 1)).year,
              selectedDate.subtract(Duration(days: 1)).month,
              selectedDate.subtract(Duration(days: 1)).day,
              0,
              0,
              0,
              0,
              0)
          .millisecondsSinceEpoch,
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0,
              0)
          .millisecondsSinceEpoch
    ];
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    GetDateSaldo mybloc = GetDateSaldo(_initbk);
    PageController _chartPage = PageController(initialPage: 1);
    return Container(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<GetDateSaldo>(
              create: (context) => GetDateSaldo(_initbk)),
          BlocProvider<GetCommissionBydate>(
              create: (context) => GetCommissionBydate(_initinvdet)),
        ],
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
          color: FitnessAppTheme.tosca,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  final DateTime picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate, // Refer step 1
                    firstDate: DateTime(2021),
                    lastDate: DateTime(DateTime.now().year+1),
                    cancelText: "Batal",
                    confirmText: "Pilih",
                  );
                  if (picked != null && picked != selectedDate) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyApp(
                                  tab_id: 0,
                                  datetime: picked,
                                )));
                  }
                },
                child: Text(
                  "${formatter.format(selectedDate)}",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: FitnessAppTheme.white),
                ),
              ),
              CashBalance(myint),
              AllChart(selectedDate),
              CommissionDailySum(selectedDate)
            ],
          ),
        ),
      ),
    ));
  }
}

class CashBalance extends StatefulWidget {
  final List<int> dtunixtime;
  CashBalance(this.dtunixtime);
  @override
  _CashBalanceState createState() => _CashBalanceState();
}

class _CashBalanceState extends State<CashBalance> {
  var NumCompact = new NumberFormat.compact(locale: "id");
  var NumDec = new NumberFormat.decimalPattern("id");
  double growth = 0;
  double saldo = 0;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      GetDateSaldo bloc = BlocProvider.of<GetDateSaldo>(context);
      bloc.add(widget.dtunixtime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 3,
          color: FitnessAppTheme.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: BlocBuilder<GetDateSaldo, List<bukukas>>(
                builder: (context, dt_saldo) {
              if (dt_saldo != null) {
                saldo = dt_saldo[1].bukukas_tunai;
                growth = dt_saldo[1].bukukas_tunai - dt_saldo[0].bukukas_tunai;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Saldo Kas",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: "SFProDisplay",
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    NumDec.format(saldo),
                    style: TextStyle(
                      fontSize: 40.0,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        (growth > 0)
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: (growth > 0)
                            ? FitnessAppTheme.greentext
                            : FitnessAppTheme.redtext,
                        size: 40,
                      ),
                      Text(
                        ((growth > 0) ? "Naik " : "Turun ") +
                            NumDec.format(growth.abs()),
                        style: TextStyle(
                          fontSize: 18.0,
                          color: (growth > 0)
                              ? FitnessAppTheme.greentext
                              : FitnessAppTheme.redtext,
                        ),
                      )
                    ],
                  ),
                ],
              );
            }),
          ),
        ));
  }
}

class CommissionDailySum extends StatefulWidget {
  final DateTime datetime;
  CommissionDailySum(this.datetime);
  @override
  _CommissionDailySumState createState() => _CommissionDailySumState();
}

class _CommissionDailySumState extends State<CommissionDailySum> {
  var NumCompact = new NumberFormat.compact(locale: "id");
  double total_job = 0;
  double total_komisi = 0;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      DateTimeRange dtrange = DateTimeRange(
          start: DateTime(widget.datetime.year, widget.datetime.month,
              widget.datetime.day, 0, 0, 0, 0),
          end: DateTime(widget.datetime.year, widget.datetime.month,
              widget.datetime.day, 23, 59, 59, 0));
      GetCommissionBydate bloc = BlocProvider.of<GetCommissionBydate>(context);
      bloc.add(dtrange);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 3,
        color: FitnessAppTheme.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<GetCommissionBydate, List<invoicedet>>(
              builder: (context, invdet) {
            if (invdet != null) {
              total_job=0;
              total_komisi=0;
              for (int idx = 0; idx < invdet.length; idx++) {
                total_job += invdet[idx].invdet_qty;
                total_komisi += invdet[idx].invdet_komisi;
              }
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Komisi Harian",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Table(
                    border: TableBorder(
                      top: BorderSide(width: 1),
                    ),
                    columnWidths: {
                      0: FractionColumnWidth(0.4),
                      1: FractionColumnWidth(0.3),
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
                                  "Pegawai",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text("Pekerjaan",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Text("Komisi",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600))),
                          ]),
                      if (invdet != null)
                        for (int idx = 0; idx < invdet.length; idx++)
                          TableRow(children: [
                            Container(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                invdet[idx].invdet_kapster_name,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 8),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    NumCompact.format(invdet[idx].invdet_qty),
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 8),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  NumCompact.format(invdet[idx].invdet_komisi),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                          ]),
                      TableRow(
                          //table header
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                            //                   <--- left side
                            color: Colors.black,
                            width: 1.0,
                          ))),
                          children: [
                            Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "Total",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(NumCompact.format(total_job),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(NumCompact.format(total_komisi),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600))),
                          ]),
                    ]),
              ],
            );
          }),
        ),
      ),
    );
  }
}
