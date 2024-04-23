import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../viewModel/data/data_attention/data_attention_two.dart';
import '../../../../../services/services.dart';
import '../../../../../shared/toast.dart';
import '../Attention_Screen.dart';

class CongratA2Screen extends StatefulWidget {
  final String levelValue;
  const CongratA2Screen({super.key, required this.levelValue});

  @override
  State<CongratA2Screen> createState() => _CongratA2ScreenState();
}

class _CongratA2ScreenState extends State<CongratA2Screen> {
  Map<String, dynamic> filter = {
    "gameType": "ATTENTION",
    "gameName": "PAIRING",
    "score": null,
    "playTime": null,
    "maxLevel": 1,
  };
  bool medium =false;
  bool diff = false;
  Future<void> _loadButtonStateM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      medium = prefs.getBool("isEnableM_att") ?? false;
    });
  }

  // ! Get state of button Difficult
  Future<void> _loadButtonStateD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      diff = prefs.getBool("isEnableD_att") ?? false;
    });
  }

  sendData() async {
    filter["score"] = totalScore.toInt();
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

  bool _isButtonEnabledM = false;
  bool _isButtonEnableD = false;

  Future<void> _saveButtonStateM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (numOfCorrectM == 52) {
        _isButtonEnabledM = true;
        prefs.setBool('isEnableM_att', _isButtonEnabledM);
      }
    });
  }

  Future<void> _saveButtonStateD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (numOfCorrectD == 52) {
        _isButtonEnableD = true;
        prefs.setBool('isEnableD_att', _isButtonEnableD);
      }
    });
  }

  calScore() {
    averageTime = responseTime / 8;
    bonusScore = score / averageTime;
    totalScore = bonusScore + score;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadButtonStateM();
    _loadButtonStateD();
    calScore();
    sendData();
  }

  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) =>const AttentionScreen()));
        Navigator.popUntil(context, ModalRoute.withName('/attentionScreen'));
        _saveButtonStateM();
        _saveButtonStateD();
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
                          TyperAnimatedText(
                            'Điểm: ${totalScore.toInt()}\nThời gian: $responseTime\n',
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AttentionScreen()));
                      Navigator.popUntil(
                          context, ModalRoute.withName('/attentionScreen'));
                      _saveButtonStateM();
                      _saveButtonStateD();
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
