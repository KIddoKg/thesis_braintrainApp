import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';

import '../../../../../services/services.dart';
import '../../../../../shared/toast.dart';
import '../controllers/math2_controller.dart';
import 'g2_globals.dart';
import 'g2_levels_screen.dart';

class Math2CongratScreen extends StatefulWidget {
  const Math2CongratScreen({super.key});

  @override
  State<Math2CongratScreen> createState() => _Congrat2State();
}

class _Congrat2State extends State<Math2CongratScreen> {
  Map<String, dynamic> filter = {
    "gameType": "MATH",
    "gameName": "SUM",
    "score": null,
    "maxLevel": null,
    "maxLevel": 1,
  };

  sendData(int point, int ans) async {
    filter["score"] = point;
    filter["maxLevel"] = ans;
    filter["maxLevel"] = Globals.glbLevel.value;
    var res = await Services.instance.setContext(context).addDataPlayGameUser(filter: filter);

  }


  @override
  Widget build(BuildContext context) {
    Math2Controller _questionController = Get.put(Math2Controller());
    double scrHeight = MediaQuery.of(context).size.height;
    sendData(_questionController.getPoint.toInt(),_questionController.numOfCorrectAns);
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => Math2LevelScreen());
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: scrHeight * 0.5,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 184, 192, 220),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/congrat.json',
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: scrHeight / 20),
                  const Text(
                    'Chúc mừng!',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.3,
                    ),
                  ),
                  SizedBox(height: scrHeight / 100),
                  Text(
                    announceLevelUp(),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
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
                            'Điểm: ${_questionController.getPoint}\nSố câu đúng: ${_questionController.numOfCorrectAns}/15',
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
                          const Color.fromARGB(255, 64, 48, 145)),
                      elevation: MaterialStateProperty.all(1),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 25)),
                      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                        (_) => RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName('/game2MathLevel'));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Math2LevelScreen()));
                      Navigator.pushNamed(context, '/game2MathLevel');
                      Get.delete<Math2Controller>();
                    },
                    child: const Text(
                      'Quay lại màn hình chính',
                      style: const TextStyle(fontSize: 19),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String announceLevelUp() {
    if (Globals.announceLevelUp == true) {
      if (Globals.glbLevel == 1 && Globals.maxUnlockedLevel == 1) {
        return 'Bạn đã mở khóa cấp độ 2';
      } else if (Globals.glbLevel == 2 && Globals.maxUnlockedLevel == 2) {
        return 'Bạn đã mở khóa cấp độ 3';
      } else {
        return 'Bạn đã mở khóa hết các cấp độ';
      }
    } else {
      return '';
    }
  }
}
