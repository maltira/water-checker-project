import 'package:flutter/material.dart';
import 'package:get/get.dart';

class statisticWater extends StatefulWidget {
  const statisticWater({super.key});

  @override
  State<statisticWater> createState() => _statisticWaterState();
}

class _statisticWaterState extends State<statisticWater>{
  bool isFill = false;

  @override
  Widget build(BuildContext context) {


    List data = Get.arguments as List;
    isFill = data.isEmpty ? false : true;
    List AllElement = [];

    data.forEach((element) {
      List cur = element.split(' ');
      AllElement.add((cur[0], cur[1], cur[2]));
    });

    print(isFill);

    print(AllElement);
    return Scaffold(
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
                          "Статистика",
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
                          Get.back();
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
                  AnimatedCrossFade(
                      firstChild: Container(
                        margin: EdgeInsets.fromLTRB(28, 16, 28, 36),
                        height: MediaQuery.of(context).size.height-300,
                        child: ListView.separated(
                          itemCount: data.length,
                          separatorBuilder: (BuildContext context, int index) => Divider(),
                          itemBuilder: (BuildContext context, index) {
                            return Row(
                              children: [
                                Text(
                                  '${AllElement[index].$1} · ',
                                  style: TextStyle(
                                      fontFamily: 'Calibri',
                                      fontSize: 20,
                                      color: Color(0xFF161616),
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  '${AllElement[index].$2}',
                                  style: TextStyle(
                                      fontFamily: 'Calibri',
                                      fontSize: 20,
                                      color: Color(0xFF161616),
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  '${AllElement[index].$3}ml',
                                  style: TextStyle(
                                      fontFamily: 'Calibri',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      secondChild: Align(
                        alignment: Alignment.center,
                        child: Text('Статистика отсутствует :(')
                      ),
                      crossFadeState: isFill ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 125))
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.back();
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
            ],
          ),
        )
      )
    );
  }
}
