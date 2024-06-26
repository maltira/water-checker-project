import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_checker/pages/settings_page.dart';
import 'package:water_checker/pages/statistic_page.dart';
import 'pages/title.dart';
import 'pages/water_title.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await getLastEnterTime();
  var lifecycleChannel = SystemChannels.lifecycle;
  lifecycleChannel.setMessageHandler((message) async {
    switch (message) {
      case 'AppLifecycleState.resumed': // Приложение вышло из фонового режима
        if (DateTime.now().hour < lastEnterTime) resetData();
        break;
      default:
        saveLastEnter(DateTime.now());
        break;
    }});

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

int lastEnterTime = 0;
Future resetData() async{
  var prefs = await SharedPreferences.getInstance();
  prefs.setDouble('count', 0);
  prefs.setDouble('percent', 0);
  prefs.setStringList('Statistic', []);
}
Future saveLastEnter(DateTime Time) async{
  var prefs = await SharedPreferences.getInstance();
  prefs.setInt('lastEnterTime', Time.hour);
}
Future getLastEnterTime() async{
  var prefs = await SharedPreferences.getInstance();
  lastEnterTime = prefs.getInt('lastEnterTime') ?? 0;
}


