import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/blocpelanggan.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'package:artoku/models/pelangganmodel.dart';
import 'package:artoku/ui_view/masterdata/pelanggan.dart';
import 'package:artoku/ui_view/template/frxappbar.dart';
import 'package:artoku/global_var.dart';

class InputPelanggan extends StatefulWidget {
  final pelanggan editPlg;
  final int fromkasir;
  InputPelanggan({this.editPlg, this.fromkasir});
  @override
  InputPelangganState createState() => InputPelangganState();
}

class InputPelangganState extends State<InputPelanggan> {
  @override
  void initState() {
    // TODO: implement initState
    print(widget.fromkasir);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamed(((widget.fromkasir == 1) ? "/kasir" : "/pelanggan"));
      },
      child: BlocProvider<Createpelanggan>(
          create: (BuildContext context) => Createpelanggan(0),
          child: Scaffold(
            backgroundColor: FitnessAppTheme.tosca,
            appBar: FrxAppBar(
              ((widget.editPlg != null) ? "Edit Pelanggan" : "Input Pelanggan"),
              backroute: ((widget.fromkasir == 1) ? "/kasir" : "/pelanggan"),
            ),
            body: Container(
                height: MediaQuery.of(context).size.height / 2,
                padding: EdgeInsets.all(10),
                child: InputFormPelanggan(
                  editplg: widget.editPlg,
                  fromkasir: widget.fromkasir,
                )),
          )),
    );
  }
}

class InputFormPelanggan extends StatefulWidget {
  final pelanggan editplg;
  final int fromkasir;
  InputFormPelanggan({this.editplg, this.fromkasir = 0});
  @override
  _InputFormPelangganState createState() => _InputFormPelangganState();
}

class _InputFormPelangganState extends State<InputFormPelanggan> {
  TextEditingController txtNamaPlg = TextEditingController();
  TextEditingController txtHP = TextEditingController();
  TextEditingController txtAlamat = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    if (widget.editplg != null) {
      txtNamaPlg.text = widget.editplg.pelanggan_nama;
      txtHP.text = widget.editplg.pelanggan_hp;
      txtAlamat.text = widget.editplg.pelanggan_alamat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                  style: TextStyle(fontSize: 20),
                  controller: txtNamaPlg,
                  decoration: InputDecoration(
                      labelText: 'Nama',
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: FitnessAppTheme.tosca))),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Nama Pelanggan Tidak Boleh Kosong';
                    }
                  }),
              TextFormField(
                  style: TextStyle(fontSize: 20),
                  controller: txtHP,
                  decoration: InputDecoration(
                      labelText: 'No.Handphone',
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: FitnessAppTheme.tosca))),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'No.Handphone Tidak Boleh Kosong';
                    }
                  }),
              TextFormField(
                  style: TextStyle(fontSize: 20),
                  controller: txtAlamat,
                  decoration: InputDecoration(
                      labelText: 'Alamat',
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: FitnessAppTheme.tosca)))),
              FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: FitnessAppTheme.tosca,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      pelanggan newplg = pelanggan(
                          txtNamaPlg.text, txtHP.text, txtAlamat.text,fromkasir: widget.fromkasir);
                          
                      if (widget.editplg != null) {
                        newplg.setId(widget.editplg.pelanggan_id);
                      }
                      Createpelanggan creator = Createpelanggan(0);
                      creator.add(newplg);
                      if ((widget.fromkasir == 1)) {
                        
                        setState(() {
                          // print("plg_id"+global_var.kasirpelanggan.pelanggan_id.toString());
                        });
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed("/kasir");
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Pelanggan()));
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
