import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_checker/pages/settings_page.dart';
import 'package:water_checker/pages/statistic_page.dart';
import 'pages/title.dart';
import 'pages/water_title.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GetMaterialApp(
    theme: ThemeData(fontFamily: 'Calibri'),
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => waterTitle()),
      GetPage(name: '/title', page: () => TitlePage()),
      GetPage(
        name: '/settings',
        page: () => settingsWater(),
        transition: Transition.leftToRight,
        transitionDuration: Duration(milliseconds: 250),
        curve: Curves.easeOut
      ),
      GetPage(
        name: '/statistic',
        page: () => statisticWater(),
        transition: Transition.rightToLeft,
        transitionDuration: Duration(milliseconds: 250),
        curve: Curves.easeOut
      ),
    ],
    debugShowCheckedModeBanner: false,
  ));
}




