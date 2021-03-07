import 'package:artoku/ui_view/template/frxappbar.dart';
import 'package:flutter/material.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'package:artoku/models/menulaporan.dart';

class ViewMenuLaporan extends StatefulWidget {
  @override
  _ViewMenuLaporanState createState() => _ViewMenuLaporanState();
}

class _ViewMenuLaporanState extends State<ViewMenuLaporan> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context, rootNavigator: true).pushNamed("/dashboard");
        },
        child: Scaffold(
          backgroundColor: FitnessAppTheme.tosca,
          appBar: FrxAppBar("Laporan", backroute: "/dashboard"),
          body: Container(
              child: ListView.separated(
                  separatorBuilder: (context, idx) {
                    return Divider(
                      color: FitnessAppTheme.white,
                    );
                  },
                  itemCount: MenuLaporan.listmenu.length,
                  itemBuilder: (context, idx) {
                    return ListTile(
                      onTap: (){
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(MenuLaporan.listmenu[idx].direction);
                      },
                      leading: Icon(MenuLaporan.listmenu[idx].icon,color: FitnessAppTheme.white,),
                      title: Text(MenuLaporan.listmenu[idx].menu,style: TextStyle(color: FitnessAppTheme.white,fontSize: 20),),
                    );
                  })),
        ));
  }
}
