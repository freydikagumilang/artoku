import 'package:artoku/fintness_app_theme.dart';
import 'package:artoku/main.dart';
import 'package:artoku/ui_view/sysconfig/sysconfig.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroPageView extends StatefulWidget {
  @override
  _IntroPageViewState createState() => _IntroPageViewState();
}

class _IntroPageViewState extends State<IntroPageView> {
  List<PageViewModel> listPage() {
    return [
      PageViewModel(
        decoration: PageDecoration(
            bodyTextStyle: TextStyle(color: Colors.white70, fontSize: 20.0),
            titleTextStyle: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: FitnessAppTheme.white)),
        title: "Halo, Selamat Datang di Artoku",
        body:
            "Aplikasi penjualan yang akan membantu mencatat transaksi bisnis Anda",
        image:  Align(
          alignment: Alignment.bottomCenter,
          child: Image(
            image: AssetImage('assets/img/logoartoku.png'),
            height: 175.0,
          ),
        ),
      ),
      PageViewModel(
        decoration: PageDecoration(
            bodyTextStyle: TextStyle(color: Colors.white70, fontSize: 20.0),
            titleTextStyle: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: FitnessAppTheme.white)),
        title: "Laporan Laba / Rugi",
        body: "Menyediakan Laporan Laba / Rugi bisnis Anda secara realtime",
        image:  Align(
          alignment: Alignment.bottomCenter,
          child: Image(
            image: AssetImage('assets/img/ledger.png'),
            height: 200.0,
          ),
        ),
      ),
      PageViewModel(
        decoration: PageDecoration(
            bodyTextStyle: TextStyle(color: Colors.white70, fontSize: 20.0),
            titleTextStyle: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: FitnessAppTheme.white)),
        title: "Fitur Komisi Penjualan",
        body: "Otomatis mencatat komisi pegawai ",
        image: Align(
          alignment: Alignment.bottomCenter,
          child: Image(
            image: AssetImage('assets/img/gross-profit.png'),
            height: 200.0,
          ),
        ),
      ),
      PageViewModel(
        decoration: PageDecoration(
            bodyTextStyle: TextStyle(color: Colors.white70, fontSize: 20.0),
            titleTextStyle: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: FitnessAppTheme.white)),
        title: "Mulai Artoku",
        body: "Mulai langkah pertama dengan setting Bisnis Anda",
        image:  Align(
          alignment: Alignment.bottomCenter,
          child: Image(
            image: AssetImage('assets/img/store.png'),
            height: 175.0,
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: IntroductionScreen(
      pages: listPage(),
      onDone: () {
       Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompanyConfig(
                      isfirst: 1,
                    )));
      },
      done: Text("Mulai",
          style: TextStyle(
            color: FitnessAppTheme.white,
            fontSize: 18.0,
          )),
      showNextButton: true,
      next: Text("Selanjutnya",
          style: TextStyle(
            color: FitnessAppTheme.white,
            fontSize: 16.0,
          )),
      globalBackgroundColor: FitnessAppTheme.tosca,
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: FitnessAppTheme.yellow,
          color: FitnessAppTheme.lightosca,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    ));
  }
}
