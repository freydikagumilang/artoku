import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/blockategori.dart';
import 'package:artoku/bloc/blocproduk.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'package:artoku/models/kategorimodel.dart';
import 'package:artoku/models/produkmodel.dart';
import 'package:artoku/txtformater.dart';
import 'package:artoku/ui_view/produk/produk.dart';
import 'package:artoku/ui_view/template/frxappbar.dart';
import 'package:intl/intl.dart';
import 'package:artoku/ui_view/transaksi/kasir.dart';

class InputProduk extends StatefulWidget {
  final produk edit_prod;
  final int fromkasir;
  InputProduk({this.edit_prod, this.fromkasir});

  @override
  _InputProdukState createState() => _InputProdukState();
}

class _InputProdukState extends State<InputProduk> {
  List<kategori> kat = [kategori("pilih kategori", 0.0)];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamed((widget.fromkasir == 1) ? "/kasir" : "/produk");
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<Createproduk>(create: (context) => Createproduk("")),
          BlocProvider<GetKategori>(create: (context) => GetKategori(kat)),
        ],
        child: Scaffold(
          backgroundColor: FitnessAppTheme.tosca,
          appBar: FrxAppBar(
            ((widget.edit_prod != null)
                ? "Edit Produk / Layanan"
                : "Input Produk / Layanan"),
            backroute: ((widget.fromkasir == 1) ? "/kasir" : "/produk"),
          ),
          body: Container(
              height: MediaQuery.of(context).size.height / 2,
              padding: EdgeInsets.all(10),
              child: InputForm(
                edit_prod: widget.edit_prod,
                fromkasir: widget.fromkasir,
              )),
        ),
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  final produk edit_prod;
  final int fromkasir;
  InputForm({this.edit_prod, this.fromkasir});
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  TextEditingController txtNamaProduk = TextEditingController();
  TextEditingController txtHarga = TextEditingController();
  int selectedkat;
  bool isStock = true;
  final _formKey = GlobalKey<FormState>();
  final f = NumberFormat("#,###", "id");

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      GetKategori bloc = BlocProvider.of<GetKategori>(context);
      bloc.add("");
      if (widget.edit_prod != null) {
        txtNamaProduk.text = widget.edit_prod.prod_nama;
        txtHarga.text = f.format(widget.edit_prod.prod_price);
        selectedkat = widget.edit_prod.prod_kat_id;
      }
    });
    setState(() {
      if (widget.edit_prod != null) {
        isStock = (widget.edit_prod.prod_countable == 1) ? true : false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    List inputProd;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TODO: Builder masih belum berhasil load data
              BlocBuilder<GetKategori, List<kategori>>(
                builder: (context, snapshot) => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Kategori",
                      style: TextStyle(fontSize: 20),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        value: (snapshot.length > 0) ? selectedkat : null,
                        items: snapshot.map((item) {
                          return DropdownMenuItem(
                            child: Text(
                              item.kat_nama,
                              style: TextStyle(fontSize: 20),
                            ),
                            value: (item.kat_id == null) ? 0 : item.kat_id,
                          );
                        }).toList(),
                        onChanged: (selItem) {
                          setState(() {
                            selectedkat = selItem;
                          });
                        },
                        validator: (value) => value == null
                            ? 'Kategori Tidak Boleh Kosong'
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                style: TextStyle(fontSize: 20),
                controller: txtNamaProduk,
                decoration: InputDecoration(
                    labelText: 'Produk / Layanan',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FitnessAppTheme.tosca))),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Nama Produk/Layanan Tidak Boleh Kosong';
                  }
                },
              ),
              TextFormField(
                style: TextStyle(fontSize: 20),
                controller: txtHarga,
                inputFormatters: [NumericTextFormatter()],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Harga',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FitnessAppTheme.tosca))),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Harga Tidak Boleh Kosong';
                  }
                },
              ),
              FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: FitnessAppTheme.tosca,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      double harga =
                          double.parse((txtHarga.text).replaceAll(".", ""));
                      produk newprod = produk(txtNamaProduk.text, selectedkat,
                          "", "", 0, 0.0, harga, 0.0, 0);
                      if (widget.edit_prod != null) {
                        newprod.setId(widget.edit_prod.prod_id);
                      }
                      Createproduk creator = Createproduk("");
                      creator.add(newprod);
                      if (widget.fromkasir == 1) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Kasir()));
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Produk()));
                      }
                    }
                  },
                  child: Text(
                    "Simpan",
                    style:
                        TextStyle(fontSize: 18.0, color: FitnessAppTheme.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
