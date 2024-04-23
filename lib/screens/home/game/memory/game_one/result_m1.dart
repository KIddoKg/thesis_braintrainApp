import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../../../../viewModel/data/data_memory/data_memory_one.dart';
import '../../../../../services/services.dart';
import '../../../../../shared/toast.dart';
import '../Memory_Screen.dart';

class CongratScreen extends StatefulWidget {
  const CongratScreen({super.key});

  @override
  State<CongratScreen> createState() => _CongratState();
}

class _CongratState extends State<CongratScreen> {

  Map<String, dynamic> filter = {
    "gameType": "MEMORY",
    "gameName": "POSITION",
    "score": null,
    "maxLevel": 1,
  };


  @override
  void initState() {
    super.initState();
    sendData();
  }

  sendData() async {
    filter["score"] = score;
    filter["maxLevel"] = maxLevel;
    var res = await Services.instance.setContext(context).addDataPlayGameUser(filter: filter);

  }
  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
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
                            'Điểm: $score\nCấp độ cao nhất: $maxLevel',
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
