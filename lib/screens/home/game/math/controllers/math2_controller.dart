import 'dart:async';

import 'package:brain_train_app/services/PlayingTurnService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../game2_screens/g2_congrat_screen.dart';
import '../game2_screens/g2_globals.dart';
import '../../../../../viewModel/data/data_math/game2_data_generator.dart';

class Math2Controller extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // to animate progress bar
  late Animation _animation;
  Animation get animation => _animation;

  // to animate page turn
  late PageController _pageController;
  PageController get pageController => _pageController;

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  late List<int> _correctAns;
  List<int> get correctAns => _correctAns;

  late List<int> _selectedAns;
  List<int> get selectedAns => _selectedAns;

  // to record the options the user had chosen
  List<int> _optionsChosen = [];
  List<int> get optionsChosen => _optionsChosen;

  final RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  Game2DataGenerator dataGenerator = Get.put(Game2DataGenerator());

  late int playTime;

  final RxInt _level = Globals.glbLevel;
  RxInt get getLevel => _level;

  RxInt _sum = 0.obs;
  RxInt get getSum => _sum;

  List<int> pointList = [
    100,
    100,
    100,
    100,
    200,
    200,
    300,
    300,
    300,
    400,
    400,
    500,
    500,
    500,
    500
  ];

  RxInt point = 0.obs;
  RxInt get getPoint => point;

  // to record total play time of user
  int _responseTime = 0;
  int _totalResponseTime = 0;
  int get totalResponseTime => _totalResponseTime;

  PlayingTurnService playingService = PlayingTurnService();

  @override
  void onInit() {
    // set the initial play time
    if (_questionNumber.value == 1) {
      if (_level.value == 1) {
        playTime = 10;
      } else if (_level.value == 2) {
        playTime = 12;
      } else {
        playTime = 15;
      }
    }

    // fill the progress bar within 60s
    _animationController =
        AnimationController(duration: Duration(seconds: playTime), vsync: this);
    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController)
      ..addListener(() {
        update();
      });

    // when 60s ends, go to the next question
    _animationController.forward().whenComplete(nextQuestion);
    _pageController = PageController();
    super.onInit();
  }

  @override
  void onClose() {
    _animationController.dispose();
    _pageController.dispose();
    super.onClose();
  }

  // to pause the animation controller
  void pauseProgressBar() {
    _animationController.stop();
  }

  // to continue the animation controller
  void continueProgressBar() {
    _animationController.forward().whenComplete(nextQuestion);
  }

  // generate questions
  List<List<int>> getQuestions() {
    List<List<int>> playQuestions = [];

    // level 1
    if (_level == 1.obs) {
      _sum = 10.obs;

      for (int i = 0; i < 4; i++) {
        playQuestions.add(dataGenerator.generateOptions(10, 4));
      }
      for (int i = 0; i < 5; i++) {
        playQuestions.add(dataGenerator.generateOptions(10, 5));
      }
      for (int i = 0; i < 6; i++) {
        playQuestions.add(dataGenerator.generateOptions(10, 6));
      }
    }

    // level 2
    if (_level == 2.obs) {
      _sum = 100.obs;
      for (int i = 0; i < 4; i++) {
        playQuestions.add(dataGenerator.generateOptions(100, 4));
      }
      for (int i = 0; i < 5; i++) {
        playQuestions.add(dataGenerator.generateOptions(100, 5));
      }
      for (int i = 0; i < 6; i++) {
        playQuestions.add(dataGenerator.generateOptions(100, 6));
      }
    }

    // level 3
    if (_level == 3.obs) {
      _sum = 1000.obs;
      for (int i = 0; i < 4; i++) {
        playQuestions.add(dataGenerator.generateOptions(1000, 4));
      }
      for (int i = 0; i < 5; i++) {
        playQuestions.add(dataGenerator.generateOptions(1000, 5));
      }
      for (int i = 0; i < 6; i++) {
        playQuestions.add(dataGenerator.generateOptions(1000, 6));
      }
    }
    return playQuestions;
  }

  void checkAns(List<int> options, List<int> selectedInx) {
    _isAnswered = true;
    _selectedAns = selectedInx;

    // calculate total response time on the whole question set
    _responseTime = (playTime - (animation.value * playTime)).round();
    _totalResponseTime += _responseTime;

    // check which options are correct
    for (int i = 0; i < options.length - 1; i++) {
      for (int j = i + 1; j < options.length; j++) {
        if (options[i] + options[j] == _sum.value) {
          _correctAns = [i, j];
          break;
        }
      }
    }

    // check if the selected answer is correct answer
    if (equal(_selectedAns, _correctAns)) {
      _numOfCorrectAns++;
      point += pointList[_questionNumber.value - 1];
    }

    // stop the progress bar
    _animationController.stop();
    update();

    // wait 1500 milliseconds before go to the next question
    Timer(const Duration(milliseconds: 1500), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    //! number of questions of each level is 15 (fixed)
    if (_questionNumber.value != 15) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: const Duration(milliseconds: 250), curve: Curves.ease);

      // reset the record of the chosen options
      _optionsChosen = [];

      // reset progress bar
      _animationController.reset();

      // then start it again
      _animationController.forward().whenComplete(nextQuestion);
    } else {
      _saveDailyMath();
      playingService.save('MATH', 'SUM', point.value, _totalResponseTime);
      Get.to(() => const Math2CongratScreen());
      if (numOfCorrectAns >= 14) {
        if (Globals.maxUnlockedLevel != 3) {
          if (Globals.glbLevel == 1 && Globals.maxUnlockedLevel == 1) {
            setMaxLevel(2);
          }
          if (Globals.glbLevel == 2 && Globals.maxUnlockedLevel == 2) {
            setMaxLevel(3);
          }
        }
        Globals.announceLevelUp = true;
      } else {
        Globals.announceLevelUp = false;
      }
    }
  }

  void updateQuestionNumber(int index) {
    _questionNumber.value = index + 1;

    // update play time through each question
    if (_questionNumber.value == 7 || _questionNumber.value == 12) {
      playTime -= 2;
    }
  }

  bool equal(List list1, List list2) {
    if (list1.length != list2.length) {
      return false;
    }
    for (var element in list1) {
      if (!list2.contains(element)) {
        return false;
      }
    }
    for (var element in list2) {
      if (!list1.contains(element)) {
        return false;
      }
    }
    return true;
  }

  Future<void> setMaxLevel(int maxLevel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('maxLevel', maxLevel);
  }

  //! save daily workout of game math
  Future<void> _saveDailyMath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("DailyMath", true);
    await prefs.setInt("date", DateTime.now().millisecondsSinceEpoch);
  }
}
