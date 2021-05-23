import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/blockategori.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'package:artoku/models/kategorimodel.dart';
import 'package:artoku/ui_view/template/frxappbar.dart';
import 'package:artoku/txtformater.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class Kategori extends StatefulWidget {
  @override
  _KategoriState createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  List<kategori> kat = [kategori("", 0.0)];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context, rootNavigator: true).pushNamed("/masterdata");
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GetKategori>(create: (context) => GetKategori(kat)),
          BlocProvider<CreateKategori>(create: (context) => CreateKategori(0)),
          BlocProvider<DeleteKategori>(create: (context) => DeleteKategori(0)),
        ],
        child: Scaffold(
          backgroundColor: FitnessAppTheme.tosca,
          appBar: FrxAppBar("Kategori"),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              size: 30,
              color: FitnessAppTheme.darkText,
            ),
            backgroundColor: FitnessAppTheme.yellow,
            onPressed: () async {
              AlertDialog inputdialog = AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Input Kategori"),
                    GestureDetector(
                      child: Icon(Icons.close),
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ],
                ),
                content: InputKategori(),
              );
              final res = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return BlocProvider<CreateKategori>.value(
                      value: CreateKategori(0),
                      child: inputdialog,
                    );
                  });
              if (res) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => Kategori()));
              }
            },
          ),
          body: Padding(padding: EdgeInsets.all(5), child: kategorilist()),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class kategorilist extends StatefulWidget {
  final String cari;
  kategorilist({this.cari});
  @override
  _kategorilistState createState() => _kategorilistState();
}

// ignore: camel_case_types
class _kategorilistState extends State<kategorilist> {
  var NumFormat = NumberFormat("#,###", "id");
  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration.zero, () {
      GetKategori bloc = BlocProvider.of<GetKategori>(context);
      bloc.add("");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GetKategori bloc = BlocProvider.of<GetKategori>(context);
    TextEditingController txtcari = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
            color: FitnessAppTheme.white,
            child: TextFormField(
              controller: txtcari,
              style: TextStyle(fontSize: 20.0, color: Colors.black),
              decoration: InputDecoration(
                  hintText: "Cari Kategori",
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
        Expanded(
          child: BlocBuilder<GetKategori, List<kategori>>(
              builder: (context, kat) => ListView.builder(
                  itemCount: (kat != null) ? kat.length : 0,
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
                            title: Text(kat[idx].kat_nama,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 20)),
                            trailing: Text(
                                NumFormat.format(kat[idx].kat_komisi)
                                        .toString() +
                                    " %",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 20)),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                                caption: 'Edit',
                                color: FitnessAppTheme.yellow,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                onTap: () async {
                                  AlertDialog inputdialog = AlertDialog(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "Edit Kategori ${kat[idx].kat_nama}"),
                                        GestureDetector(
                                          child: Icon(Icons.close),
                                          onTap: () {
                                            Navigator.pop(context, false);
                                          },
                                        ),
                                      ],
                                    ),
                                    content: InputKategori(
                                      editKat: kat[idx].kat_nama,
                                      idKat: kat[idx].kat_id,
                                      editKom: kat[idx].kat_komisi,
                                    ),
                                  );
                                  final res = await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BlocProvider<
                                            CreateKategori>.value(
                                          value: CreateKategori(0),
                                          child: inputdialog,
                                        );
                                      });
                                  if (res) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => Kategori()));
                                  }
                                }),
                            IconSlideAction(
                                caption: 'Share',
                                color: Colors.red[900],
                                icon: Icons.delete_outline_rounded,
                                onTap: () async {
                                  AlertDialog delKat = AlertDialog(
                                    title: Text(
                                        "Hapus Kategori ${kat[idx].kat_nama}"),
                                    content: DeleteConfirmation(
                                        kat[idx].kat_nama, kat[idx].kat_id),
                                  );
                                  final del = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BlocProvider<
                                            DeleteKategori>.value(
                                          value: DeleteKategori(0),
                                          child: delKat,
                                        );
                                      });
                                  if (del) {
                                    GetKategori bloc =
                                        BlocProvider.of<GetKategori>(context);
                                    bloc.add("");
                                  }
                                }),
                          ],
                        ));
                  })),
        ),
      ],
    );
  }
}

class InputKategori extends StatefulWidget {
  String editKat;
  double editKom;
  int idKat = 0;
  InputKategori({this.editKat, this.editKom, this.idKat = 0});
  @override
  _InputKategoriState createState() => _InputKategoriState();
}

class _InputKategoriState extends State<InputKategori> {
  final txtkategori = TextEditingController();
  final txtkomisi = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    txtkategori.text = widget.editKat;
    if (widget.editKom != null) txtkomisi.text = widget.editKom.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 3.5,
        child: BlocBuilder<CreateKategori, int>(
          builder: (context, idkat) => (Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: txtkategori,
                  decoration: InputDecoration(
                      labelText: 'Nama Kategori',
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: FitnessAppTheme.tosca))),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Nama Kategori Tidak Boleh Kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: txtkomisi,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Komisi (%)',
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: FitnessAppTheme.tosca))),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Komisi Tidak Boleh Kosong';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: FitnessAppTheme.tosca,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        if (widget.idKat != 0) {
                          CreateKategori creator =
                              BlocProvider.of<CreateKategori>(context);
                          kategori edited = kategori(
                              (txtkategori.text).toString(),
                              double.parse(txtkomisi.text));
                          edited.setId(widget.idKat);
                          creator.add(edited);
                          Navigator.of(context).pop(true);
                        } else {
                          CreateKategori creator =
                              BlocProvider.of<CreateKategori>(context);
                          creator.add(kategori((txtkategori.text).toString(),
                              double.parse(txtkomisi.text)));
                          Navigator.of(context).pop(true);
                        }
                      }
                    },
                    child: Text(
                      "Simpan",
                      style: TextStyle(
                          fontSize: 18.0, color: FitnessAppTheme.white),
                    )),
              ])),
        ),
      ),
    );
  }
}

class DeleteConfirmation extends StatefulWidget {
  final int idKat;
  final String namaKat;
  DeleteConfirmation(this.namaKat, this.idKat);
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
          Text("Anda yakin ingin menghapus kategori ${widget.namaKat} ?"),
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
                    DeleteKategori remover =
                        BlocProvider.of<DeleteKategori>(context);
                    remover.add(widget.idKat);
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
