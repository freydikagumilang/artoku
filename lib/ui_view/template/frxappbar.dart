import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:artoku/fintness_app_theme.dart';

class FrxAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String mytitle;
  final String backroute;
  FrxAppBar(this.mytitle, {this.backroute, Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0
  @override
  _FrxAppBarState createState() => _FrxAppBarState();
}

class _FrxAppBarState extends State<FrxAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: FitnessAppTheme.tosca,
        leading: IconButton(
            icon: new Icon((widget.backroute == "firstload")
                ? CupertinoIcons.building_2_fill
                : Icons.arrow_back),
            onPressed: () {
              if (widget.backroute != "firstload") {
                if (widget.backroute != null) {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(widget.backroute);
                } else {
                  Navigator.of(context).pop();
                }
              } else {
                return null;
              }
            }),
        elevation: 0,
        title: Text(
          widget.mytitle,
          style: TextStyle(fontSize: 25, color: FitnessAppTheme.white),
        ));
  }
}
