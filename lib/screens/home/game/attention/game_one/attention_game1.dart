import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../viewModel/data/data_onborad/data_attention_1.dart';
import '../../../../../services/services.dart';
import '../../../../../shared/app_styles.dart';
import '../../../../../shared/custom_dialog.dart';
import '../../../../../shared/light_colors.dart';
import '../../../../onboarding/explanation.dart';
import '../../../../onboarding/home.dart';
import '../Attention_Screen.dart';
import 'ImagePass.dart';
import 'ResultTest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttentionGameOne extends StatefulWidget {
  const AttentionGameOne({super.key});

  @override
  State<AttentionGameOne> createState() => _AttentionGameOneState();
}

class Result {
  final int bonus;
  final int score;
  final int time;

  Result(this.bonus, this.score, this.time);
}

class ImagePass {
  // final int score;
  final String score;
  final List<String> message;

  ImagePass(this.score, this.message);
}

class _AttentionGameOneState extends State<AttentionGameOne> {
  final int totalDurationInSeconds = 20;
  final int answerDurationInSeconds = 60;
  final int POINT_PER_CORRECT_ANSWER = 200;
  int count = 0;
  // final String game1_attention =
  //     "lib/viewModel/data/data_attention/game_one_attention.json";
  final String key_data = "attentionData";

