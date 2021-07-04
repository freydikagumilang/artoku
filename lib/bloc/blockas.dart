import 'package:bloc/bloc.dart';
import 'package:artoku/models/kasmodel.dart';
import 'package:flutter/material.dart';

class GetBukuKasDetail extends Bloc<List<int>, List<bukukasdet>> {
  final bukuKasDAO = bukukasDAO();

  GetBukuKasDetail(List<bukukasdet> initialState) : super(initialState);

  @override
  Stream<List<bukukasdet>> mapEventToState(List<int> event) async* {
    try {
      List<bukukasdet> listprod = await bukuKasDAO.getDetBukukas(event);
      yield listprod;
    } catch (e) {
      print("error : ${e}");
    }
  }
}

class GetDateSaldo extends Bloc<List<int>, List<bukukas>> {
  final bukuKasDAO = bukukasDAO();

  GetDateSaldo(List<bukukas> initialState) : super(initialState);

  @override
  Stream<List<bukukas>> mapEventToState(List<int> event) async* {
    // TODO: implement mapEventToState
    try {
      List<bukukas> _result = [];
      List<bukukas> _dt = await bukuKasDAO.getBukukas(event);

      if (_dt.length > 0) {
        if (_dt[0].bukukas_created_at == event[0]) {
          _result.add(_dt[0]);
        } else {
          print('sini');
          _result.add(bukukas(0, 0, event[0], 0, 0));
        }
      } else {
        _result.add(bukukas(0, 0, event[0], 0, 0));
      }

      if (_dt.length > 0) {
        if (_dt.length > 1) {
          if (_dt[1].bukukas_created_at <= event[1]) {
            _result.add(_dt[1]);
          }
        } else if (_dt[0].bukukas_created_at <= event[1]) {
          _result.add(_dt[0]);
        } else {
          _result.add(bukukas(0, 0, event[1], 0, 0));
        }
      } else {
        _result.add(bukukas(0, 0, event[1], 0, 0));
      }
      // print(DateTime.fromMillisecondsSinceEpoch(_result[0].bukukas_created_at));
      // print(DateTime.fromMillisecondsSinceEpoch(_result[1].bukukas_created_at));
      // print("nilai yesterday:"+_result[0].bukukas_tunai.toString());
      // print("nilai sekarang:"+_result[1].bukukas_tunai.toString());
      // print("jml : " + _result.length.toString());
      yield _result;
    } catch (e) {
      print("error : ${e}");
    }
  }
}

class CreateBukukasDet extends Bloc<bukukasdet, int> {
  final _bukukasDAO = bukukasDAO();
  CreateBukukasDet(int initialState) : super(initialState);

  @override
  Stream<int> mapEventToState(bukukasdet event) async* {
    try {
      int id = await _bukukasDAO.saveDetBukuKas(event);
      yield id;
    } catch (e) {
      print("error : ${e}");
    }
  }
}

class GetSaldoKas extends Bloc<DateTimeRange, List<double>> {
  final _bukukasDAO = bukukasDAO();
  GetSaldoKas(List<double> initialState) : super(initialState);

  @override
  Stream<List<double>> mapEventToState(DateTimeRange event) async* {
    try {
      List<double> _saldo = await _bukukasDAO.getSaldokas(event);
      yield _saldo;
    } catch (e) {
      print("error : ${e}");
    }
  }
}
