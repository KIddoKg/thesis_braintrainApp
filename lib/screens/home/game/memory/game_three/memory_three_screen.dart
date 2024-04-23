import 'dart:async';
import 'dart:math';

import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../viewModel/data/data_memory/data_memory_three.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../../viewModel/data/data_onborad/data_memory_3.dart';
import '../../../../../shared/app_styles.dart';
import '../../../../onboarding/explanation.dart';
import '../../../../onboarding/home.dart';
import '../Memory_Screen.dart';
import 'result_m3.dart';

class MemoryThreeScreen extends StatefulWidget {
  final String levelValue;
  const MemoryThreeScreen({super.key, required this.levelValue});

  @override
  State<MemoryThreeScreen> createState() => _MemoryThreeScreenState();
}

class _MemoryThreeScreenState extends State<MemoryThreeScreen> {
  Timer? _timer;
  Timer? _timer2;
  bool _enableBtn = false;
  bool _disableTap = false;
  bool _showSuccess = false;
  bool _showFail = false;
  // bool _showTimeout = false;
  bool _isSwitch = false;
  bool _endResult = false;
  final double runSpacing = 5;
  final double spacing = 1;
  int columns = 4;

  int point = 0;
  int _countdownTime = 10;
  int timeInit = 0;
  Timer? _timerCountdown;
  bool _isButtonCheck = false;
  bool stopTime = false;
  bool setPlaygame = false;

