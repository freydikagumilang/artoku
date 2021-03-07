import 'package:bloc/bloc.dart';
import 'package:artoku/models/kasirmodel.dart';
import 'package:artoku/global_var.dart';
import 'package:artoku/models/kasmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsertDet extends Bloc<invoicedet, double> {
  InsertDet(double initialState) : super(initialState);

  @override
  Stream<double> mapEventToState(invoicedet event) async* {
    if (global_var.detailkasir == null) {
      global_var.detailkasir = [event];
    } else {
      global_var.detailkasir.add(event);
    }
    global_var.total += event.invdet_total;
    global_var.kembalian =
        global_var.pembayaran + global_var.diskon - global_var.total;
    yield global_var.total;
  }
}

class CreateNota extends Bloc<invoice, int> {
  final _notaDAO = invoiceDAO();
  CreateNota(int initialState) : super(initialState);

  @override
  Stream<int> mapEventToState(invoice event) async* {
    int id;
    try {
      if (event.inv_id != 0 && event.inv_id != null) {
        id = await _notaDAO.updateInv(event);
      } else {
        id = await _notaDAO.saveInv(event);
      }
      yield id;
    } catch (e) {
      print("error");
      print(e);
    }
  }
}

class CreateBukuKas extends Bloc<bukukas, int> {
  final _bukukasDAO = bukukasDAO();
  CreateBukuKas(int initialState) : super(initialState);

  @override
  Stream<int> mapEventToState(bukukas event) async* {
    int id;
    try {
      id = await _bukukasDAO.saveBukuKas(event);
      id = await _bukukasDAO.saveDetBukuKas(event.detail_bukukas);

      yield id;
    } catch (e) {
      print("error");
      print(e);
    }
  }
}

class GetLast7DaysSale extends Bloc<int, List<salesperday>> {
  GetLast7DaysSale(List<salesperday> initialState) : super(initialState);
  final _notaDAO = invoiceDAO();
  @override
  Stream<List<salesperday>> mapEventToState(int event) async* {
    int start_date;
    int end_date;
    DateTime _datetime;
    List<int> _7days=[];
    try {
      for (var i = 6; i >= 0; i--) {
        _datetime = DateTime.fromMillisecondsSinceEpoch(event).subtract(Duration(days: i));

        start_date = DateTime(_datetime.year,_datetime.month,_datetime.day,0,0,0,0,0).millisecondsSinceEpoch;
        end_date = DateTime(_datetime.year,_datetime.month,_datetime.day,23,59,59,0,0).millisecondsSinceEpoch;
        _7days.add(start_date);
        _7days.add(end_date);
        
      }
      List<salesperday> _result = await _notaDAO.GetSalelast7Days(_7days);
      yield _result;
    } catch (e) {
      print("error");
      print(e);
    }
  }
}

class GetSalesGroupbyItem extends Bloc<DateTimeRange,List<salesperitem>>{
  GetSalesGroupbyItem(List<salesperitem> initialState) : super(initialState);
  final _notaDAO = invoiceDAO();
  @override
  Stream<List<salesperitem>> mapEventToState(DateTimeRange event)async* {
    try {
      List<salesperitem> _result = await _notaDAO.GetSalesPerItem(event);
      yield _result;
    } catch (e) {
      print("error");
      print(e);
    }
  }

}
class GetCommissionBydate extends Bloc<DateTimeRange,List<invoicedet>>{
  final _notaDAO = invoiceDAO();
  GetCommissionBydate(List<invoicedet> initialState) : super(initialState);

  @override
  Stream<List<invoicedet>> mapEventToState(DateTimeRange event)async* {
    // TODO: implement mapEventToState
    try {
      List<invoicedet> _result = await _notaDAO.CommissionBydate(event);
      yield _result;
    } catch (e) {
      print("error");
      print(e);
    }
  }  
}
class TruncateTransactions extends Bloc<int,int>{
  final _notaDAO = invoiceDAO();
  TruncateTransactions(int initialState) : super(initialState);

  @override
  Stream<int> mapEventToState(int event)async* {
    try {
      await _notaDAO.TruncateTransactions();
      yield 1;
    } catch (e) {
      print("error");
      print(e);
    }
  }
}

class TruncateAllData extends Bloc<int,int>{
  final _notaDAO = invoiceDAO();
  TruncateAllData(int initialState) : super(initialState);

  @override
  Stream<int> mapEventToState(int event)async*{
    try {
      await _notaDAO.TruncateMaster();
      await _notaDAO.TruncateTransactions();
      print("kosongkan Master & Transaksi");
      yield 1;
    } catch (e) {
      print("error");
      print(e);
    }
  }
}
class GetSalesDataPeriodic extends Bloc<DateTimeRange, List<invoice>> {
  final _notaDAO = invoiceDAO();
  GetSalesDataPeriodic(List<invoice> initialState) : super(initialState);

  @override
  Stream<List<invoice>> mapEventToState(DateTimeRange event) async* {
    try {
      List<invoice> _result = await _notaDAO.GetSalesPeriodic(event);
      yield _result;
    } catch (e) {
      print("error");
      print(e);
    }
  }
  
}
class GetSalesCustomerPeriodic extends Bloc<invoice, List<invoice>>{
  GetSalesCustomerPeriodic(List<invoice> initialState) : super(initialState);

  @override
  Stream<List<invoice>> mapEventToState(invoice event) async* {
    final _notaDAO = invoiceDAO();
    try {
      List<invoice> _result = await _notaDAO.GetSalesPerCustomer(event);
      yield _result;
    } catch (e) {
      print("error");
      print(e);
    }
  }

}

class GetSalesbyPegawaiPeriodic extends Bloc<fltKomisiPegawai, List<invoicedet>>{
  GetSalesbyPegawaiPeriodic(List<invoicedet> initialState) : super(initialState);

  @override
  Stream<List<invoicedet>> mapEventToState(fltKomisiPegawai event) async* {
    final _notaDAO = invoiceDAO();
    try {
      List<invoicedet> _result = await _notaDAO.GetSalesbyPegawai(event);
      yield _result;
    } catch (e) {
      print("error");
      print(e);
    }
  }

}