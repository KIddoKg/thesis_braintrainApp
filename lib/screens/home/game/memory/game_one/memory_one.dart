import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../viewModel/data/data_memory/data_memory_one.dart';
import '../../../../../viewModel/data/data_onborad/data_memory_1.dart';
import '../../../../../services/services.dart';
import '../../../../../shared/app_styles.dart';
import '../../../../onboarding/explanation.dart';
import '../../../../onboarding/home.dart';
import '../Memory_Screen.dart';
import 'result_m1.dart';

class MemoryOne extends StatefulWidget {
  const MemoryOne({super.key});

  @override
  State<MemoryOne> createState() => _MemoryOneState();
}

class _MemoryOneState extends State<MemoryOne> {
  bool stopTime = false; // Bool dùng để kiểm tra có coi Hướng Dẫn ko?
  bool setPlaygame = false;
  bool _isLoading = false; //  Loading sau mỗi màn chơi (hiện cấp độ)
  int numOfRow = 0; //  Số card trên 1 hàng
  bool _showOverlay = false; // Bool hiện đếm ngược
  bool _disableTap = false; // Bool để block tap
  int highlight = 0; // Số card sáng (màu xanh)
  bool _showFail = false; // Bool dùng để hiển thị Gif sai
  bool _showSuccess = false; // Bool dùng để hiển thị Gif đúng
  Timer? _timerLevel;
  Timer? _timerGoResult;
  bool enableIntro = false; // Bool dùng để chặn mở hướng dẫn

