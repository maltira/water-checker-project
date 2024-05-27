import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class settingsWater extends StatefulWidget {
  const settingsWater({super.key});

  @override
  State<settingsWater> createState() => settingsWaterState();
}

class settingsWaterState extends State<settingsWater>{
  int? interval = null, purpose = null, permPurpose, permInterval;
  bool flagSwitch = false;
  static const intervalKey = 'interval', purposeKey = 'purpose', flagSwitchKey = 'flagSwitch';




  // Сохранение в локальном хранилище
  @override
  void initState() {
    super.initState();
    initSettings();
  }
  Future initSettings() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      purpose = prefs.getInt(purposeKey) ?? 0;
      interval = prefs.getInt(intervalKey) ?? 0;
      flagSwitch = prefs.getBool(flagSwitchKey) ?? false;
    });
  }
  changePurpose(String value) async{
    setState(() {
      purpose = value.isEmpty ? purpose : int.parse(value);
    });
    await _setPurpose();
  }
  changeInterval(String value) async{
    setState(() {
      interval = int.parse(value);
    });
    await _setInterval();
  }
  changeSwitchValue(bool value) async{
    setState(() {
      flagSwitch = value;
    });
    await _setSwitchValue();
  }
  Future _setInterval() async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(intervalKey, interval!);
  }
  Future _setSwitchValue() async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(flagSwitchKey, flagSwitch);
  }
  Future _setPurpose() async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(purposeKey, purpose!);
  }



  // Основной виджет
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFFBFBFF),
      body: Container(
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(18, 36, 18, 36),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF161616).withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 14,
                  offset: Offset(0,0)
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Настройки",
                          style: TextStyle(
                              color: Color.fromRGBO(55, 55, 55, 1),
                              fontSize: 32,
                              fontFamily: 'Calibri',
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Get.back(result: purpose);
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 72,
                          height: 48,
                          child: Icon(Icons.arrow_back_ios, size: 26, color: Color.fromRGBO(55, 55, 55, 1)),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(28, 16, 28, 36),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Уведомления",
                                  style: TextStyle(
                                    color: Color.fromRGBO(55, 55, 55, 1),
                                    fontSize: 24,
                                    fontFamily: 'Calibri',
                                  ),
                                ),
                                const Spacer(),
                                Switch(
                                  value: flagSwitch,
                                  activeColor: Color(0xFF5D6EFF),
                                  activeTrackColor: Color(0xFFF1F1F1),
                                  onChanged: (bool value){
                                    changeSwitchValue(value);
                                  }
                                )
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Данная функция позволяет включить напоминания.",
                              softWrap: true,
                              style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 16,
                                height: 1,
                                color: Color.fromRGBO(55, 55, 55, 1).withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Интервал",
                                  style: TextStyle(
                                    color: Color.fromRGBO(55, 55, 55, 1),
                                    fontSize: 24,
                                    fontFamily: 'Calibri',
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              verticalDirection: VerticalDirection.up,
                                              children: [
                                                Spacer(flex: 1),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (permInterval != null) changeInterval(permInterval.toString());
                                                      Get.back();
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 300,
                                                    height: 64,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(16),
                                                      color: Colors.black45,
                                                    ),
                                                    child: Text(
                                                      "Сохранить",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontFamily: 'Calibri',
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(flex: 3),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 300,
                                                  child: TextField(
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 48,
                                                        color: Color(0xFF5D6EFF),
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Calibri'
                                                    ),
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Введите значение',
                                                      hintStyle: TextStyle(
                                                          fontSize: 32,
                                                          color: Colors.grey[600],
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Calibri'
                                                      ),
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                    onChanged: (value){
                                                      setState(() {
                                                        permInterval = int.parse(value);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Spacer(flex: 2),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 24),
                                                  child: Text(
                                                    "Укажите интервал",
                                                    style: TextStyle(
                                                        fontSize: 32,
                                                        color: Color.fromRGBO(55, 55, 55, 1),
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Calibri'
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                    );
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 40,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFF1F1F1),
                                        borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: Text(
                                      (interval==0 || interval == null) ? '' : '$interval',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF5D6EFF),
                                          fontFamily: 'Calibri'
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Интервал указывается в минутах, уведомления будут приходить через каждый указанный интервал времени.",
                              softWrap: true,
                              style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 16,
                                height: 1,
                                color: Color.fromRGBO(55, 55, 55, 1).withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Цель",
                                  style: TextStyle(
                                    color: Color.fromRGBO(55, 55, 55, 1),
                                    fontSize: 24,
                                    fontFamily: 'Calibri',
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              verticalDirection: VerticalDirection.up,
                                              children: [
                                                Spacer(flex: 1),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (permPurpose != null) changePurpose(permPurpose.toString());
                                                      Get.back();
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 300,
                                                    height: 64,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(16),
                                                      color: Colors.black45,
                                                    ),
                                                    child: Text(
                                                      "Сохранить",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontFamily: 'Calibri',
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(flex: 3),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 300,
                                                  child: TextField(
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 48,
                                                        color: Color(0xFF5D6EFF),
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Calibri'
                                                    ),
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Введите значение',
                                                      hintStyle: TextStyle(
                                                          fontSize: 32,
                                                          color: Colors.grey[600],
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Calibri'
                                                      ),
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                    onChanged: (value){
                                                      setState(() {
                                                        permPurpose = int.parse(value);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Spacer(flex: 2),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 24),
                                                  child: Text(
                                                    "Укажите цель",
                                                    style: TextStyle(
                                                        fontSize: 32,
                                                        color: Color.fromRGBO(55, 55, 55, 1),
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Calibri'
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                    );
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 40,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF1F1F1),
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: Text(
                                      (purpose==0 || purpose == null) ? '' : '$purpose',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF5D6EFF),
                                          fontFamily: 'Calibri'
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Ежедневная цель указывается в миллилитрах (мл), только целое число.",
                              softWrap: true,
                              style: TextStyle(
                                fontFamily: 'Calibri',
                                fontSize: 16,
                                height: 1,
                                color: Color.fromRGBO(55, 55, 55, 1).withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    Get.back(result: purpose);
                  });
                },
                child: Container(
                  width: 280,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Color(0xFF5D6EFF),
                  ),
                  child: Text(
                    "Вернуться назад",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Calibri',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ]
          )
        )
      )
    );
  }
}

