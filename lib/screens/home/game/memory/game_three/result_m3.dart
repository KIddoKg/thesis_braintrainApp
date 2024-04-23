import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../viewModel/data/data_memory/data_memory_three.dart';
import '../../../../../services/services.dart';
import '../../../../../shared/toast.dart';
import '../Memory_Screen.dart';

class CongratM3Screen extends StatefulWidget {
  final String levelValue;
  const CongratM3Screen({super.key, required this.levelValue});

  @override
  State<CongratM3Screen> createState() => _CongratM3ScreenState();
}

class _CongratM3ScreenState extends State<CongratM3Screen> {
  calScore() {
    averageTime = responseTime / 10;
    bonusScore = score / averageTime;
    totalScore = bonusScore + score;
  }

  bool _isButtonEnabledM = false;
  bool _isButtonEnabledD = false;

  // ! Get state of button Medium
  Future<void> _loadButtonStateM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isButtonEnabledM = prefs.getBool("isEnableM") ?? false;
    });
  }

  // ! Get state of button Difficult
  Future<void> _loadButtonStateD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isButtonEnabledD = prefs.getBool("isEnableD") ?? false;
    });
  }

  Map<String, dynamic> filter = {
    "gameType": "MEMORY",
    "gameName": "LOST_PICTURE",
    "score": null,
    "playTime": 0,
    "maxLevel": 1,
  };


  sendData() async {
    filter["score"] = score;
    filter["playTime"] = responseTime;
    switch (widget.levelValue) {
      case 'Easy':
        filter["maxLevel"] = 1;
        break;
      case 'Medium':
        filter["maxLevel"] = 2;
        break;
      case 'Difficult':
        filter["maxLevel"] = 3;
        break;
    };
    var res = await Services.instance.setContext(context).addDataPlayGameUser(filter: filter);

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calScore();
    _loadButtonStateD();
    _loadButtonStateM();
    sendData();
    // print("PRINT: $_isButtonEnabledM or $_isButtonEnabledD");
  }

  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;


    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) =>const MemoryScreen()));
        Navigator.popUntil(context, ModalRoute.withName('/memoryScreen'));

        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Chúc mừng!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 228, 45, 32),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.3,
                    ),
                  ),
                  SizedBox(height: scrHeight / 60),
                  const Text(
                    'Bạn đã hoàn thành tất cả các lượt chơi',
                    style: TextStyle(
                      color: Color.fromARGB(255, 83, 74, 73),
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(height: scrHeight / 30),
                  Lottie.asset(
                    'assets/animations/congratulation.json',
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: scrHeight / 30),
                  SizedBox(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          _isButtonEnabledM
                              ? TyperAnimatedText(
                                  'Bạn đã mở khóa cấp độ tiếp theo\nĐiểm: ${totalScore.toInt()}\nThời gian: $responseTime giây',
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'RobotoSlab',
                                    wordSpacing: 1.2,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : TyperAnimatedText(
                                  "Điểm: ${totalScore.toInt()}\nThời gian: $responseTime giây",
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'RobotoSlab',
                                    wordSpacing: 1.2,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                          //  TyperAnimatedText(
                          //     'Bạn đã mở khóa cấp độ tiếp theo\nĐiểm: ${totalScore.toInt()}\nThời gian: $responseTime giây',
                          //     textStyle: const TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 18,
                          //       fontFamily: 'RobotoSlab',
                          //       wordSpacing: 1.2,
                          //       height: 1.5,
                          //     ),
                          //     textAlign: TextAlign.center,
                          //   ),
                          // TyperAnimatedText(
                          //   'Điểm: ${totalScore.toInt()}\nThời gian: $responseTime giây\nSố câu đúng M: $numOfCorrectM\nSố câu đúng D: $numOfCorrectD',
                          //   textStyle: const TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 18,
                          //     fontFamily: 'RobotoSlab',
                          //     wordSpacing: 1.2,
                          //     height: 1.5,
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                        ],
                        isRepeatingAnimation: false,
                      ),
                    ),
                  ),
                  SizedBox(height: scrHeight / 15),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 53, 28, 92)),
                      elevation: MaterialStateProperty.all(1),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 25)),
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                        (_) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) =>const MemoryScreen()));
                      Navigator.popUntil(
                          context, ModalRoute.withName('/memoryScreen'));
                    },
                    child: const Text(
                      'Quay lại màn hình chính',
                      style:   TextStyle(fontSize: 19),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
