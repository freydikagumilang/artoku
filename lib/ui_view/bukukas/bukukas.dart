import 'package:artoku/bloc/blockas.dart';
import 'package:artoku/bloc/blockasir.dart';
import 'package:artoku/global_var.dart';
import 'package:artoku/models/kasmodel.dart';
import 'package:artoku/ui_view/bukukas/input_bukukas.dart';
import 'package:flutter/material.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'package:artoku/main.dart';
import 'package:artoku/ui_view/template/frxappbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BukuKas extends StatefulWidget {
  @override
  _BukuKasState createState() => _BukuKasState();
}

class _BukuKasState extends State<BukuKas> with SingleTickerProviderStateMixin {
  List<bukukasdet> _inidet;

  bool isOpened = false;
  AnimationController _bukukasAnimCtrl;
  Animation<Color> _buttonColor;
  Animation<double> _animIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  List<int> _listtgl = [];
  List<double> _initsaldo = [];
  DateTimeRange selectedDate;
  DateTime _now = DateTime.now();
  @override
  void initState() {
    selectedDate = DateTimeRange(
        start: DateTime(_now.year, _now.month, _now.day, 0, 0, 0, 0, 0),
        end: DateTime(_now.year, _now.month, _now.day, 23, 59, 59, 0, 0));
    _listtgl.add(selectedDate.start.millisecondsSinceEpoch);
    _listtgl.add(selectedDate.end.millisecondsSinceEpoch);

    // TODO: implement initState
    _bukukasAnimCtrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animIcon = Tween<double>(begin: 0.0, end: 1).animate(_bukukasAnimCtrl);
    _buttonColor =
        ColorTween(begin: FitnessAppTheme.yellow, end: FitnessAppTheme.grey)
            .animate(CurvedAnimation(
                parent: _bukukasAnimCtrl,
                curve: Interval(0.0, 1, curve: Curves.linear)));
    _translateButton = Tween<double>(begin: _fabHeight, end: -14.0)
        .animate(CurvedAnimation(parent: _bukukasAnimCtrl, curve: _curve));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bukukasAnimCtrl.dispose();
  }

  //widgets
  Widget buttonAddPendapatan() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btnPendapatan",
        backgroundColor: FitnessAppTheme.white,
        onPressed: () async {
          _bukukasAnimCtrl.reverse();
          AlertDialog _input = AlertDialog(
              title: Text("Input Pendapatan"), content: InputBukuKas(1));

          final saved = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return BlocProvider<CreateBukuKas>.value(
                  value: CreateBukuKas(0),
                  child: _input,
                );
              });
          if(saved!=null){
            Navigator.of(context, rootNavigator: true)
                      .pushNamed("/bukukas");
          };
        },
        tooltip: "Kas Masuk",
        child: Icon(
          Icons.add,
          color: FitnessAppTheme.tosca,
          size: 30,
        ),
      ),
    );
  }

  Widget buttonAddBiaya() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btnBiaya",
        tooltip: "Biaya",
        backgroundColor: FitnessAppTheme.redtext,
        onPressed: () async {
          _bukukasAnimCtrl.reverse();
          AlertDialog _input = AlertDialog(
              title: Text("Input Biaya"), content: InputBukuKas(-1));

          final saved = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return BlocProvider<CreateBukuKas>.value(
                  value: CreateBukuKas(0),
                  child: _input,
                );
              });
          if(saved!=null){
            Navigator.of(context, rootNavigator: true)
                      .pushNamed("/bukukas");
          };
        },
        child: Icon(
          Icons.remove,
          color: FitnessAppTheme.white,
          size: 30,
        ),
      ),
    );
  }

  Widget buttonToggle() {
    return Container(
      child: FloatingActionButton(
          heroTag: "kastoggle",
          backgroundColor: FitnessAppTheme.yellow,
          onPressed: animated,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animIcon,
          ) // Icon(Icons.account_balance_wallet,color:FitnessAppTheme.redtext,size: 30,),
          ),
    );
  }

  void animated() {
    if (!isOpened)
      _bukukasAnimCtrl.forward();
    else
      _bukukasAnimCtrl.reverse();

    isOpened = !isOpened;
  }

  @override
  Widget build(BuildContext context) {
    GetBukuKasDetail _bloc;
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyApp(
                      tab_id: 1,
                    )));
      },
      child: Scaffold(
        backgroundColor: FitnessAppTheme.tosca,
        appBar: FrxAppBar("Buku Kas", backroute: "/dashboard"),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Transform(
              transform: Matrix4.translationValues(
                  0.0, _translateButton.value * 2, 0.0),
              child: buttonAddPendapatan(),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  0.0, _translateButton.value * 1, 0.0),
              child: buttonAddBiaya(),
            ),
            buttonToggle()
          ],
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<GetBukuKasDetail>(
                create: (context) => GetBukuKasDetail(_inidet)),
            BlocProvider<GetSaldoKas>(
                create: (context) => GetSaldoKas(_initsaldo)),
            BlocProvider<CreateBukuKas>(create: (context) => CreateBukuKas(0)),
          ],
          child: Container(
            padding: EdgeInsets.all(8),
            child: ListbukuKas(),
          ),
        ),
      ),
    );
  }
}