  //! save daily workout of game math
  Future<void> _saveDailyMemory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("DailyMemory", true);
    await prefs.setInt("date", DateTime.now().millisecondsSinceEpoch);
  }

  bool _isButtonEnabledM = false;
  bool _isButtonEnableD = false;
  //! Save state of button Medium
  Future<void> _saveButtonStateM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (numOfCorrectM == 10) {
        _isButtonEnabledM = true;
        prefs.setBool('isEnableM', _isButtonEnabledM);
      }
    });
  }

  //! Save state of button Diff
  Future<void> _saveButtonStateD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (numOfCorrectD == 10) {
        _isButtonEnableD = true;
        prefs.setBool('isEnableM', _isButtonEnableD);
      }
    });
  }

  //! Hàm kiểm tra ở Level nào để lưu trạng thái Button
  saveBtn() {
    if (widget.levelValue == "Easy") {
      _saveButtonStateM();
    } else if (widget.levelValue == "Medium") {
      _saveButtonStateD();
    }
  }

  Future<void> setStaryPlay() async {
    bool saveSetPlay = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveSetPlay = prefs.getBool("setPlaygameMemo3") ?? false;
    setState(() {
      setPlaygame = saveSetPlay;
    });
    setPlay();
  }

  Future<void> setPlay() async {
    if (setPlaygame == false) {
      _navigateAndDisplaySelection(context);
      stopTime = true;
      setPlaygame = true;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setPlaygameMemo3', setPlaygame);
  }

  void showExitDialog(BuildContext context) {
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.warning,
      title: 'Cảnh báo',
      text: 'Bạn có muốn thoát khỏi trò chơi?',
      textColor: const Color.fromARGB(255, 60, 60, 60),
      confirmBtnText: 'Có',
      confirmBtnColor: const Color.fromARGB(255, 4, 114, 117),
      onConfirmBtnTap: () {
        // ! Fix here
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MemoryScreen()));
        Navigator.popUntil(context, ModalRoute.withName('/memoryScreen'));
      },
      confirmBtnTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      showCancelBtn: true,
      cancelBtnText: 'Không',
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      cancelBtnTextStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  final List<ExplanationData> data = [
    ExplanationData(
      description: "Chú ý ghi nhớ những tấm hình vì sau vài giây, bạn phải chọn hình đã biến mất trong những hình đó",
      title: "Trò chơi đó là hình nào",
      localImageSrc: "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExNzAxYTk5ZGY1ZGU5NjM1ODQ3YzhmNmFlOTM4MmJkNDgwZmM0YzEyOCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/PMxwjeqrY45NJZlWZY/giphy.gif",
      backgroundColor: AppColors.primaryColor,
    ),
    ExplanationData(
      description: "Chọn đáp án xong, bạn nhấn kiểm tra để xem kết quả. Bạn có 10 lượt chơi ở đây",
      title: "Trò chơi đó là hình nào",
      localImageSrc: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExYTU0M2VmNGM0NWQwMjc5ODVjZDNkODRmMTc1ZmQxZTEzMmYzZGI4NSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/W7VH11q5OrLnE8QSUG/giphy.gif",
      backgroundColor: AppColors.primaryColor,
    ),
  ];


  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OnBoarding(data: data,)),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.

    if (!mounted) return;
    if (result != null) {
      bool isTrue = result == "true";

      stopTime = isTrue;
      setState(() {

      });
      // Now you can use the `isTrue` boolean value
    }
    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.

  }

  checkLevelValue() {
    if (widget.levelValue == "Easy") {
      pairs = listOfEasy[Random().nextInt(3)];
    } else if (widget.levelValue == "Medium") {
      pairs = listOfMedium[Random().nextInt(2)];
    } else if (widget.levelValue == "Difficult") {
      pairs = getShape();
    }
  }

  // ! Hàm đếm số câu đúng ở level hiện tại để mở khóa level tiếp theo
  checkMnD() {
    switch (widget.levelValue) {
      case "Easy":
        numOfCorrectM++;
        break;
      case "Medium":
        numOfCorrectD++;
        break;
    }
  }

  // !Hàm dùng để lấy hình ảnh cho Question
  setQuestion() {
    setState(() {
      columns = 4;
    });
    if (levels <= 5) {
      // List have 4 Img of pairs
      roundPairs = pickRandomItemsAsListWithSubList(pairs, 4);
      // List get 1 Img of roundPairs
      visiblePairs = pickRandomItemsAsListWithSubList(roundPairs, 1);
      // Get index of item visiblePairs in roundPairs
      for (var element in visiblePairs) {
        index.add(
            roundPairs.indexWhere((innerElement) => innerElement == element));
      }
      selected = true;
    } else if (levels <= 10) {
      roundPairs = pickRandomItemsAsListWithSubList(pairs, 4);
      visiblePairs = pickRandomItemsAsListWithSubList(roundPairs, 2);
      for (var element in visiblePairs) {
        index.add(
            roundPairs.indexWhere((innerElement) => innerElement == element));
      }
      selected = true;
    }
  }

  // ! Hàm dùng để hiển thị Đáp án và thay đáp án thành ? ở Question
  getAnswer() {
    setState(() {
      columns = 4;
    });
    if (levels <= 3) {
      // * Xóa những Img đang xuất hiện trong roundPairs
      pairs.removeWhere((element) => roundPairs.contains(element));

      // * remain lấy bất kì 3 Img từ pairs + visiblePairs
      remain = pickRandomItemsAsListWithSubList(pairs, 3);
      remain = remain + visiblePairs;
      remain.shuffle();

      // * Thay kết quả bằng ảnh ?
      roundPairs.removeWhere((element) => visiblePairs.contains(element));
      roundPairs.insert(index[0], quest[0]);
      roundPairs.shuffle();
      index = [];
      selected = false;
    } else if (levels <= 5) {
      pairs.removeWhere((element) => roundPairs.contains(element));

      remain = pickRandomItemsAsListWithSubList(pairs, 4);
      remain += visiblePairs;
      remain.shuffle();

      roundPairs.removeWhere((element) => visiblePairs.contains(element));
      roundPairs.insert(index[0], quest[0]);
      roundPairs.shuffle();

      index = [];
      selected = false;
    } else if (levels <= 7) {
      pairs.removeWhere((element) => roundPairs.contains(element));

      remain = pickRandomItemsAsListWithSubList(pairs, 3);
      remain += visiblePairs;
      remain.shuffle();

      roundPairs.removeWhere((element) => visiblePairs.contains(element));

      for (int i = 0; i < index.length; i++) {
        roundPairs.insert(i, quest[0]);
        roundPairs.shuffle();
      }

      index = [];
      selected = false;
    } else if (levels <= 10) {
      pairs.removeWhere((element) => roundPairs.contains(element));

      remain = pickRandomItemsAsListWithSubList(pairs, 4);
      remain = remain + visiblePairs;
      remain.shuffle();

      roundPairs.removeWhere((element) => visiblePairs.contains(element));

      for (int i = 0; i < index.length; i++) {
        roundPairs.insert(i, quest[0]);
        roundPairs.shuffle();
      }

      index = [];
      selected = false;
    }
  }

  // ! Hàm được gọi ở btn 'Kiểm Tra' để check kqua
  checkResult() {
    Img = visiblePairs.map((e) => e!.imageAssetPath).toList();
    Img.sort();
    setScore();
    if (levels < 10) {
      if (listEquals(result, Img)) {
        // TODO: Correct

        setState(() {
          _timerCountdown!.cancel();
          _enableBtn = false;
          _disableTap = true;
          showSuccess();
          // levels++;
          score += point;
          // numOfCorrect++;
          checkMnD();
        });
        _timer = Timer(const Duration(seconds: 1), () {
          setState(() {
            levels++;
            start();
            _disableTap = false;
          });
        });
      } else {
        // TODO: Wrong

        setState(() {
          _timerCountdown!.cancel();
          _enableBtn = false;
          _disableTap = true;
          showFail();
          // levels++;
        });
        _timer = Timer(const Duration(seconds: 2), () {
          setState(() {
            _isSwitch = false;
            _endResult = true;
            _disableTap = false;
          });
        });
        _timer2 = Timer(const Duration(seconds: 4), () {
          setState(() {
            levels++;
            start();
            // _disableTap = false;
          });
        });
      }
    } else {
      if (listEquals(result, Img)) {

        setState(() {
          _timerCountdown!.cancel();
          _enableBtn = false;
          _disableTap = true;
          showSuccess();
          score += point;
          // numOfCorrect++;
          checkMnD();
        });
        _timer = Timer(const Duration(seconds: 1), () {
          setState(() {
            _saveDailyMemory();
            navigationPage();
          });
        });
      } else {

        setState(() {
          _timerCountdown!.cancel();
          _enableBtn = false;
          _disableTap = true;
          showFail();
        });
        _timer = Timer(const Duration(seconds: 2), () {
          setState(() {
            _isSwitch = false;
            _endResult = true;
            _disableTap = false;
          });
        });

        _timer2 = Timer(const Duration(seconds: 4), () {
          setState(() {
            _saveDailyMemory();
            navigationPage();
          });
        });
      }
    }
  }

  // ! Func called show result when timeout
  getResult() {
    indices = visiblePairs.map((e) => remain.indexOf(e)).toList();
    return indices;
  }

  // ! Func called _countdownTime in each levels
  setTime() {
    if (levels <= 3) {
      _countdownTime = 10;
      timeInit = 10;
    } else if (levels <= 5) {
      _countdownTime = 12;
      timeInit = 12;
    } else if (levels <= 7) {
      _countdownTime = 16;
      timeInit = 16;
    } else if (levels <= 10) {
      _countdownTime = 20;
      timeInit = 20;
    }
  }

  // ! Func set score
  setScore() {
    if (levels <= 3) {
      point = 100;
    } else if (levels <= 5) {
      point = 200;
    } else if (levels <= 7) {
      point = 300;
    } else if (levels <= 10) {
      point = 400;
    }
  }

  // ! Animation of success
  Timer? _timerSuccess;
  showSuccess() {
    _showSuccess = true;
    _timerSuccess = Timer(const Duration(seconds: 1), () {
      setState(() {
        _showSuccess = false;
      });
    });
  }

  // ! Animation of fail
  showFail() {
    _showFail = true;
    _timerSuccess = Timer(const Duration(seconds: 2), () {
      setState(() {
        _showFail = false;
      });
    });
  }

  // // ! Animation of TimeOut
  // showTimeout() {
  //   _showTimeout = true;
  //   _timerSuccess = Timer(Duration(seconds: 2), () {
  //     setState(() {
  //       _showTimeout = false;
  //     });
  //   });
  // }

  // ! Func call Result page
  navigationPage() {
    setState(() {
      saveBtn();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CongratM3Screen(levelValue: widget.levelValue,)),
      );
    });
  }

  // ! Func for countdown time
  void countDown() {
    _timerCountdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownTime == 0) {
          if (levels < 10) {
            // _timerCountdown!.cancel();

            setState(() {
              _timerCountdown!.cancel();
              _enableBtn = false;
              _disableTap = true;
              // showTimeout();
              showFail();
              // levels++;
            });
            _timer = Timer(const Duration(seconds: 2), () {
              setState(() {
                _isSwitch = false;
                _endResult = true;
                _disableTap = false;
              });
            });
            _timer2 = Timer(const Duration(seconds: 4), () {
              setState(() {
                levels++;
                start();
              });
            });
          } else {

            setState(() {
              _timerCountdown!.cancel();
              _enableBtn = false;
              _disableTap = true;
              // showTimeout();
              showFail();
            });
            _timer = Timer(const Duration(seconds: 2), () {
              setState(() {
                _isSwitch = false;
                _endResult = true;
                _disableTap = false;
              });
            });
            _timer2 = Timer(const Duration(seconds: 4), () {
              setState(() {
                _saveDailyMemory();
                navigationPage();
              });
            });
          }
        } else {
          if (stopTime == false) {
            _countdownTime--;
          } else {
            _countdownTime -= 0;
          }

          responseTime++;
        }
      });
    });
  }

  start() {
    _isSwitch = true;

    setTime();
    remain = [];
    result = [];
    quest = getQuestion();

    setQuestion();
    _enableBtn = false;
    _isButtonCheck = false;
    _timer = Timer(const Duration(seconds: 6), () {
      setState(() {
        _enableBtn = true;
        _isButtonCheck = true;
        getAnswer();
        countDown();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setStaryPlay();
    checkLevelValue();
    numOfCorrectM = 0;
    numOfCorrectD = 0;
    score = 0;
    levels = 1;
    start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timerCountdown?.cancel();
    _timerSuccess?.cancel();
    _timer?.cancel();
    _timer2?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    final w = (MediaQuery.of(context).size.width - runSpacing * (columns - 1)) /
        columns;

    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffe5f6fe),
          body: SizedBox(
            width: screen_width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // * Icons line
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.spaceBetween,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {

                            showExitDialog(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                          iconSize: 30,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _navigateAndDisplaySelection(context);
                            stopTime = true;
                          },
                          icon: const Icon(
                            Icons.question_mark_rounded,
                            size: 30,
                          ),
                          color: Colors.black,
                        ),
                        IconButton(
                          onPressed: () {

                          },
                          icon: const Icon(Icons.settings),
                          iconSize: 30,
                        ),
                      ],
                    ),
                  ],
                ),

                // * Dashboard
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Lượt chơi",
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$levels/10",
                            style: const TextStyle(
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Điểm số",
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            // timeLeft.toString(),
                            // "$score",
                            "$score",
                            style: const TextStyle(
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: screen_height / 20,
                ),
                _isButtonCheck
                    ? LinearPercentIndicator(
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 20,
                        percent: _countdownTime / timeInit,
                        animateFromLastPercent: true,
                        linearGradient: const LinearGradient(
                            colors: [Color(0xfff6b85f), Color(0xfff6905f)]),
                        barRadius: const Radius.circular(20),
                        // progressColor: Colors.orangeAccent,
                        backgroundColor: Colors.white70,
                      )
                    : Container(),

                SizedBox(
                  height: screen_height / 20,
                ),

                // * Game
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // * Question here
                      Center(
                        child: Wrap(
                          runSpacing: runSpacing,
                          spacing: spacing,
                          alignment: WrapAlignment.center,
                          children: List.generate(roundPairs.length, (index) {
                            return SizedBox(
                              width: w,
                              height: w,
                              child: Tile(
                                imageAssetPath:
                                    roundPairs[index].getImageAssetPath(),
                                tileIndex: index,
                                parent: this,
                                isBorder: false,
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(
                        height: screen_height / 30,
                      ),
                      const Text(
                        "Đáp án chính xác là",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: screen_height / 30,
                      ),
                      // * Answer here
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Wrap(
                              runSpacing: runSpacing,
                              spacing: spacing,
                              alignment: WrapAlignment.center,
                              children: List.generate(remain.length, (index) {
                                getResult();
                                return SizedBox(
                                  width: w,
                                  height: w,
                                  child: Tile(
                                    imageAssetPath:
                                        remain[index].getImageAssetPath(),
                                    tileIndex: index,
                                    parent: this,
                                    isBorder: indices.contains(index),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Visibility(
                            visible: _showSuccess,
                            child: Center(
                              child: Container(
                                child: Lottie.network(
                                  "https://assets4.lottiefiles.com/packages/lf20_rc5d0f61.json",
                                  height: 150,
                                  repeat: true,
                                  reverse: true,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _showFail,
                            child: Center(
                              child: Container(
                                child:
                                    // Lottie.asset(
                                    //   'assets/animations/fail.json',
                                    //   height: 150,
                                    //   repeat: true,
                                    //   reverse: true,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    Lottie.network(
                                  "https://assets7.lottiefiles.com/packages/lf20_pqpmxbxp.json",
                                  height: 150,
                                  repeat: true,
                                  reverse: true,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // Visibility(
                          //   visible: _showTimeout,
                          //   child: Center(
                          //     child: Container(
                          //       child: Lottie.asset(
                          //         'assets/animations/timeout.json',
                          //         height: 200,
                          //         repeat: true,
                          //         reverse: true,
                          //         fit: BoxFit.cover,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),

                // * Button check
                _isButtonCheck
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                            onPressed: _enableBtn
                                ? () {

                                    checkResult();

                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                            child: const Center(
                              child: Text(
                                "Kiểm tra",
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  String imageAssetPath;
  int tileIndex;
  _MemoryThreeScreenState parent;
  final bool isBorder;

  Tile({
    required this.imageAssetPath,
    required this.tileIndex,
    required this.parent,
    required this.isBorder,
  });

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.parent._disableTap
          ? null
          : () {
              if (!selected) {


                if (selectedImageAssetPath != []) {
                  selectedImageAssetPath.add(widget.imageAssetPath);

                  contain = remain.where((element) =>
                      element.imageAssetPath == selectedImageAssetPath[0]);
                  if (contain.isEmpty) {
                    // TODO: Not check

                    selectedImageAssetPath = [];
                  } else {
                    // TODO: Check here

                    selectedImageAssetPath = [];
                    setState(() {
                      _isSelected = !_isSelected;
                    });
                    if (_isSelected) {
                      setState(() {
                        result.add(widget.imageAssetPath);

                      });
                    } else {
                      setState(() {
                        result.remove(widget.imageAssetPath);

                      });
                    }
                    result.sort();
                  }
                }
              }
            },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: widget.parent._isSwitch
              ? _isSelected
                  ? const BorderSide(color: Colors.blue, width: 3)
                  : BorderSide.none
              : widget.parent._endResult
                  ? widget.isBorder
                      ? const BorderSide(color: Colors.blue, width: 3)
                      : BorderSide.none
                  : BorderSide.none,
        ),
        child: ClipRect(
          child: Image.asset(widget.imageAssetPath),
        ),
      ),
    );
  }
}
