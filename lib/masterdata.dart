import 'package:flutter/material.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'models/menumaster.dart';

class MasterData extends StatefulWidget {
  @override
  _MasterDataState createState() => _MasterDataState();
}

class _MasterDataState extends State<MasterData> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
     onWillPop: ()async=>false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: FitnessAppTheme.tosca,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Center(
              child: Text(
            "Data",
            style: TextStyle(fontSize: 25, color: FitnessAppTheme.white),
          )),
        ),
        body: Container(
          color: FitnessAppTheme.tosca,
          child: MenuBuilder(),
        ),
      ),
    );
  }
}

class MenuBuilder extends StatefulWidget {
  @override
  _MenuBuilderState createState() => _MenuBuilderState();
}

class _MenuBuilderState extends State<MenuBuilder> {
  List<MenuMasterData> _menumaster = MenuMasterData.listmenu;
  Widget mydirection;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 3
                    : 4),
        itemCount: _menumaster.length,
        itemBuilder: (BuildContext context, int id) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(_menumaster[id].direction);
              //Navigator.pushNamed(context,_menumaster[id].direction);
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                  elevation: 3,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          _menumaster[id].icon,
                          size: 35,
                          color: FitnessAppTheme.tosca,
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          _menumaster[id].menu,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'SFProDisplay',
                              // fontWeight: FontWeight.w700,
                              color: FitnessAppTheme.tosca),
                        ),
                      ])),
            ),
          );
        });
  }
}
