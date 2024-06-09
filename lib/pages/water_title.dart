import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:water_checker/details/drink_selector.dart';
import 'package:water_checker/details/notify_service.dart';
import '../bar/progressbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';


//this is a comment
class waterTitle extends StatefulWidget {
  const waterTitle({super.key});
  @override
  State<waterTitle> createState() => waterTitleState();
}

class waterTitleState extends State<waterTitle> with SingleTickerProviderStateMixin{
  double count = 0, percent = 0, _opacity = 1, _opacityTwo = 0, _margin = 120;
  int purpose = 0, permCount = 0;
  static const countKey = 'count', purposeKey = 'purpose', percentKey = 'percent', statKey = 'Statistic';
  bool isTap = false, drinkSelected = false;

  List<String> Statistic = [];

  final now = DateTime.now();

  int? indexSelect;
  List<Drink> _drinkList = [
    Drink(img: 'water.png', bgcolor: Colors.transparent, name: 'Вода'),
    Drink(img: 'tea.png', bgcolor: Colors.transparent, name: 'Чай'),
    Drink(img: 'matcha.png', bgcolor: Colors.transparent, name: 'Матча'),
    Drink(img: 'shaker.png', bgcolor: Colors.transparent, name: 'Спортпит'),
  ];

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 125),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(0,0),
    end: Offset(0, 1.5),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState(){
    _initPercent();
    super.initState();
  }
  changePercent() async{
    setState(() {
      count += permCount;
      percent = count/purpose;
    });
    await _setPercent ();
    await _setCount ();
  }
  Future _initPercent() async{
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      purpose = prefs.getInt(purposeKey) ?? 0;
      percent = prefs.getDouble(percentKey) ?? 0;
      count = prefs.getDouble(countKey) ?? 0;
      Statistic = prefs.getStringList(statKey) ?? [];
    });
  }
  Future _setCount() async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setDouble(countKey, count);
  }
  Future _setPercent () async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setDouble(percentKey, percent);
  }
  Future _setStat () async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(statKey, Statistic);
  }
  deleteProgress() async{
    setState(() {
      count = 0; permCount = 0; changePercent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFF),
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 125),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(vertical: 30),
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(18, 36, 18, _margin),
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
                GestureDetector(
                  onTap: (){
                    NotificationService().showNotification(title: 'Title', body: 'Body');
                  },
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Water Checker",
                      style: TextStyle(
                          color: Color.fromRGBO(55, 55, 55, 1),
                          fontSize: 36,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomProgressBar(progress: count/(purpose==0 ? 1 : purpose)),
                const Spacer(flex: 2),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Statistic.clear();
                      _setStat();
                      print(Statistic);
                      deleteProgress();
                    });
                  },
                  child: Text(
                    '${count.toInt()}ml',
                    style: TextStyle(
                        color: Color.fromRGBO(55, 55, 55, 1),
                        fontWeight: FontWeight.bold,
                        height: 1,
                        fontSize: MediaQuery.of(context).size.height*0.05-4,
                        fontFamily: 'Calibri'
                    ),
                  ),
                ),
                Text(
                  purpose == 0 ? "Введите цель в настройках" : "Дневная цель: ${purpose}ml",
                  style: TextStyle(
                    color: Color.fromRGBO(55, 55, 55, 1),
                    height: 1,
                    fontSize: MediaQuery.of(context).size.height*0.05-20,
                    fontWeight: FontWeight.normal
                  ),
                ),
                const Spacer(flex: 2),
                AnimatedCrossFade(
                    firstChild: AnimatedOpacity(
                      opacity: _opacity,
                      duration: Duration(milliseconds: 100),
                      child: SlideTransition(
                        position: _offsetAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  if (purpose != 0) {
                                    _margin = _margin == 18 ? 120 : 18;
                                    isTap == false
                                        ? _controller.forward()
                                        : _controller.reverse();
                                    _opacity = isTap == false ? 0 : 1;
                                    _opacityTwo = isTap == false ? 1 : 0;
                                    isTap = !isTap;
                                  }
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.18,
                                height: MediaQuery.of(context).size.width*0.18,
                                padding: EdgeInsets.all(8*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEBEBFF),
                                  borderRadius: BorderRadius.circular(12*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFF161616).withOpacity(0.05),
                                        spreadRadius: 0,
                                        blurRadius: 14,
                                        offset: Offset(0,0)
                                    )
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/add_water.svg',
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            SizedBox(width: 12-(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (purpose != 0){
                                    permCount = 100;
                                    Statistic.add('${now.hour}:${now.minute} Вода 100');
                                    _setStat();
                                    print(Statistic);
                                    changePercent();
                                    permCount = 0;
                                  }
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.18,
                                height: MediaQuery.of(context).size.width*0.18,
                                padding: EdgeInsets.only(top:8*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEBEBFF),
                                  borderRadius: BorderRadius.circular(12*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFF161616).withOpacity(0.05),
                                        spreadRadius: 0,
                                        blurRadius: 14,
                                        offset: Offset(0,0)
                                    )
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/add100.svg',
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            SizedBox(width: 12-(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (purpose != 0){
                                    permCount = 200;
                                    Statistic.add('${now.hour}:${now.minute} Вода 200');
                                    _setStat();
                                    print(Statistic);
                                    changePercent();
                                    permCount = 0;
                                  }
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.18,
                                height: MediaQuery.of(context).size.width*0.18,
                                padding: EdgeInsets.only(top:8*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEBEBFF),
                                  borderRadius: BorderRadius.circular(12*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFF161616).withOpacity(0.05),
                                        spreadRadius: 0,
                                        blurRadius: 14,
                                        offset: Offset(0,0)
                                    )
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/add200.svg',
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            SizedBox(width: 12-(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (purpose != 0){
                                    permCount = 300;
                                    Statistic.add('${now.hour}:${now.minute} Вода 300');
                                    _setStat();
                                    print(Statistic);
                                    changePercent();
                                    permCount = 0;
                                  }
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.18,
                                height: MediaQuery.of(context).size.width*0.18,
                                padding: EdgeInsets.only(top:8*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEBEBFF),
                                  borderRadius: BorderRadius.circular(12*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFF161616).withOpacity(0.05),
                                        spreadRadius: 0,
                                        blurRadius: 14,
                                        offset: Offset(0,0)
                                    )
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/add300.svg',
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    secondChild: Container(
                      child: AnimatedOpacity(
                        opacity: _opacityTwo,
                        duration: Duration(milliseconds: 125),
                        child: Column(
                          children: [
                            Container(
                              width: 188,
                              height: 62,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F3FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                style: TextStyle(
                                    fontSize: 32,
                                    color: Color(0xFF5D6EFF),
                                    height: 1,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Calibri'
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Количество',
                                  hintStyle: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFFBDBDBD),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Calibri'
                                  )
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    permCount = value.isNotEmpty ? int.parse(value) : 0;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 70,
                                width: 344,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _drinkList.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (indexSelect == null) {
                                              _drinkList[index].bgcolor = Colors.black.withOpacity(0.1);
                                              indexSelect = index;
                                            }
                                            else {
                                              _drinkList[indexSelect!].bgcolor = Colors.transparent;

                                              _drinkList[index].bgcolor = Colors.black.withOpacity(0.1);
                                              indexSelect = index;
                                            }
                                            print(indexSelect);
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 100),
                                          width: 70,
                                          height: 64,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: _drinkList[index].bgcolor,
                                          ),
                                          child: Image.asset('assets/image/drink/${_drinkList[index].img}', width: 48, height: 48,),
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ),
                            SizedBox(height: 32),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (permCount != 0 && indexSelect != null){
                                    Statistic.add('${now.hour}:${now.minute} ${_drinkList[indexSelect!].name} $permCount');
                                    _setStat();
                                    changePercent();
                                    permCount = 0;
                                    print(Statistic);
                                  }
                                  _margin = _margin == 18 ? 120 : 18;
                                  isTap == false ? _controller.forward() : _controller.reverse();
                                  _opacity = isTap == false ? 0 : 1;
                                  _opacityTwo = isTap == false ? 1 : 0;
                                  isTap = !isTap;
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
                                  (permCount != 0 && indexSelect != null) ? "Добавить" : "Назад",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontFamily: 'Calibri',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    crossFadeState: isTap == false ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 125)
                )
              ],
            ),
          ),
          AnimatedOpacity(
            opacity: _opacity,
            duration: Duration(milliseconds: 100),
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(bottom: 30, right: 18, left: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async{
                        final result = await Get.toNamed('settings');
                        setState(() {
                          purpose = result;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 21),
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width/2-32,
                        height: 76,
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
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "Настройки\n",
                                  style: TextStyle(
                                      color: Color.fromRGBO(55, 55, 55, 1),
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      fontSize: 10*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                                      fontFamily: 'Calibri'
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:  "и цель",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal
                                      ),
                                    )
                                  ]
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.arrow_forward_ios, size: 16,),
                            )
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/statistic', arguments: Statistic);
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 21),
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width/2-32,
                        height: 76,
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
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "Статистика\n",
                                  style: TextStyle(
                                      color: Color.fromRGBO(55, 55, 55, 1),
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      fontSize: 10*(MediaQuery.of(context).size.height/MediaQuery.of(context).size.width),
                                      fontFamily: 'Calibri'
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "за день",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal
                                      ),
                                    )
                                  ]
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.arrow_forward_ios, size: 16),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

