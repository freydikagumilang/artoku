import 'package:flutter/material.dart';

class MenuLaporan {
  MenuLaporan({    
    this.index = 0,
    this.direction,
    this.animationController,
    this.menu,
    this.icon,
  });


  String menu;
  IconData icon;
  String direction;
  int index;

  AnimationController animationController;

  static List<MenuLaporan> listmenu = <MenuLaporan>[
    MenuLaporan(
      index: 0,
      direction : "/lappenjualan",
      animationController: null,
      menu:"Laporan Penjualan",
      icon: Icons.content_paste_rounded
    ),
    MenuLaporan(
      index: 1,
      direction : "/lapkomisi",
      animationController: null,
      menu:"Laporan Komisi",
      icon: Icons.people_alt
    ),
    
  ];
}
