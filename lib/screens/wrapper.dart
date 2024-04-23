import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/InputForm.dart';
import '../../../shared/button.dart';
import '../routes/app_route.dart';
import '../services/services.dart';
import '../shared/share_widgets.dart';

class EmojiScreen extends StatefulWidget {
  const EmojiScreen({Key? key}) : super(key: key);

  @override
  State<EmojiScreen> createState() => _EmojiScreenState();
}

class _EmojiScreenState extends State<EmojiScreen> {
  late FixedExtentScrollController _controller;
  int selectedValue1 = 0;
  int selectedValue2 = 0;
  String time = "";
  int minus = 0;
  int hour = 0;

  void onChange1(int value) {
    setState(() {
      selectedValue1 = value;
    });
  }

  void onChange2(int value) {
    setState(() {
      selectedValue2 = value;
    });
  }

  @override
  void initState() {
    _controller = FixedExtentScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    time = "${hour * 60 + minus}";
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Center(
                          child: Text(
                            "Trước khi bắt đầu luyện tập ngày mới.",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: Center(
                          child: Text(
                            "Chúng tôi xin phép khảo sát bạn một số vấn đề:",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        textAlign: TextAlign.center,
                        "Hôm nay bạn cảm thấy như thế nào ?",
                        style: TextStyle(color: Color(0xFF6f7478), fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ReviewSlider(
                        onChange: onChange1,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Nay bạn ngủ được bao nhiêu tiếng ?",
                      style: TextStyle(color: Color(0xFF6f7478), fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // hours wheel
                        SizedBox(
                          width: 70,
                          child: ListWheelScrollView.useDelegate(
                            controller: _controller,
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                hour = index;
                              });
                            },
                            physics: const FixedExtentScrollPhysics(),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 13,
                              builder: (context, index) {
                                return MyHours(
                                  hours: index,
                                  select: hour,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        // minutes wheel
                        SizedBox(
                          width: 70,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            perspective: 0.005,
                            diameterRatio: 1.2,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                minus = index;
                              });
                            },
                            physics: const FixedExtentScrollPhysics(),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 60,
                              builder: (context, index) {
                                return MyMinutes(
                                  mins: index,
                                  select: minus,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15, top: 20),
                    child: ButtonSubmit(
                      "Xác nhận",
                      fontColor: Colors.white,
                      onTap: () {
                        onSubmit();
                      },
                    ),
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  onSubmit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('emoj', false);
    var res = await Services.instance
        .setContext(context)
        .moodDaily(time, selectedValue1.toString());
    // if(res != null){
    Navigator.pushNamed(context, RouteGenerator.leader);
    // }
  }
}
