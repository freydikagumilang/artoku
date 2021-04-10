import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/blocproduk.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'package:artoku/models/produkmodel.dart';
import 'package:artoku/ui_view/produk/input_produk.dart';
import 'package:artoku/ui_view/template/frxappbar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class Produk extends StatefulWidget {
  @override
  _ProdukState createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  // var NumFormat = new NumberFormat.simpleCurrency(locale: "id",decimalDigits: 0);
  List<produk> listprod;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context, rootNavigator: true).pushNamed("/masterdata");
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<Getproduk>(create: (context) => Getproduk(listprod)),
          BlocProvider<Deleteproduk>(create: (context) => Deleteproduk(0)),
        ],
        child: Scaffold(
          backgroundColor: FitnessAppTheme.tosca,
          appBar: FrxAppBar(
            "Item/Layanan",
            backroute: "/masterdata",
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              size: 30,
              color: FitnessAppTheme.darkText,
            ),
            backgroundColor: FitnessAppTheme.yellow,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InputProduk()));
            },
          ),
          body:
              Padding(padding: const EdgeInsets.all(5.0), child: Produklist()),
        ),
      ),
    );
  }
}

class Produklist extends StatefulWidget {
  @override
  _ProduklistState createState() => _ProduklistState();
}

class _ProduklistState extends State<Produklist> {
  var NumFormat = new NumberFormat.compact(locale: "id");
  TextEditingController txtcari = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      Getproduk bloc = BlocProvider.of<Getproduk>(context);
      bloc.add("");
    });
  }

  @override
  Widget build(BuildContext context) {
    Getproduk bloc = BlocProvider.of<Getproduk>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
            color: FitnessAppTheme.white,
            child: TextFormField(
              controller: txtcari,
              style: TextStyle(fontSize: 20.0, color: Colors.black),
              decoration: InputDecoration(
                  hintText: "Cari Produk",
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
        BlocBuilder<Getproduk, List<produk>>(
            builder: (context, dataprod) => Expanded(
                  child: ListView.builder(
                    itemCount: (dataprod != null) ? dataprod.length : 0,
                    itemBuilder: (context, idx) {
                      return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          elevation: 0,
                          color: FitnessAppTheme.white,
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: ListTile(
                              title: Text(dataprod[idx].prod_nama,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 20)),
                              subtitle: Text(
                                  (dataprod[idx].kat_nama != null)
                                      ? dataprod[idx].kat_nama
                                      : "",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: FitnessAppTheme.grey)),
                              trailing: Text(
                                  NumFormat.format(dataprod[idx].prod_price)
                                      .toString(),
                                  style: TextStyle(fontSize: 23)),
                            ),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Edit',
                                color: FitnessAppTheme.yellow,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InputProduk(
                                                edit_prod: dataprod[idx],
                                              )));
                                },
                              ),
                              IconSlideAction(
                                caption: 'Share',
                                color: Colors.red[900],
                                icon: Icons.delete_outline_rounded,
                                onTap: () async {
                                          AlertDialog delDialog = AlertDialog(
                                            title: Text("Hapus Produk !"),
                                            content: DeleteConfirmation(
                                                dataprod[idx].prod_nama,
                                                dataprod[idx].prod_id),
                                          );
                                          final del = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return BlocProvider<
                                                    Deleteproduk>.value(
                                                  value: Deleteproduk(0),
                                                  child: delDialog,
                                                );
                                              });
                                          if (del) {
                                            Getproduk bloc =
                                                BlocProvider.of<Getproduk>(
                                                    context);
                                            bloc.add("");
                                          }
                                        },
                              ),
                            ],
                          ));
                    },
                  ),
                ))
      ],
    );
  }
}

class DeleteConfirmation extends StatefulWidget {
  final int idProd;
  final String namaProd;
  DeleteConfirmation(this.namaProd, this.idProd);
  @override
  _DeleteConfirmationState createState() => _DeleteConfirmationState();
}

class _DeleteConfirmationState extends State<DeleteConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Anda yakin ingin menghapus Produk ${widget.namaProd} ?"),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  color: FitnessAppTheme.tosca,
                  child: Text(
                    "Tidak",
                    style:
                        TextStyle(fontSize: 18.0, color: FitnessAppTheme.white),
                  )),
              FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: FitnessAppTheme.redtext,
                  onPressed: () {
                    Deleteproduk remover =
                        BlocProvider.of<Deleteproduk>(context);
                    remover.add(widget.idProd);
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    "Ya, Hapus",
                    style:
                        TextStyle(fontSize: 18.0, color: FitnessAppTheme.white),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
