import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class TitlePage extends StatefulWidget {
  const TitlePage({super.key});

  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage>{

  void TimerTime() {
    Timer(Duration(milliseconds: 2500), () {
      Navigator.pushReplacementNamed(context, '/water');
    });
  }
  @override
  void initState() {
    TimerTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        body: Container(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Animate(
                    effects: [
                      FadeEffect(
                          delay: 200.ms,
                          duration: 1200.ms
                      )
                    ],
                    child: Image.asset(
                      'assets/icons/iconApp.png',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 400),
                  alignment: FractionalOffset(1,1),
                  child: Animate(
                      effects: [
                        FadeEffect(
                            delay: 500.ms,
                            duration: 600.ms
                        )
                      ],
                      child: SpinKitFadingCircle(
                        color: Color.fromRGBO(55,55,55,1).withOpacity(0.25),
                        size: 20*(1 + MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                        duration: 700.ms,
                      ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 40),
                  child: Animate(
                      effects: [
                        FadeEffect(
                            delay: 200.ms,
                            duration: 1200.ms
                        )
                      ],
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "Created by ",
                            style: TextStyle(
                                color: Color.fromRGBO(55,55,55,1),
                                fontSize: 18,
                                fontFamily: 'Calibri',
                                fontWeight: FontWeight.normal
                            ),
                            children: [
                              TextSpan(
                                text: "Enemybye",
                                style: TextStyle(
                                    color: Color.fromRGBO(55,55,55,1),
                                    fontSize: 18,
                                    fontFamily: 'Calibri',
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ]
                        ),
                      )
                  ),
                ),
              ],
            )
        ),
      )
    );
  }
}