  late double screenHeight, screenWidth, boxHeight, boxWidth;
  bool stopTime = false;
  Timer? questionCountdownTimer;
  Duration questionDuration = const Duration();
  Timer? totalCountdownTimer;
  Duration totalDuration = const Duration();
  int reduceSecondsBy = 1;
  List<String> imagesAssetPath = [];
  List<String> solutionAssetPath = [];
  List<String> solutionAssetPathUsed = [];
  List<String> imagesAssetPathUsed = [];
  List gameData = [];
  late int currentKey; // ID of image key
  int time = 1;
  int time2 = 1;
  int currentQuestion = 0; // order of question
  int point = 0;
  int totalAnswerTime = 0;
  bool setPlaygame = false;
  bool back = false;
  bool isCorrect = false;
  bool endGame = false;
  late double scaleRatio;
  late CustomDialog dialog;
  int countQuestion = 0;

//! save daily workout of game math
  Future<void> _saveDailyAtte() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("DailyAtt", true);
    await prefs.setInt("date", DateTime.now().millisecondsSinceEpoch);
  }

  setImageUsed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagesAssetPathUsed = prefs.getStringList("imageUsedAttendtion1") ?? [];
      solutionAssetPathUsed =
          prefs.getStringList("imageSolutionAttendtion1") ?? [];
      //print(solutionAssetPathUsed);
    });
  }

  Future<void> setStartImg() async {
    List<String> saveSetImg;
    var res = await Services.instance
        .setContext(context)
        .getDataPlayGameUser("DIFFERENCE");
    if (res!.isSuccess) {
      String numbers = res.data['wordList'] ?? "";
      List<String> numbersList = numbers.split(', ');
      List<String> imagePathList = numbersList
          .map((number) => 'assets/images/Attention/Solution/$number.png')
          .toList();
      solutionAssetPathUsed = imagePathList;
    } else {
      solutionAssetPathUsed = [];
    }
    setState(() {});
    //print(solutionAssetPathUsed);
  }

  Future<void> setStaryPlay() async {
    bool saveSetPlay = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveSetPlay = prefs.getBool("setPlaygame") ?? false;
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
    await prefs.setBool('setPlaygame', setPlaygame);
  }

  // Timer
  void startQuestionTimer() {
    if (stopTime == false) {
      time = 1;
    } else {
      time = 0;
    }
    questionDuration = Duration(seconds: answerDurationInSeconds);
    questionCountdownTimer = Timer.periodic(
        const Duration(seconds: 1), (_) => setQuestionCountDown());
  }

  void startTotalTimer() {
    setImageUsed();
    totalDuration = Duration(seconds: totalDurationInSeconds);
    totalCountdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setTotalCountDown());
  }

  void setQuestionCountDown() {
    if (stopTime == false) {
      reduceSecondsBy = 1;
    } else {
      reduceSecondsBy = 0;
    }
    setState(() {
      final seconds = questionDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        outOfQuestionTime();
      } else {
        questionDuration = Duration(seconds: seconds);
      }
    });
  }

  void setTotalCountDown() {
    if (stopTime == false) {
      reduceSecondsBy = 1;
    } else {
      reduceSecondsBy = 0;
    }
    setState(() {
      final seconds = totalDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        handleEndGame();
      } else {
        totalDuration = Duration(seconds: seconds);
      }
    });
  }

  void setCancelQuestionTimer() {
    questionDuration = const Duration();
    questionCountdownTimer!.cancel();
  }

  void setCancelTotalTimer() {
    totalCountdownTimer!.cancel();
  }

  final List<ExplanationData> data = [
    ExplanationData(
        description:
            "Đầu tiên nhấn vào ô trống 'Nhập từ ở đây' bàn phím sẽ hiện lên ngay sau đó",
        title: "Trò chơi Tìm từ bắt đầu với",
        localImageSrc:
            "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExYzYzYjcyMzY0YTEzYTg4MGEyMGUwZmNmNmUzYjE2N2U3M2NhNzAyNCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/ry4d0GdvFaHjmdZRHK/giphy.gif",
        backgroundColor: AppColors.primaryColor),
    ExplanationData(
        description:
            "Nếu bạn trả lời đúng liên tiếp trên 3 bức ảnh. Nó sẽ được lưu trong biểu tượng hình thẻ khóa",
        title: "Trò chơi Tìm từ bắt đầu với",
        localImageSrc:
            "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExMmMwNDJhMTQzOWFmMzNjZGU0OTMwY2ZiODNmNmRkNjkwZmY4YjEyZCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/Rhn1uVvix3MaCSr9jG/giphy.gif",
        backgroundColor: AppColors.primaryColor),
  ];

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OnBoarding(
                data: data,
              )),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.

    if (!mounted) return;
    if (result != null) {
      bool isTrue = result == "true";
      //print(isTrue);
      stopTime = isTrue;
      setState(() {});
      // Now you can use the `isTrue` boolean value
    }
    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
  }

  // Timer Logic
  Future<void> outOfQuestionTime() async {
    setCancelQuestionTimer();
    CountCorrect();
    if (checkEndGame()) {
      return handleEndGame();
    }
    nextQuestion();
  }

  // Question Logic
  void nextQuestion() {
    countQuestion++;
    setState(() {
      isCorrect = false;
      currentQuestion++;
      currentKey = getCurrentKeyValue(imagesAssetPath[currentQuestion]);
    });
    if (currentQuestion == 10) {
      handleEndGame();
    }
    scaleRatio = calculateImageScale(currentKey);
    startQuestionTimer();
  }

  bool checkEndGame() {
    if (currentQuestion == 10) {
      return true;
    }
    return false;
  }

  Future<void> imagePass() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ImagePassScreen(
              imagePass: ImagePass("o", solutionAssetPathUsed))),
    );
    if (result != null) {
      bool parsedResult = result.toLowerCase() == "true";
      stopTime = parsedResult;
    }
  }

  Future<void> handleEndGame() async {
    setCancelQuestionTimer();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('imageUsedAttendtion1', imagesAssetPathUsed);
    await prefs.setStringList(
        'imageSolutionAttendtion1', solutionAssetPathUsed);
    await prefs.setStringList('solutionAssetPathUsed', solutionAssetPathUsed);
    setState(() {
      endGame = true;
    });
    int correctAnswer = point ~/ POINT_PER_CORRECT_ANSWER;
    int avgTime = calculateAvgTime(correctAnswer);
    int bonusPoint = calculateBonusPoint(avgTime);
    int totalPoint = point + bonusPoint;
    _saveDailyAtte();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ResultScreen(result: Result(bonusPoint, totalPoint, avgTime))),
    );
  }

  void restartGame() {
    currentQuestion = 0;
    point = 0;
    totalAnswerTime = 0;

    isCorrect = false;
    endGame = false;

    setupImages();
    scaleRatio = calculateImageScale(currentKey);
    // startTotalTimer();
    startQuestionTimer();
  }

  // Image & Image Data
  int getCurrentKeyValue(String imageName) {
    String key = imageName.split("/").last.split(".").first;
    return int.parse(key);
  }

  Future<void> _loadAssetsFiles() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Load Path
    final solutionImagePath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Attention/'))
        .where((String key) => key.contains('Solution/'))
        .where((String key) => key.contains('.png'))
        .toList();

    final attentionImagePath = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('Attention/'))
        .where((String key) => key.contains('Question/'))
        .where((String key) => key.contains('.png'))
        .toList();
    // imagesAssetPathUsed =["aa"];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    imagesAssetPathUsed = prefs.getStringList("imageUsedAttendtion1") ?? [];

    solutionAssetPath = solutionImagePath;
    attentionImagePath
        .removeWhere((element) => imagesAssetPathUsed.contains(element));
    if (attentionImagePath.length >= 10) {
      imagesAssetPath = attentionImagePath;
    }
  }

  void setupImages() {
    imagesAssetPath.shuffle();

    if (imagesAssetPath.isEmpty) {
      handleEndGame();
    }
    setState(() {
      currentKey = getCurrentKeyValue(imagesAssetPath[currentQuestion]);
    });
  }

  // Game Logic
  double xx =0;
  double yy =0;
  void onTapDown(BuildContext context, TapDownDetails details) {
    print(details.localPosition.dx);
    print(details.localPosition.dy);
    var imageOriginalWidth = gameData[currentKey - 1]["size"]["x"];
    var imageOriginalHeight = gameData[currentKey - 1]["size"]["y"];
    var resultOriginalWidth = gameData[currentKey - 1]["result"]["x"];
    var resultOriginalHeight = gameData[currentKey - 1]["result"]["y"];

    double resultXFromCenterImage =
        resultOriginalWidth - imageOriginalWidth / 2;
    double resultYFromCenterImage =
        resultOriginalHeight - imageOriginalHeight / 2;

    print(resultXFromCenterImage + imageOriginalWidth / 2);
    print(resultYFromCenterImage + imageOriginalHeight / 2);

    double posX = details.localPosition.dx;
    double posY = details.localPosition.dy;
    //
    double resultX = boxWidth / 2 + resultXFromCenterImage * scaleRatio;
    double resultY = boxHeight / 2 + resultYFromCenterImage * scaleRatio;

    double validWidthRange = 50 * scaleRatio / 2;
    double validHeightRange = 50 * scaleRatio / 2;


    setState(() {
      xx =resultX;
      yy = resultY;
    });

    if (posX >= resultX - validWidthRange &&
        posX <= resultX + validWidthRange &&
        posY >= resultY - validHeightRange &&
        posY <= resultY + validHeightRange) {
      handleCorrectAnswer();
    }
  }

  Future<void> CountCorrect() async {
    if (isCorrect == true) {
      count++;
    } else if (isCorrect == false) {
      count = 0;
    }
    Set<String> uniqueItems = Set<String>.from(imagesAssetPathUsed);

    if (count >= 1) {
      for (var i = 0; i < count; i++) {
        uniqueItems.add(imagesAssetPath[currentQuestion - i]);
      }
      imagesAssetPathUsed = List<String>.from(uniqueItems);
      Set<String> uniqueSolutionItems = Set<String>.from(solutionAssetPathUsed);
      for (var i = 0; i < imagesAssetPathUsed.length; i++) {
        uniqueSolutionItems.add(solutionAssetPath.firstWhere((element) =>
            element.split("/").last == imagesAssetPathUsed[i].split("/").last));
      }
      solutionAssetPathUsed = List<String>.from(uniqueSolutionItems);
    }

    // setState(() {
    //   isCorrect = true;
    //   point += POINT_PER_CORRECT_ANSWER;
    //
    //
    // });
    // await Future.delayed(Duration(seconds: 3));
    // nextQuestion();
    // if (checkEndGame()) {
    //   handleEndGame();
    // }
  }

  Future<void> handleCorrectAnswer() async {
    setCancelQuestionTimer();
    totalAnswerTime += answerDurationInSeconds - questionDuration.inSeconds;

    setState(() {
      isCorrect = true;
      point += POINT_PER_CORRECT_ANSWER;
      // imagesAssetPathUsed.add(imagesAssetPath[currentQuestion]);
    });
    CountCorrect();
    await Future.delayed(const Duration(seconds: 3));
    nextQuestion();
    if (checkEndGame()) {
      handleEndGame();
    }
  }

  double calculateImageScale(int key) {
    int imageOriginalWidth = gameData[key - 1]["size"]["x"];
    int imageOriginalHeight = gameData[key - 1]["size"]["y"];
    double widthRatio = imageOriginalWidth / boxWidth;
    double heightRatio = imageOriginalHeight / boxHeight;
    double result = 1.0;

    if (widthRatio > heightRatio && widthRatio > 1) {
      result = boxWidth / imageOriginalWidth;
    } else if (heightRatio > widthRatio && heightRatio > 1) {
      result = boxHeight / imageOriginalHeight;
    }

    return result;
  }

  int calculateAvgTime(int totalCorrectAnswers) {
    double averageTotalTime =
        totalCorrectAnswers != 0 ? totalAnswerTime / totalCorrectAnswers : 0.0;
    return averageTotalTime.round();
  }

  int calculateBonusPoint(int avgTime) {
    double bonusPoint = avgTime != 0 ? point / avgTime : 0.0;
    return bonusPoint.round();
  }

  Future<String> getAtentionDataAsJsonString() async {
    try {
      // Lấy tham chiếu của collection "BrainTrainGame/Atention1"
      DocumentReference atention1DocRef = FirebaseFirestore.instance.doc('BrainTrainGame/Attention1');

      // Lấy dữ liệu từ document "Atention1"
      DocumentSnapshot atention1Doc = await atention1DocRef.get();

      // Kiểm tra xem document có tồn tại không
      if (atention1Doc.exists) {
        // Lấy dữ liệu từ trường 'atentionData' bên trong document
        List<dynamic>? atentionData = atention1Doc.get('attentionData');

        if (atentionData != null) {
          // Tạo một Map từ dữ liệu
          Map<String, dynamic> jsonData = {
            'attentionData': atentionData,
          };

          // Chuyển đổi Map sang chuỗi JSON
          String jsonString = jsonEncode(jsonData);

          return jsonString;
        } else {
          print('Field "atentionData" is null or not found');
        }
      } else {
        print('Document "Atention1" does not exist');
      }
    } catch (error) {
      print('Error retrieving data: $error');
    }

    return '{}';
  }

  Future<List> readJson(String key) async {
    final String response = await getAtentionDataAsJsonString();
    final data = await json.decode(response);

    return data[key];
  }

  // Main
  @override
  void initState() {
    super.initState();

    setStaryPlay();
    setStartImg();
    setImageUsed();
    CountCorrect();
    dialog = CustomDialog(context: context);
    _loadAssetsFiles().then((val) {
      // setImageUsed();
      setupImages();
      readJson( key_data).then((imageData) {
        gameData = imageData;
        scaleRatio = calculateImageScale(currentKey);
        // startTotalTimer();
        startQuestionTimer();
      });
    });
  }

  @override
  void dispose() {
    questionDuration = const Duration();
    setCancelQuestionTimer();
    super.dispose();

    // setCancelTotalTimer();
  }

  Future<bool?> showMyDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bạn có muốn thoát ra ?'),
          actions: [
            TextButton(
              child: const Text('Không'),
              onPressed: () {
                back = false;
                stopTime = false;
                Navigator.pop(context, back);
              },
            ),
            TextButton(
              child: const Text('Có'),
              onPressed: () async {
                back = true;
                Navigator.pop(context, back);
              },
            ),
          ],
        );
      },
    );
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
      onConfirmBtnTap: () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AttentionScreen()));
        Navigator.popUntil(context, ModalRoute.withName('/attentionScreen'));
      },
      confirmBtnTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      showCancelBtn: true,
      cancelBtnText: 'Không',
      onCancelBtnTap: () {
        stopTime = false;
        Navigator.pop(context, back);
      },
      cancelBtnTextStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int seconds = questionDuration.inSeconds;
    int totalSeconds = questionDuration.inSeconds;
    final size = MediaQuery.of(context).size;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    boxHeight = screenHeight * 0.5;
    boxWidth = screenWidth;

    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: LightColors.kLightYellow,
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  const Positioned(
                    left: -5,
                    right: -230,
                    child: Image(
                      image: NetworkImage(
                          'https://media2.giphy.com/media/ZNHqbuUEeJKjx7B3GJ/giphy.gif'),
                      height: 200,
                      width: 400,
                      //   width:400,
                    ),
                  ),
            
                  // SvgPicture.asset(
                  //   'assets/images/business-lady-do-multi-tasking.svg',
                  //   // fit: BoxFit.fitHeight,
                  //   height:200,
                  //   width:400,
                  // ),
            
                  Column(
                    children: [
                      Container(
                        // margin: const EdgeInsets.all(16),
                        height: size.height * 0.3,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFD740), Color(0xFFF9A825)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
            
                        child: Scaffold(
                          backgroundColor: Colors.transparent,
                          // height:300,
            
                          body: Center(
                            child: Column(
                              children: [
                                //SizedBox(height: AppColors.bottomArea),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            showExitDialog(context);
                                            stopTime = true;
                                          },
                                          icon: const Icon(
                                            Icons.arrow_circle_left_outlined,
                                            size: 40,
                                          ),
                                          color: Colors.black,
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
                                            size: 35,
                                          ),
                                          color: Colors.black,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            imagePass();
                                            // _dialogBuilderTwo(context);
                                            stopTime = true;
                                          },
                                          icon: const Icon(
                                            Icons.loyalty,
                                            size: 35,
                                          ),
                                          color: Colors.black,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            // stopTime = true;
                                            // _dialogBuilderTwo(context);
                                          },
                                          icon: const Icon(
                                            Icons.settings,
                                            size: 35,
                                          ),
                                          color: Colors.black,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 20),
                                  height: 30,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: LightColors.kLightYellow,
                                  ),
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Consumer(
                                        builder: (context, ref, child) {
                                          return FractionallySizedBox(
                                            alignment: Alignment.centerLeft,
                                            widthFactor: totalSeconds /
                                                answerDurationInSeconds,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: LightColors.kDarkGreen,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Positioned(
                                        left: 10,
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            return Text('$totalSeconds seconds');
                                          },
                                        ),
                                      ),
                                      const Positioned(
                                        right: 10,
                                        child: Icon(
                                          Icons.timer,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: size.height * 0.03),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Center(
                                        // padding: const EdgeInsets.only(
                                        //     top: 15, bottom: 10),
                                        child: Text(
                                          "Điểm: $point",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              fontSize: 27),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //       top: 15, bottom: 10),
                                      //   child: Text(
                                      //     "Thời gian: ${questionDuration.inSeconds} s",
                                      //     style: const TextStyle(
                                      //         fontWeight: FontWeight.w700,
                                      //         color: Colors.white,
                                      //         fontSize: 27),
                                      //   ),
                                      // ),
                                    ])
                              ],
                            ),
                          ),
                        ),
                      ),
            
                      Container(
                        // Add the line below
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        // padding: const EdgeInsets.all(16),
                        clipBehavior: Clip.hardEdge,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xffffe0b2),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                        ),
                      ),
                      Container(
                        // Add the line below
                        margin: const EdgeInsets.only(left: 35.0, right: 35.0),
                        clipBehavior: Clip.hardEdge,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xfffff3e0),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          // SizedBox(height: 30),
                          imagesAssetPath.isNotEmpty && gameData.isNotEmpty
                              ? Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      gameData[currentKey - 1]["title"],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    height: boxHeight,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Material(
                                        child: !isCorrect
                                            ? Ink.image(
                                                image: AssetImage(imagesAssetPath[
                                                    currentQuestion]),
                                                fit: BoxFit.scaleDown,
                                                child: InkWell(
                                                  onTapDown: !endGame
                                                      ? (TapDownDetails
                                                              details) =>
                                                          onTapDown(
                                                              context, details)
                                                      : null,
                                                ),
                                              )
                                            : Stack(
                                                children: [
                                                  Container(
                                                    width: boxWidth,
                                                    height: boxHeight,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(imagesAssetPath[
                                                        currentQuestion]),
                                                        fit: BoxFit.scaleDown,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: xx - 35,
                                                    // Đặt giá trị left theo yêu cầu của bạn
                                                    top: yy -35,
                                                    // Đặt giá trị top theo yêu cầu của bạn
                                                    child: Container(
                                                      width: 70,
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.transparent,
                                                        border: Border.all(
                                                          color: Colors.red,
                                                          width: 5,
                                                        ),
                                                      ),
                                                  ),
                                                  )],
                                              ),
                                      ),
                                    ),
                                  ),
                                ])
                              : const Text(
                                  "Hiện tại thư viện câu hỏi đang được cập nhập. Bạn vui lòng quay lại sau nha !!!",
                                  textAlign: TextAlign.center,
                                ),
                        ],
                      )
                      //   Expanded(
                      //     flex: 1,
                      //     child: Column(
                      //       children: [
                      //         SizedBox(
                      //           width: 200,
                      //           child: Padding(
                      //             padding: const EdgeInsets.only(top: 5, bottom: 10),
                      //             child: TextField(
                      //               controller: controllerInput,
                      //               textAlign: TextAlign.center,
                      //               maxLength: 6,
                      //               style: TextStyle(color: Colors.black, fontSize: 25),
                      //               onChanged: (text) {
                      //                 setState(() {
                      //                   wordInput = text;
                      //                 });
                      //               },
                      //               decoration: const InputDecoration(
                      //                 hintText: "nhập từ ở đây",
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         Padding(
                      //             padding: const EdgeInsets.only(top: 10),
                      //             child: ElevatedButton(
                      //               onPressed: () {
                      //                 handleCheckResult();
                      //               },
                      //               style: ElevatedButton.styleFrom(
                      //                   backgroundColor: Colors.yellow[600],
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 40, vertical: 14),
                      //                   textStyle: const TextStyle(fontSize: 24)),
                      //               child: const Text('Gửi',
                      //                   style: TextStyle(
                      //                       fontWeight: FontWeight.bold,
                      //                       color: Colors.black,
                      //                       fontSize: 20)),
                      //             )),
                      //       ],
                      //     ),
                      //   ),
                    ],
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
