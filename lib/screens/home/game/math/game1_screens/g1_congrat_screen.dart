import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';

import '../../../../../services/services.dart';
import '../../../../../shared/toast.dart';
import '../Math_Screen.dart';
import '../controllers/math1_controller.dart';

class Math1CongratScreen extends StatefulWidget {
  const Math1CongratScreen({super.key});

  @override
  State<Math1CongratScreen> createState() => _CongratState();
}

class _CongratState extends State<Math1CongratScreen> {
  Map<String, dynamic> filter = {
    "gameType": "MATH",
    "gameName": "SMALLER_EXPRESSION",
    "score": null,
    "maxLevel": null,
  };

  sendData(int point, int ans) async {
    filter["score"] = point;
    filter["maxLevel"] = ans;

    var res = await Services.instance.setContext(context).addDataPlayGameUser(filter: filter);

  }


  @override
  Widget build(BuildContext context) {
    Math1Controller _questionController = Get.put(Math1Controller());
    double scrHeight = MediaQuery.of(context).size.height;
    sendData(_questionController.getPoint.toInt(),_questionController.numOfCorrectAns);
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const MathScreen());
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
                  SizedBox(height: scrHeight / 20),
                  Lottie.asset(
                    'assets/congrat.json',
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
                          TyperAnimatedText(
                            'Điểm: ${_questionController.getPoint}\nSố câu đúng: ${_questionController.numOfCorrectAns}\nTổng số câu đã chơi: ${_questionController.questionNumber}',
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'RobotoSlab',
                              wordSpacing: 1.2,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
                          MaterialPageRoute(builder: (context) => const MathScreen()));
                      Navigator.popUntil(
                          context, ModalRoute.withName('/mathScreen'));
                      Get.delete<Math1Controller>();
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
