import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../viewModel/data/data_attention/data_attention_two.dart';
import '../../../../../viewModel/data/data_onborad/data_attention_2.dart';
import '../../../../../shared/app_styles.dart';
import '../../../../onboarding/explanation.dart';
import '../../../../onboarding/home.dart';
import 'level_att2.dart';
import 'result_att2.dart';

class AttentionTwoScreen extends StatefulWidget {
  final String levelValue;
  const AttentionTwoScreen({required this.levelValue});

  @override
  State<AttentionTwoScreen> createState() => _AttentionTwoScreenState();
}

class _AttentionTwoScreenState extends State<AttentionTwoScreen> {
  final double runSpacing = 5;
  final double spacing = 1;
  int columns = 4;
  double _countDownTime = 0;
  double timeInit = 0;
  bool _showSuccess = false;
  bool _showFail = false;
  bool _disableTap = false;
  Timer? _timer;
  Timer? _timerCountdown;

  // //! Save Daily workout Att
  Future<void> _saveDailyAtt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("DailyAtt", true);
    await prefs.setInt("date", DateTime.now().millisecondsSinceEpoch);
  }

  bool stopTime = false;
  bool setPlaygame = false;

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
        _timerCountdown!.cancel();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) =>const LevelA2Screen()));
        Navigator.popUntil(context, ModalRoute.withName('/game2Atten'));
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
        description:
        "Hãy nhanh tay tìm kiếm 2 hình giống nhau nếu đúng sẽ có một dấu tích màu xanh hiện lên",
        title: "Trò chơi Bắt cặp" ,
        localImageSrc: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExZWNiNjNiMzdlMGY0MjljNDI5ZjNlZjI4MDMwN2U4M2QxNWNkNjI4YyZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/mpmaerMNMArM7cE4ON/giphy.gif",
        backgroundColor: AppColors.primaryColor),
    ExplanationData(
        description:
        "Còn nếu chọn sai thì sẽ game sẽ tự bỏ cái bạn đã chọn ban đầu",
        title: "Trò chơi Bắt cặp" ,
        localImageSrc: "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExMTVjOTRmNjgyZmQxN2VhZjJiMmQ2NzRjZGE1YTExOTlkNGRmYjI3ZCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/jopadonYASybcYHZEz/giphy.gif",
        backgroundColor: AppColors.primaryColor),
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

  // ! Func used to count down time
  void countDown() {

    _timerCountdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countDownTime == 0) {
          setState(() {
            _timerCountdown!.cancel();
            _disableTap = true;
            showFail();
          });
          _timer = Timer(const Duration(seconds: 1), () {
            setState(() {
              duplicatedImage = [];
              tries++;
              setTime();
              removeBorder();
              checkEnd();
            });
          });
        } else {
          if (stopTime == false) {
            _countDownTime -= 1;
          } else {
            _countDownTime -= 0;
          }

          responseTime++;
        }
      });
    });
  }

  //! Hàm đếm số cặp đúng ở level hiện tại
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

  // !Animation of success
  Timer? _timerSuccess;
  showSuccess() {
    _showSuccess = true;
    _timerSuccess = Timer(Duration(seconds: 1), () {
      setState(() {
        _disableTap = false;
        _showSuccess = false;
      });
    });
  }

  // !Animation of fail
  showFail() {
    _showFail = true;
    _timerSuccess = Timer(Duration(milliseconds: 1500), () {
      setState(() {
        _showFail = false;
        _disableTap = false;
      });
    });
  }

  // ! Navigator to Result page
  navigationPage() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CongratA2Screen(levelValue: widget.levelValue,)),
      );
    });
  }

  //! used to count down the time when playing
  setTime() {
    if (tries == 1) {
      _countDownTime = 15;
      timeInit = 15;
    } else if (tries == 2) {
      _countDownTime = 20;
      timeInit = 20;
    } else if (tries == 3) {
      _countDownTime = 25;
      timeInit = 25;
    } else if (tries == 4) {
      _countDownTime = 30;
      timeInit = 30;
    } else if (tries == 5) {
      _countDownTime = 35;
      timeInit = 35;
    } else if (tries == 6) {
      _countDownTime = 40;
      timeInit = 40;
    } else if (tries == 7) {
      _countDownTime = 45;
      timeInit = 45;
    } else if (tries == 8) {
      timeInit = 50;
      _countDownTime = 50;
    }
  }

  // ! Xóa viền ảnh
  void removeBorder() {
    setState(() {
      border = [];
      selectedImageBorderColor = Colors.transparent;
    });
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

  checkEnd() async {
    numOfPairs++;
    getImg.clear;

    if (tries > 8) {
      // ! Navigator to result page

      setState(() {
        _saveDailyAtt();
      });
      navigationPage();
    } else {
      // ! Continues game
      start();
    }
  }

  Future<void> setStaryPlay() async {
    bool saveSetPlay = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveSetPlay = prefs.getBool("setPlaygameAtte2") ?? false;
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
    await prefs.setBool('setPlaygameAtte2', setPlaygame);
  }

  start() {
    duplicatedImage.clear();
    correctIndex = [];
    _disableTap = false;
    getImg = pickRandomItemsAsListWithSubList(pairs, numOfPairs);
    duplicatedImage.addAll(getImg);
    duplicatedImage.addAll(getImg);
    duplicatedImage.shuffle();
    print('NumOfPair: $numOfPairs');
    setTime();
    countDown();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    responseTime = 0;
    setStaryPlay();
    border = [];
    selectedTile = '';
    selectedIndex = -1;
    numOfCorrectM = 0;
    numOfCorrectD = 0;
    score = 0;
    checkLevelValue();
    duplicatedImage = [];
    tries = 1;
    numOfPairs = 3; //! 3-10 pairs
    start();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer!.cancel();
    _timerSuccess!.cancel();
    _timerCountdown?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          // ! App bar
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xff0bb5a4),
            leading: IconButton(
              color: Colors.white,
              onPressed: () {

                showExitDialog(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 30,
            ),
            title: Center(
              child: Text(
                "Màn $tries",
                style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 1,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            actions: [
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
                color: Colors.white,
                onPressed: () {

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const HomePage()));
                },
                icon: const Icon(Icons.settings),
                iconSize: 30,
              ),
            ],
          ),
          body: Column(children: [
            // ! Heading
            Container(
              height: size.height * 0.2,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff0bb5a4),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/memory1/reward.png",
                        height: 40,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Điểm: ',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$score",
                        style: const TextStyle(fontSize: 24, color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screen_height / 30,
                  ),
                  LinearPercentIndicator(
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: 20,
                    percent: _countDownTime / timeInit,
                    animateFromLastPercent: true,
                    linearGradient: const LinearGradient(
                        colors: [Color(0xfff6b85f), Color(0xfff6905f)]),
                    barRadius: const Radius.circular(20),
                    // progressColor: Colors.orangeAccent,
                    backgroundColor: Colors.white70,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Wrap(
                      runSpacing: runSpacing,
                      spacing: spacing,
                      alignment: WrapAlignment.center,
                      children: List.generate(duplicatedImage.length, (index) {
                        return SizedBox(
                          width: w,
                          height: w,
                          child: Tile(
                            imageAssetPath:
                                duplicatedImage[index].getImageAssetPath(),
                            tileIndex: index,
                            parent: this,
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
                          height: 200,
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
                            // 'assets/animations/fail_att2.json',
                            // height: 200,
                            // repeat: true,
                            // reverse: true,
                            // fit: BoxFit.cover,
                            // ),
                            Lottie.network(
                          "https://assets7.lottiefiles.com/packages/lf20_pqpmxbxp.json",
                          height: 200,
                          repeat: true,
                          reverse: true,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  String imageAssetPath;
  int tileIndex;
  _AttentionTwoScreenState parent;

  Tile({
    required this.imageAssetPath,
    required this.tileIndex,
    required this.parent,
  });
  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.parent._disableTap
          ? null
          : () {
              if (!selected) {
                setState(() {
                  // ! Remove border (Unselected & Not check)
                  if (border.contains(widget.tileIndex) ||
                      correctIndex.contains(widget.imageAssetPath)) {
                    selectedTile = '';
                    widget.parent.removeBorder();
                  } else {
                    // ! Add border (Selected & Check)
                    border.add(widget.tileIndex);
                    selectedImageBorderColor = Colors.blueAccent;

                    //? Add
                    setState(() {
                      duplicatedImage[widget.tileIndex].setIsSelected(true);
                    });

                    if (selectedTile != '') {
                      // ! Check here
                      if (selectedTile == widget.imageAssetPath) {
                        // TODO: Correct

                        correctIndex.add(widget.imageAssetPath);
                        score += 100;
                        widget.parent.setState(() {
                          widget.parent.checkMnD();
                        });
                        if (correctIndex.length == duplicatedImage.length / 2) {
                          // TODO: End tries

                          //! Disable tap
                          widget.parent.setState(() {
                            widget.parent._disableTap = true;
                            widget.parent.showSuccess();
                            widget.parent._timerCountdown!.cancel();
                          });

                          //! After 1: restart game {start()}
                          widget.parent._timer =
                              Timer(const Duration(seconds: 1), () {
                            tries++;
                            widget.parent.setTime();
                            widget.parent.removeBorder();
                            widget.parent.checkEnd();
                          });
                        } else {
                          //! Disable tap
                          widget.parent.setState(() {
                            widget.parent._disableTap = true;
                          });
                          // ! After 1s remove pairs Img
                          widget.parent._timer =
                              Timer(const Duration(microseconds: 500), () {
                            widget.parent.setState(() {
                              widget.parent.removeBorder();
                              widget.parent._disableTap = false;
                            });
                          });
                        }
                      } else {

                        // ! disable Tap and show wrong
                        widget.parent.setState(() {
                          widget.parent._disableTap = true;
                        });

                        widget.parent._timer =
                            Timer( const Duration(microseconds: 500), () {
                          widget.parent.setState(() {
                            widget.parent.removeBorder();
                            widget.parent._disableTap = false;
                          });
                        });
                      }

                      selectedTile = '';
                      selectedIndex = -1;
                    } else {
                      // ! Selected IMG 1
                      // selectedTile = widget.imageAssetPath;
                      selectedTile =
                          duplicatedImage[widget.tileIndex].getImageAssetPath();
                      selectedIndex = widget.tileIndex;
                    }
                  }
                });
              }

            },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: border.contains(widget.tileIndex)
              ? BorderSide(color: selectedImageBorderColor, width: 3)
              : BorderSide.none,
        ),
        elevation: 10,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(correctIndex.contains(widget.imageAssetPath)
                ? 'assets/memory1/correct.png'
                : widget.imageAssetPath),
          ),
        ),
      ),
    );
  }
}
