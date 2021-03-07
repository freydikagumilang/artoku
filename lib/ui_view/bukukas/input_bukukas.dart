import 'package:artoku/bloc/blockasir.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'package:artoku/txtformater.dart';
import 'package:flutter/material.dart';
import 'package:artoku/global_var.dart';
import 'package:artoku/models/kasmodel.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputBukuKas extends StatefulWidget {
  final int multiplier;
  InputBukuKas(this.multiplier);
  @override
  _InputBukuKasState createState() => _InputBukuKasState();
}

class _InputBukuKasState extends State<InputBukuKas> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtKet = TextEditingController();
  TextEditingController txtAmount = TextEditingController();
  DateTime selectedDate;
  var formatter = new DateFormat.yMMMMd();

  @override
  void initState() {
    // TODO: implement initState
    selectedDate = DateTime.now();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () async {
                  final DateTime picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), // Refer step 1
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                    cancelText: "Batal",
                    confirmText: "Pilih",
                  );
                  if (picked != null && picked != selectedDate)
                    setState(() {
                      selectedDate = picked;
                    });
                },
                child: Text(
                  "${formatter.format(selectedDate)}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                style: TextStyle(fontSize: 20),
                controller: txtKet,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                    labelText: 'Keterangan',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FitnessAppTheme.tosca))),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Keterangan Tidak Boleh Kosong';
                  }
                },
              ),
              TextFormField(
                style: TextStyle(fontSize: 20),
                controller: txtAmount,
                inputFormatters: [NumericTextFormatter()],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Nominal',
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FitnessAppTheme.tosca))),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Nominal Tidak Boleh Kosong';
                  }
                },
              ),
              FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: FitnessAppTheme.tosca,
                  onPressed: () {
                    double _nominal = double.parse(txtAmount.text.replaceAll(".",""))*widget.multiplier;
                    bukukasdet _bukukasdet= bukukasdet(_nominal, 0, txtKet.text, selectedDate.millisecondsSinceEpoch, selectedDate.millisecondsSinceEpoch, 0);
                    bukukas _bukukas = bukukas(
                        _nominal,
                        0,
                        DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0, 0, 0).millisecondsSinceEpoch, //get today at 00:00:00
                        DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0, 0, 0).millisecondsSinceEpoch, //get today at 00:00:00
                        0,
                        detail_bukukas: _bukukasdet);
                    CreateBukuKas _creator =
                        BlocProvider.of<CreateBukuKas>(context);
                    _creator.add(_bukukas);
                    Navigator.of(context).pop(true);
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