class ListbukuKas extends StatefulWidget {
  @override
  _ListbukuKasState createState() => _ListbukuKasState();
}

class _ListbukuKasState extends State<ListbukuKas> {
  DateTime _now = DateTime.now();
  DateTimeRange selectedDate;
  var formatter = new DateFormat.yMMMMd();
  var NumFormat = new NumberFormat.compact(locale: "Id");
  var NumFullFormat = new NumberFormat("###,###", "Id");
  
  List<int> _listtgl = [];
  @override
  void initState() {
    // TODO: implement initState
    selectedDate = DateTimeRange(
        start: DateTime(_now.year, _now.month, _now.day, 0, 0, 0, 0, 0),
        end: DateTime(_now.year, _now.month, _now.day, 23, 59, 59, 0, 0));
    _listtgl.add(selectedDate.start.millisecondsSinceEpoch);
    _listtgl.add(selectedDate.end.millisecondsSinceEpoch);
    Future.delayed(Duration.zero, () {
      GetBukuKasDetail _bloc = BlocProvider.of<GetBukuKasDetail>(context);
      _bloc.add(_listtgl);
      GetSaldoKas _blockas = BlocProvider.of<GetSaldoKas>(context);
      _blockas.add(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    GetBukuKasDetail _bloc = BlocProvider.of<GetBukuKasDetail>(context);
    GetSaldoKas _bloc_saldo = BlocProvider.of<GetSaldoKas>(context);
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
                _listtgl.clear();
                _listtgl.add(DateTime(picked.start.year, picked.start.month,
                        picked.start.day, 0, 0, 0, 0, 0)
                    .millisecondsSinceEpoch);
                _listtgl.add(DateTime(picked.end.year, picked.end.month,
                        picked.end.day, 23, 59, 59, 0, 0)
                    .millisecondsSinceEpoch);
                setState(() {});
                _bloc.add(_listtgl);
                _bloc_saldo.add(selectedDate);
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
          Padding(padding: EdgeInsets.only(top: 8)),
          Wrap(
            runSpacing: 1.0,
            spacing: 5.0,
            children: [
              RaisedButton(
                onPressed: () {
                  global_var.filter_bukukas = 0;
                  setState(() {});
                  _bloc.add(_listtgl);
                },
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: (global_var.filter_bukukas == 0)
                    ? FitnessAppTheme.yellow
                    : FitnessAppTheme.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Semua",
                      style: TextStyle(
                          color: (global_var.filter_bukukas == 0)
                              ? FitnessAppTheme.white
                              : FitnessAppTheme.yellow,
                          fontSize: 18)),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  global_var.filter_bukukas = -1;
                  setState(() {});
                  _bloc.add(_listtgl);
                },
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: (global_var.filter_bukukas < 0)
                    ? FitnessAppTheme.redtext
                    : FitnessAppTheme.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Biaya",
                      style: TextStyle(
                          color: (global_var.filter_bukukas < 0)
                              ? FitnessAppTheme.white
                              : FitnessAppTheme.redtext,
                          fontSize: 18)),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  global_var.filter_bukukas = 1;
                  setState(() {});
                  _bloc.add(_listtgl);
                },
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: (global_var.filter_bukukas > 0)
                    ? Colors.teal[900]
                    : FitnessAppTheme.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Pendapatan",
                      style: TextStyle(
                          color: (global_var.filter_bukukas > 0)
                              ? FitnessAppTheme.white
                              : Colors.teal[900],
                          fontSize: 18)),
                ),
              ),
            ],
          ),
          Divider(
            color: FitnessAppTheme.white,
          ),
          BlocBuilder<GetSaldoKas, List<double>>(builder: (context, dtSaldo) {
            double _db = 0.0;
            double _kr = 0.0;
            if (dtSaldo.length > 0) {
              _db = (dtSaldo[0] != null) ? dtSaldo[0] : 0.0;
              _kr = (dtSaldo[1] != null) ? dtSaldo[1] : 0.0;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Income : ",
                      style: TextStyle(
                          fontSize: 18,
                          color: FitnessAppTheme.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      NumFormat.format(_db.abs()),
                      style: TextStyle(
                          fontSize: 20,
                          color: FitnessAppTheme.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Biaya : ",
                      style: TextStyle(
                          fontSize: 18,
                          color: FitnessAppTheme.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      NumFormat.format(_kr.abs()),
                      style: TextStyle(
                          fontSize: 20,
                          color: FitnessAppTheme.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(
                  color: FitnessAppTheme.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Saldo : ",
                      style: TextStyle(
                          fontSize: 20,
                          color: FitnessAppTheme.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      NumFullFormat.format((_db.abs() - _kr.abs())),
                      style: TextStyle(
                          fontSize: 24,
                          color: FitnessAppTheme.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            );
          }),
          Divider(
            color: FitnessAppTheme.white,
          ),
          Container(
            child: BlocBuilder<GetBukuKasDetail, List<bukukasdet>>(
              builder: (context, dtbukukas) => Expanded(
                  child: ListView.builder(
                      itemCount: (dtbukukas == null) ? 0 : dtbukukas.length,
                      itemBuilder: (context, idx) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: (dtbukukas[idx].bukukasdet_tunai < 0)
                              ? FitnessAppTheme.lightredtext
                              : FitnessAppTheme.white,
                          child: ListTile(
                            title: Text(
                              DateFormat("dd MMM yyyy").format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      dtbukukas[idx].bukukasdet_created_at)),
                              style: TextStyle(
                                color: (dtbukukas[idx].bukukasdet_tunai < 0)
                                    ? FitnessAppTheme.white
                                    : FitnessAppTheme.nearlyBlack,
                              ),
                            ),
                            subtitle: Text(dtbukukas[idx].bukukasdet_ket,
                                style: TextStyle(
                                  color: (dtbukukas[idx].bukukasdet_tunai < 0)
                                      ? FitnessAppTheme.white
                                      : FitnessAppTheme.nearlyBlack,
                                )),
                            trailing: Text(
                              ((dtbukukas[idx].bukukasdet_tunai < 0)
                                      ? ""
                                      : "+") +
                                  NumFormat.format(
                                      dtbukukas[idx].bukukasdet_tunai),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: (dtbukukas[idx].bukukasdet_tunai < 0)
                                    ? FitnessAppTheme.white
                                    : FitnessAppTheme.nearlyBlack,
                              ),
                            ),
                          ),
                        );

                        ;
                      })),
            ),
          ),
        ],
      ),
    );
  }
}