  // ! Hiển thị thông báo thoát game
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) =>const MemoryScreen()));
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

  // ! Hàm hiển thị hướng dẫn chơi game
  final List<ExplanationData> data = [
    ExplanationData(
      description: "Sau khi xong đếm ngược 3s, sẽ có một ô khác màu hiện lên nhiệm vụ của bạn là nhanh chóng ghi nhớ lại và chọn lại đúng vị trí đó",
      title: "Trò chơi Ghi nhớ màu",
      localImageSrc: "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExZTMwOGU5NzRmZWQ1NzVmZTcyNzRkNmY1ZWViY2M0YzlhZGE1YTg2NiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/tDNxp8il9rT2ip5Cg5/giphy.gif",
      backgroundColor: AppColors.primaryColor,
    ),
    ExplanationData(
      description: "Nếu đúng sẽ có dấu tích xanh hiện lên. Tùy vào từng cấp độ bạn chỉ có thể sai tối đa bao nhiêu lần",
      title: "Trò chơi Ghi nhớ màu",
      localImageSrc: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExMDVjY2MyYjMxZWRhM2Q4N2VhODU5YTc0NzMxZDUxNzllMTNiYjUzNCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/zOuqNA1XQU2ekAL6Aq/giphy.gif",
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

  //!  Setup number of highlight of each level
  cardOfLevel(numOfB, numOfW) {
    pairsBlue = getBlue();
    pairsWhite = getWhite();
    total = numOfB + numOfW;
    pairs = pickRandomItemsAsListWithSubList(pairsBlue, numOfB) +
        pickRandomItemsAsListWithSubList(pairsWhite, numOfW);
    visiblePairs = pickRandomItemsAsListWithSubList(pairsWhite, total);
    selected = true;
    _showOverlay = true;

    // _timer1 = Timer(Duration(seconds: 4), () {
    //   setState(() {
    //     pairs.shuffle();
    //     visiblePairs = pairs;
    //     selected = true;
    //     _showOverlay = false;
    //   });
    // });
    // _timer2 = Timer(Duration(seconds: 6), () {
    //   setState(() {
    //     selected = false;
    //     visiblePairs = pickRandomItemsAsListWithSubList(pairsWhite, total);
    //     startTimer();
    //   });
    // });
  }

  displayLevel() {
    if (level == 1) {
      // 2x3
      cardOfLevel(1, 5);
      numOfRow = 3;
      highlight = level;
      error = 1;
      timeLeft = 10;
    } else if (level == 2) {
      // 3x3
      cardOfLevel(2, 7);
      numOfRow = 3;
      highlight = level;
      error = 1;
      timeLeft = 10;
    } else if (level == 3) {
      // 3x4
      cardOfLevel(3, 9);
      numOfRow = 4;
      highlight = level;
      error = 1;
      timeLeft = 10;
    } else if (level == 4) {
      // 4x4
      cardOfLevel(4, 12);
      numOfRow = 4;
      highlight = level;
      error = 1;
      timeLeft = 10;
    } else if (level == 5) {
      // 4x5
      cardOfLevel(5, 15);
      numOfRow = 4;
      highlight = level;
      error = 2;
      timeLeft = 10;
    } else if (level == 6) {
      // 4x5
      cardOfLevel(6, 14);
      numOfRow = 4;
      highlight = level;
      error = 2;
      timeLeft = 15;
    } else if (level == 7) {
      // 5x5
      cardOfLevel(7, 18);
      numOfRow = 5;
      highlight = level;
      error = 3;
      timeLeft = 20;
    } else if (level == 8) {
      // 5x6
      cardOfLevel(8, 22);
      numOfRow = 5;
      highlight = level;
      error = 3;
      timeLeft = 20;
    } else if (level == 9) {
      // 5x6
      cardOfLevel(9, 21);
      numOfRow = 5;
      highlight = level;
      error = 4;
      timeLeft = 20;
    } else if (level == 10) {
      // 6x6
      cardOfLevel(10, 26);
      numOfRow = 6;
      error = 4;
      highlight = level;
      timeLeft = 25;
    } else if (level == 11) {
      // 6x7
      cardOfLevel(11, 31);
      numOfRow = 6;
      error = 4;
      highlight = level;
      timeLeft = 25;
    } else if (level == 12) {
      // 6x7
      cardOfLevel(12, 30);
      numOfRow = 6;
      error = 4;
      highlight = level;
      timeLeft = 30;
    } else if (level == 13) {
      // 7x7
      cardOfLevel(13, 36);
      numOfRow = 7;
      error = 4;
      highlight = level;
      timeLeft = 30;
    } else if (level == 14) {
      // 7x7
      cardOfLevel(14, 35);
      numOfRow = 7;
      error = 4;
      highlight = level;
      timeLeft = 30;
    } else if (level == 15) {
      // 7x8
      cardOfLevel(15, 41);
      numOfRow = 7;
      error = 4;
      highlight = level;
      timeLeft = 35;
    } else if (level == 16) {
      // 7x8
      cardOfLevel(16, 40);
      numOfRow = 7;
      highlight = level;
      error = 4;
      timeLeft = 35;
    } else if (level == 17) {
      // 8x8
      cardOfLevel(17, 47);
      numOfRow = 8;
      highlight = level;
      error = 4;
      timeLeft = 40;
    } else if (level == 18) {
      // 8x8
      cardOfLevel(18, 46);
      numOfRow = 8;
      error = 4;
      highlight = level;
      timeLeft = 40;
    } else if (level == 19) {
      // 8x8
      cardOfLevel(19, 45);
      numOfRow = 8;
      highlight = level;
      error = 4;
      timeLeft = 40;
    } else if (level == 20) {
      // 8x9
      cardOfLevel(20, 52);
      numOfRow = 8;
      highlight = level;
      error = 5;
      timeLeft = 45;
    } else if (level == 21) {
      // 8x9
      cardOfLevel(21, 51);
      numOfRow = 8;
      highlight = level;
      error = 5;
      timeLeft = 45;
    } else if (level == 22) {
      // 9x9
      cardOfLevel(22, 59);
      numOfRow = 9;
      highlight = level;
      error = 5;
      timeLeft = 50;
    } else if (level == 23) {
      // 9x9
      cardOfLevel(23, 58);
      numOfRow = 9;
      highlight = level;
      error = 5;
      timeLeft = 50;
    } else if (level == 24) {
      // 9x9
      cardOfLevel(24, 57);
      numOfRow = 9;
      highlight = level;
      error = 5;
      timeLeft = 50;
    } else if (level == 25) {
      // 9x10
      cardOfLevel(25, 65);
      numOfRow = 9;
      highlight = level;
      error = 5;
      timeLeft = 55;
    } else if (level == 26) {
      // 9x10
      cardOfLevel(26, 64);
      numOfRow = 9;
      highlight = level;
      error = 5;
      timeLeft = 55;
    } else if (level == 27) {
      // 9x10
      cardOfLevel(27, 63);
      numOfRow = 9;
      highlight = level;
      error = 5;
      timeLeft = 60;
    } else if (level == 28) {
      // 10x10
      cardOfLevel(28, 72);
      numOfRow = 10;
      highlight = level;
      error = 5;
      timeLeft = 60;
    } else if (level == 29) {
      // 10x10
      cardOfLevel(29, 71);
      numOfRow = 10;
      highlight = level;
      error = 5;
      timeLeft = 60;
    } else if (level == 30) {
      // 10x10
      cardOfLevel(30, 70);
      numOfRow = 10;
      error = 5;
      highlight = level;
      timeLeft = 60;
    }
  }

  //! Hàm để block giữa các lần chọn trong 1 màn
  void disableTap() {
    selected = true;
    Future.delayed(const Duration(microseconds: 100), () {
      selected = false;
    });
  }

  // ! Hàm bắt đầu của mỗi màn chơi
  start() {
    _disableTap = false;
    numOfCorrect = 0;
    numOfWrong = 0;
    store = [];
    percent = 3;
    level;
    displayTimer();
  }

  // ! Hiển thị những ô đúng còn lại (chưa chọn) khi end game
  showResult() {
    result = getResult();
    for (int i = 0; i < indexResult.length; i++) {
      pairs[indexResult[i]] = result[0];
    }
    setState(() {
      visiblePairs = pairs;
    });
  }

  //TODO: 3 Hàm xử lý khi chọn sai
  // ! Animation of Wrong
  Timer? _timerSuccess;
  showFail() {
    _showFail = true;
    _disableTap = true;

    _timerSuccess = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showFail = false;
      });
    });
  }

  //! Hàm show result and then showFail after 1s
  Timer? _timer3;
  screenLevelDown() async {
    await showResult();
    _timer3 = Timer(const Duration(seconds: 1), () {
      setState(() {
        showFail();
      });
    });
  }

  //! Level down
  void levelDown() {
    timeLoading = 2;
    level -= numOfWrong ~/ 2;
    tries++;
    isLoading();
  }

  //TODO: 2 Hàm gọi khi chọn đúng hết
  // ! Animation of Wrong
  showSuccess() {
    _showSuccess = true;

    // Hiện icon success trong vòng 3s
    _timerSuccess = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showSuccess = false;
      });
    });
  }

  //! Level up
  void levelUp() {
    timeLoading = 2;
    level++;
    tries++;
    isLoading();
  }

  // ! Time 1: Thời gian hiển thị level
  int timeLoading = 2;
  late Timer _timerLoading;
  isLoading() {
    enableIntro = false;
    _isLoading = true;
    _timerLoading = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLoading == 0) {
          //! Chuyển qua time 2: Thời gian 3s count down
          _timerLoading.cancel();
          _isLoading = false;
          displayLevel();
          start();
        } else {
          if (stopTime == false) {
            timeLoading--;
          } else {
            timeLoading -= 0;
          }
        }
      });
    });
  }

  // ! Time 2: Thời gian 3s để count down
  int percent = 3;
  Timer? timer;
  displayTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      setState(() {
        if (percent == 0) {
          //! Chuyển qua time 3: Thời gian 3s để high light
          timer?.cancel();
          highLight();
          timeHighLight = 3;
          pairs.shuffle();
          visiblePairs = pairs;
          _disableTap = true;
          selected = true;
          _showOverlay = false;
        } else {
          if (stopTime == false) {
            percent--;
          } else {
            percent -= 0;
          }
        }
      });
    });
  }

  // ! Time 3: Thời gian 3s để high light
  int timeHighLight = 3;
  highLight() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeHighLight == 0) {
          //! Chuyển qua time 4: Thời gian chơi game
          timer.cancel();
          _disableTap = false;
          selected = false;
          visiblePairs = pickRandomItemsAsListWithSubList(pairsWhite, total);
          countDown();
        } else {
          if (stopTime == false) {
            timeHighLight--;
          } else {
            timeHighLight -= 0;
          }
        }
      });
    });
  }

  //! Time 4: Thời gian chơi game
  Timer? _timer;
  countDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft == 0) {
          timer.cancel();

          if ((numOfWrong == 0 || numOfWrong > 0) && tries < 12) {
            _disableTap = true;
            enableIntro = true;

            screenLevelDown();

            indexResult = [];

            _timerLevel = Timer(const Duration(seconds: 4), () {
              setState(() {
                levelDown();
              });
            });
          } else if (tries >= 12) {
            _disableTap = true;
            enableIntro = true;
            screenLevelDown();

            if (maxLevel < level) {
              maxLevel = level;
              _saveMaxLevel();
              _saveDailyMemory();
            }

            _timerGoResult = Timer(const Duration(seconds: 4), () {
              setState(() {
                navigationPage();
              });
            });
          }
        } else {
          if (stopTime == false) {
            timeLeft--;
          } else {
            timeLeft -= 0;
          }
        }
      });
    });
  }

  //! Hàm dừng thời gian
  void stopTimer() {
    _timer?.cancel();
  }

  // ! Navigation to Result page
  navigationPage() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CongratScreen()),
      );
    });
  }

  //! save daily workout of game math
  Future<void> _saveDailyMemory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("DailyMemory", true);
    await prefs.setInt("date", DateTime.now().millisecondsSinceEpoch);
  }

  // !Save maxLevel into Shared Preference
  Future<void> _saveMaxLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('max', maxLevel);
  }

  // !Get maxLevel from Shared Preference
  Future<void> _loadMaxLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    maxLevel = prefs.getInt('max') ?? 0;
    if(maxLevel == 0) {
      var res = await Services.instance.setContext(context).getDataPlayGameUser(
          "POSITION");
      if (res!.isSuccess) {
        maxLevel = res.data['level'];
      } else {
        maxLevel = 1;
      }
    }
    setState(() {

    });
  }

  initLevel() async {
    await _loadMaxLevel();
    if (maxLevel <= 1) {
      level = 1;
    } else {
      level = maxLevel ~/ 2;
    }
  }

  Future<void> setStaryPlay() async {
    bool saveSetPlay = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveSetPlay = prefs.getBool("setPlaygameMemo1") ?? false;
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
    await prefs.setBool('setPlaygameMemo1', setPlaygame);
  }

  @override
  void initState() {
    super.initState();
    setStaryPlay();
    _loadMaxLevel();
    tries = 1;
    score = 0;
    timeLoading = 2;
    initLevel();
    isLoading();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timerLoading.cancel();
    timer?.cancel();
    _timerSuccess?.cancel();
    _timer3?.cancel();
    _timerLevel?.cancel();
    _timerGoResult?.cancel();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        //! Back here
        showExitDialog(context);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          //! App bar
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xffe5f6fe),
            leading: IconButton(
              color: Colors.black,
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
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            actions: [
              IconButton(
                // TODO: bấm vào hướng dẫn chơi => stopTime = true
                onPressed: enableIntro
                    ? null
                    : () {
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
                color: Colors.black,
                onPressed: () {

                },
                icon: const Icon(Icons.settings),
                iconSize: 30,
              ),
            ],
          ),
          backgroundColor: const Color(0xffe5f6fe),
          body: SizedBox(
            width: screen_width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ! Dashboard
                SizedBox(
                  height: screen_height / 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IntrinsicWidth(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image.asset(
                                  'assets/memory1/star.png',
                                  height: 35.0,
                                  width: 35.0,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  'Điểm: $score',
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ! Game
                _isLoading
                    ? Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Cấp Độ $level",
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const SpinKitPouringHourGlassRefined(
                                color: Color(0xff0081c9),
                                size: 100,
                                duration: Duration(seconds: 1),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: Stack(
                          children: [
                            Center(
                              child: GridView(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20, bottom: 10),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: numOfRow),
                                children: List.generate(visiblePairs.length,
                                    (index) {
                                  return Tile(
                                    imageAssetPath: visiblePairs[index]
                                        .getImageAssetPath(),
                                    parent: this,
                                    tileIndex: index,
                                  );
                                }),
                              ),
                            ),
                            Visibility(
                              visible: _showOverlay,
                              child: Center(
                                child: CircularPercentIndicator(
                                  circularStrokeCap: CircularStrokeCap.round,
                                  percent: percent / 3,
                                  animation: true,
                                  animateFromLastPercent: true,
                                  radius: 70.0,
                                  lineWidth: 10.0,
                                  progressColor: Colors.blueAccent,
                                  center: Text(
                                    "$percent",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 70,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _showSuccess,
                              child: Center(
                                child: Container(
                                  child:
                                      // Lottie.asset(
                                      //     'assets/animations/success.json',
                                      //     height: 200,
                                      //     repeat: true,
                                      //     reverse: true,
                                      //     fit: BoxFit.cover),
                                      Lottie.network(
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
                                      // 'assets/animations/fail.json',
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
  _MemoryOneState parent;
  Tile({
    required this.imageAssetPath,
    required this.parent,
    required this.tileIndex,
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

              // print(selected);
              if (!selected) {
                if (store.contains(widget.tileIndex) == true) {
                  //! Not check

                } else {
                  //! Save các ô đã chọn (CHECK HERE)
                  store.add(widget.tileIndex);
                  setState(() {
                    pairs[widget.tileIndex].setIsSelected(true);
                  });

                  if (selectedImageAssetPath == '') {
                    selectedTileIndex = widget.tileIndex;
                    selectedImageAssetPath =
                        pairs[widget.tileIndex].getImageAssetPath();

                    if (selectedImageAssetPath == "assets/memory1/blue.png") {
                      //! Correct

                      numOfCorrect++;
                      score += 200;
                      widget.parent.disableTap();
                    } else {
                      //! Wrong

                      numOfWrong++;
                      widget.parent.disableTap();

                      //! Set result
                      indexResult.add(widget.tileIndex);

                    }
                    selectedImageAssetPath = '';

                    // ! Continue
                    if (numOfWrong == error ||
                        numOfCorrect == widget.parent.highlight ||
                        timeLeft == 0) {
                      //! END TRIE game

                      widget.parent.stopTimer();
                      indexResult = [];
                      if (tries < 12) {
                        //! Exist wrong (tồn tại ít nhất 1 hình sai)
                        if (numOfWrong <= error && numOfWrong > 0) {
                          widget.parent.setState(() {
                            widget.parent._disableTap = true;
                            widget.parent.enableIntro = true;
                          });
                          widget.parent.screenLevelDown();

                          widget.parent._timerLevel =
                              Timer(const Duration(seconds: 4), () {
                            setState(() {
                              widget.parent.levelDown();
                            });
                          });
                        }

                        // ! All correct
                        if (numOfCorrect == widget.parent.highlight &&
                            numOfWrong == 0) {
                          //! Hiện gif trong 3s

                          widget.parent.setState(() {
                            widget.parent._disableTap = true;
                            widget.parent.enableIntro = true;
                            widget.parent.showSuccess();
                          });

                          widget.parent._timerLevel =
                              Timer(const Duration(seconds: 3), () {
                            setState(() {
                              score += 100 * level;
                              widget.parent.levelUp();
                            });
                          });
                        }
                      } else {
                        //! END GAME

                        if (maxLevel < level) {
                          maxLevel = level;
                          widget.parent._saveDailyMemory();
                          widget.parent._saveMaxLevel();
                        }
                        widget.parent.stopTimer();

                        //! All correct ở màn 12
                        if (numOfCorrect == widget.parent.highlight &&
                            numOfWrong == 0) {
                          widget.parent.setState(() {
                            widget.parent._disableTap = true;
                            widget.parent.enableIntro = true;
                            widget.parent.showSuccess();
                          });

                          widget.parent._timerGoResult =
                              Timer(const Duration(seconds: 4), () {
                            setState(() {
                              widget.parent.navigationPage();
                            });
                          });
                        }

                        //! Exist Wrong ở màn 12
                        if (numOfWrong <= error && numOfWrong > 0) {
                          widget.parent.setState(() {
                            widget.parent._disableTap = true;
                            widget.parent.enableIntro = true;
                          });
                          widget.parent.screenLevelDown();
                          widget.parent._timerGoResult =
                              Timer(const Duration(seconds: 4), () {
                            setState(() {
                              widget.parent.navigationPage();
                            });
                          });
                        }
                      }
                    }
                  }
                }
              }
            },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(pairs[widget.tileIndex].getIsSelected()
              ? pairs[widget.tileIndex].getImageAssetPath() ==
                      "assets/memory1/blue.png"
                  ? pairs[widget.tileIndex].getImageAssetPath()
                  : "assets/memory1/red.png"
              : widget.imageAssetPath),
        ),
      ),
    );
  }
}
