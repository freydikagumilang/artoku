import 'package:artoku/fintness_app_theme.dart';
import 'package:artoku/main.dart';
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
        title: "Hai, Saya Artoku",
        body:
            "Aplikasi penjualan yang akan membantu mencatat transaksi bisnis Anda",
        image: Center(
          child: Image(
            image: AssetImage('assets/img/ledger.png'),
            height: 175.0,
          ),
        ),
      ),
      PageViewModel(
        title: "Title of Second page",
        body:
            "Here you can write the description of the Second page, to explain someting...",
        image: Center(
          child: Image(
            image: AssetImage('assets/img/ledger.png'),
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
            context, MaterialPageRoute(builder: (context) => MyApp(tab_id: 0)));
      },
      done: Text("Memulai",
          style: TextStyle(
            color: FitnessAppTheme.white,
          )),
      showNextButton: true,
      next: Text("Selanjutnya",
          style: TextStyle(
            color: FitnessAppTheme.white,
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
