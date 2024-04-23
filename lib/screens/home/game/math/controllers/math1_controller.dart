import 'dart:async';

import 'package:brain_train_app/services/PlayingTurnService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../../../viewModel/data/data_math/math1_data_generator.dart';
import '../game1_screens/g1_congrat_screen.dart';
import '../game1_screens/g1_globals.dart';

class Math1Controller extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late PageController _pageController;
  PageController get pageController => _pageController;

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  late int _correctAns;
  int get correctAns => _correctAns;

  late int _selectedAns;
  int get selectedAns => _selectedAns;

  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  Math1DataGenerator dataGenerator = Get.put(Math1DataGenerator());

  int playTime = 60;

  // to display the count down timer at UI
  RxInt _timeLeft = 60.obs;
  RxInt get timeLeft => _timeLeft;

  bool consecutive = false;
  int consecutiveCorrectTimes = 0;

  List<int> pointList = [];
  RxInt point = 0.obs;
  RxInt get getPoint => point;

  PlayingTurnService playingService = PlayingTurnService();

  @override
  void onInit() {
    _animationController = AnimationController(vsync: this);
    _pageController = PageController();
    Globals.cancelTimer = false;
    _countDown();
    super.onInit();
  }

  @override
  void onClose() {
    _animationController.dispose();
    _pageController.dispose();
    super.onClose();
  }

  // timer
  void _countDown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        if (Globals.stopTimer == true) {
          _timeLeft -= 0;
        } else {
          _timeLeft--;
        }
        if (Globals.cancelTimer == true) {
          timer.cancel();
        }
      } else {
        timer.cancel();
        _saveDailyMath();
        // save result into database
        playingService.save(
            'MATH', 'SMALLER_EXPRESSION', point.value, playTime);
        Get.to(() => const Math1CongratScreen());
      }
    });
  }

  // generate question set to display in the game
  List<List<Pair>> getQuestions() {
    List<List<Pair>> playQuestions = [];

    for (int i = 0; i < 5; i++) {
      playQuestions.add(dataGenerator.genQuestionLv1);
      pointList.add(100);
    }
    for (int i = 0; i < 9; i++) {
      playQuestions.add(dataGenerator.genQuestionLv2);
      pointList.add(150);
    }
    for (int i = 0; i < 10; i++) {
      playQuestions.add(dataGenerator.genQuestionLv3);
      pointList.add(200);
    }
    for (int i = 0; i < 24; i++) {
      playQuestions.add(dataGenerator.genQuestionLv4);
      pointList.add(300);
    }
    for (int i = 0; i < 24; i++) {
      playQuestions.add(dataGenerator.genQuestionLv5);
      pointList.add(400);
    }
    for (int i = 0; i < 14; i++) {
      playQuestions.add(dataGenerator.genQuestionLv6);
      pointList.add(500);
    }
    for (int i = 0; i < 14; i++) {
      playQuestions.add(dataGenerator.genQuestionLv7);
      pointList.add(600);
    }
    return playQuestions;
  }

  void checkAns(List<Pair> options, int selectedInx) {
    _isAnswered = true;
    _selectedAns = selectedInx;

    // check which option is correct
    int opt1 = options[0].value;
    int opt2 = options[1].value;
    if (opt1 < opt2) {
      _correctAns = 0;
    }
    if (opt1 > opt2) {
      _correctAns = 1;
    }

    if (_selectedAns == _correctAns) {
      _numOfCorrectAns++;
      consecutive = true;
      point += pointList[_questionNumber.value - 1];
    } else {
      consecutive = false;
      // for each incorrect ans => minus play time by 1s
      playTime -= 1;
      _timeLeft.value -= 1;
      Fluttertoast.showToast(
        msg: '-1 giây',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 197, 52, 42),
        textColor: Colors.white,
      );
    }

    // to keep track the number of correct answer in a row
    if (consecutive == true) {
      consecutiveCorrectTimes++;
    } else {
      consecutiveCorrectTimes = 0;
    }

    // 3 correct ans in a row => add 10s to play time
    if (consecutiveCorrectTimes == 3) {
      playTime += 10;
      _timeLeft += 10;
      consecutiveCorrectTimes = 0;
      Fluttertoast.showToast(
        msg: '+10 giây',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 25, 132, 29),
        textColor: Colors.white,
      );
    }

    // stop animation controller while checking answer
    _animationController.stop();
    update();

    // wait 1500 milliseconds before go to the next question
    Timer(const Duration(milliseconds: 1500), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (_questionNumber.value != getQuestions().length) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: const Duration(milliseconds: 250), curve: Curves.ease);

      // reset animation controller for the next question
      _animationController.reset();
    } else {
      _saveDailyMath();
      // save result into database
      playingService.save('MATH', 'SMALLER_EXPRESSION', point.value, playTime);
      Get.to(() => const Math1CongratScreen());
    }
  }

  void updateQuestionNumber(int index) {
    _questionNumber.value = index + 1;
  }

  //! save daily workout of game math
  Future<void> _saveDailyMath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("DailyMath", true);
    await prefs.setInt("date", DateTime.now().millisecondsSinceEpoch);
  }
}
