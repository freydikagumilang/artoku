import 'package:artoku/main.dart';
import 'package:artoku/models/kasirmodel.dart';
import 'package:artoku/models/kasmodel.dart';
import 'package:artoku/ui_view/template/frxappbar.dart';
import 'package:flutter/material.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:artoku/bloc/blockasir.dart';

class DaftarNota extends StatefulWidget {
  @override
  _DaftarNotaState createState() => _DaftarNotaState();
}

class _DaftarNotaState extends State<DaftarNota> {
  List<invoice> _initListInvoices;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context, rootNavigator: true).pushNamed("/masterdata");
        },
        child: Scaffold(
            backgroundColor: FitnessAppTheme.tosca,
            appBar: FrxAppBar("Laporan Penjualan", backroute: "/masterdata"),
            body: MultiBlocProvider(
                providers: [
                  BlocProvider<GetListInvoice>(
                      create: (context) => GetListInvoice(_initListInvoices)),
                  BlocProvider<DeleteTransactions>(
                      create: (context) => DeleteTransactions(0)),
                  BlocProvider<CreateBukuKas>(
                      create: (context) => CreateBukuKas(0)),
                ],
                child: Container(
                    padding: EdgeInsets.all(8),
                    child: GenerateListInvoices()))));
  }
}

class GenerateListInvoices extends StatefulWidget {
  @override
  _GenerateListInvoicesState createState() => _GenerateListInvoicesState();
}

class _GenerateListInvoicesState extends State<GenerateListInvoices> {
  filterInvoices filterList;
  DateTime _now = DateTime.now();
  invoice myinv;
  DateTimeRange dtr;
  var NumFormat = new NumberFormat.compact(locale: "id");
  var formatter = new DateFormat.yMMMMd();
  @override
  void initState() {
    myinv = new invoice("", "", 0, 0, 0, 0, 0, 0, 0,
        inv_plg_nama: "", inv_plg_hp: "");
    dtr = DateTimeRange(
        start: DateTime(_now.year, _now.month, _now.day, 0, 0, 0, 0, 0),
        end: DateTime(_now.year, _now.month, _now.day, 23, 59, 59, 0, 0));
    filterList = filterInvoices(dtr, myinv);
    Future.delayed(Duration.zero, () {
      GetListInvoice _bloc = BlocProvider.of<GetListInvoice>(context);
      _bloc.add(filterList);
    });
  }

  @override
  Widget build(BuildContext context) {
    DeleteTransactions _deleteNota =
        BlocProvider.of<DeleteTransactions>(context);
    CreateBukuKas _creatorBukukas = BlocProvider.of<CreateBukuKas>(context);
    GetListInvoice _bloc = BlocProvider.of<GetListInvoice>(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(
                flex: 5,
                child: ElevatedButton(
                  onPressed: () async {
                    AlertDialog showFilter = AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      title: Text("Filter Data"),
                      content: FilterListInvoice(myinv),
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return showFilter;
                        }).then((val) {
                      if (val != null) {
                        setState(() {
                          myinv = val;
                        });
                        // print("test"+myinv.inv_plg_nama);

                        dtr = DateTimeRange(
                            start: DateTime(
                                _now.year, _now.month, _now.day, 0, 0, 0, 0, 0),
                            end: DateTime(_now.year, _now.month, _now.day, 23,
                                59, 59, 0, 0));
                        filterList = filterInvoices(dtr, myinv);
                        _bloc.add(filterList);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.teal[300].withOpacity(0.7),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ))),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.filter_list_alt),
                        Text(
                          "Filter",
                          style: TextStyle(
                              fontSize: 20.0, color: FitnessAppTheme.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: ElevatedButton(
                  onPressed: () async {
                    final DateTimeRange picked = await showDateRangePicker(
                        context: context,
                        initialDateRange:
                            DateTimeRange(start: dtr.start, end: dtr.end),
                        firstDate: DateTime(2019),
                        lastDate: DateTime.now().add(Duration(days: 1)),
                        confirmText: "Pilih",
                        cancelText: "Batal",
                        saveText: "Pilih",
                        helpText: "Pilih Tanggal");
                    if (picked != null && picked != dtr) {
                      dtr = picked;
                      setState(() {
                        filterList = filterInvoices(dtr, myinv);
                        _bloc.add(filterList);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.teal[300].withOpacity(0.7),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ))),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.date_range_outlined),
                        Text(
                          "Periode",
                          style: TextStyle(
                              fontSize: 20.0, color: FitnessAppTheme.white),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Text(
            "Periode ${formatter.format(dtr.start)} s/d ${formatter.format(dtr.end)}",
            style: TextStyle(fontSize: 18, color: FitnessAppTheme.white),
          ),
          BlocBuilder<GetListInvoice, List<invoice>>(
            builder: (context, data) {
              return Expanded(
                child: ListView.builder(
                    itemCount: (data == null) ? 0 : data.length,
                    itemBuilder: (context, idx) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.15,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              child: ListTile(
                                onTap: () {
                                  AlertDialog showdet = AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    title: Column(
                                      children: [
                                        Text(
                                          data[idx].inv_no.toString(),
                                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          "Tgl : " +
                                              data[idx].inv_date.toString(),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                            "Pelanggan " +
                                                ((data[idx].inv_plg_nama !=
                                                        null)
                                                    ? data[idx].inv_plg_nama
                                                    : ""),
                                            style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                    content: DetNota(data[idx].details,data[idx].inv_total_net),
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return showdet;
                                      });
                                },
                                tileColor: FitnessAppTheme.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                title: Text(
                                  (data[idx].inv_plg_nama != null)
                                      ? (data[idx].inv_plg_nama +
                                          " / " +
                                          data[idx].inv_plg_hp.toString())
                                      : "Tanpa Pelanggan",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "No.Inv : " + data[idx].inv_no,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text("Tgl : " +
                                        data[idx].inv_date.toString()),
                                  ],
                                ),
                                trailing: Text(
                                    NumFormat.format(data[idx].inv_total_net)
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                  caption: 'Hapus',
                                  color: FitnessAppTheme.redtext,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete_rounded,
                                  onTap: () async {
                                    await _deleteNota.add(data[idx]);

                                    bukukasdet _bukukasdet = bukukasdet(
                                        0 - data[idx].inv_total_net,
                                        0,
                                        "Hapus Penjualan Nota : " +
                                            data[idx].inv_no,
                                        data[idx].inv_created_at,
                                        data[idx].inv_created_at,
                                        0);

                                    bukukas _bukukas = bukukas(
                                        0 - data[idx].inv_total_net,
                                        0,
                                        data[idx]
                                            .inv_created_at, //get today at 00:00:00
                                        data[idx]
                                            .inv_created_at, //get today at 00:00:00
                                        0,
                                        detail_bukukas: _bukukasdet);
                                    await _creatorBukukas.add(_bukukas);
                                    await _bloc.add(filterList);
                                  }),
                            ]),
                      );
                    }),
              );
            },
          )
        ],
      ),
    );
  }
}

class FilterListInvoice extends StatefulWidget {
  final invoice inv;
  FilterListInvoice(this.inv);
  @override
  _FilterListInvoiceState createState() => _FilterListInvoiceState();
}

class _FilterListInvoiceState extends State<FilterListInvoice> {
  TextEditingController txtNamaPlg = TextEditingController();
  TextEditingController txtInv = TextEditingController();
  invoice _myinv;
  @override
  void initState() {
    txtNamaPlg.text = widget.inv.inv_plg_nama;
    txtInv.text = widget.inv.inv_no;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(fontSize: 16),
            controller: txtNamaPlg,
            decoration: InputDecoration(
                labelText: 'Nama / HP Pelanggan',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: FitnessAppTheme.tosca))),
          ),
          TextFormField(
            style: TextStyle(fontSize: 16),
            controller: txtInv,
            decoration: InputDecoration(
                labelText: 'No.Invoice',
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: FitnessAppTheme.tosca))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _myinv = new invoice(txtInv.text, "", 0, 0, 0, 0, 0, 0, 0,
                    inv_plg_nama: txtNamaPlg.text, inv_plg_hp: txtNamaPlg.text);
              });
              Navigator.of(context).pop(_myinv);
            },
            style: ElevatedButton.styleFrom(
                primary: FitnessAppTheme.tosca,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.filter_list_alt),
                  Text(
                    "filter",
                    style:
                        TextStyle(fontSize: 18.0, color: FitnessAppTheme.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DetNota extends StatelessWidget {
  var NumFormat = new NumberFormat.decimalPattern('id');
  final List<invoicedet> details;
  final double totalorder;
  DetNota(this.details,this.totalorder);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 300.0, // Change as per your requirement
          width: 300.0, // Change as per your requirement
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: (details == null) ? 0 : details.length,
              itemBuilder: (_, idx) {
                return ListTile(
                  title: Text(
                    details[idx].invdet_kat_nama +
                        " " +
                        details[idx].invdet_prod_nama,
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    (details[idx].invdet_kapster_id == null)
                        ? ""
                        : details[idx].invdet_kapster_name +
                            " (Komisi : " +
                            NumFormat.format(details[idx].invdet_komisi)
                                .toString() +
                            ")",
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Text(
                    NumFormat.format(details[idx].invdet_total).toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }),
        ),
        Center(
            child: Text(
           "Total Nota : "+NumFormat.format(totalorder).toString() ,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
        ))
      ],
    );
  }
}
