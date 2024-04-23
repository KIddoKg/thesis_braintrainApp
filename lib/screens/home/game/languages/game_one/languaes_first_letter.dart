import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_train_app/screens/onboarding/home.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:quickalert/quickalert.dart';
import 'package:get/get.dart';

import '../../../../../viewModel/data/data_onborad/data_languages_1.dart';
import 'package:brain_train_app/models/check_languages.dart';
import 'package:brain_train_app/models/result_model.dart';
import '../../../../../services/services.dart';
import '../../../../../shared/app_styles.dart';
import '../../../../../shared/custom_button.dart';
import '../../../../../shared/light_colors.dart';
import '../../../../../shared/share_widgets.dart';
import '../../../../../shared/toast.dart';
import '../../../../onboarding/explanation.dart';
import '../Language_Screen.dart';

class LanguagesFirstLetter extends StatefulWidget {
  const LanguagesFirstLetter({super.key});

  @override
  State<LanguagesFirstLetter> createState() => _LanguagesFirstLetterState();
}

class _LanguagesFirstLetterState extends State<LanguagesFirstLetter> {
  String listLetter = "./lib/viewModel/data/data_language/question_languages_one.json";
  String total_dictionary = "lib/viewModel/data/data_language/total_dictionary.json";
  final int answerDurationInSeconds = 200;
  List<String> _firstLetter = [""];
  List<String> _userLetter = [];
  List<String> _usedLetter = [];
  bool isKeyboardVisible = false;

  // bool checkLetter = false;
  String firstLetter = "";
  String wordInput = "";
  int statusCode = 0;

  // bool checktrue = true;
  bool stopTime = false;
  bool back = false;
  int reduceSecondsBy = 1;
  int score = 0;
  String firstCharacter = "";

  // int currentIndex = 0;
  List letterList = [];
  Timer? countdownTimer;
  int numberWord = 0;
  int currentPage = 0;
  int flex = 2;
  bool setPlaygame = false;
  late StreamSubscription<bool> keyboardSubscription;
  TextEditingController controllerInput = TextEditingController();
  Duration answerDuration = const Duration();
  Map<String, dynamic> filter = {
    "gameType": "LANGUAGE",
    "gameName": "STARTING_LETTER",
    "score": null,
    "wordList": null,
  };


  @override
  void initState() {
    super.initState();
    setStaryPlay();
    setStartLetter();
    fetchRandomCharacter();
    startTimer();
  }

  @override
  void dispose() {

    answerDuration = const Duration();
    countdownTimer!.cancel();
    controllerInput.dispose();
    super.dispose();
  }

  final List<ExplanationData> data = [
    ExplanationData(
        description:
        "Đầu tiên nhấn vào ô trống 'Nhập từ ở đây' bàn phím sẽ hiện lên ngay sau đó",
        title: "Trò chơi Tìm từ bắt đầu với" ,
        localImageSrc: "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExYzYzYjcyMzY0YTEzYTg4MGEyMGUwZmNmNmUzYjE2N2U3M2NhNzAyNCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/ry4d0GdvFaHjmdZRHK/giphy.gif",
        backgroundColor: AppColors.primaryColor),
    ExplanationData(
        description:
        "Tiếp theo nhập từ với từ đầu tiên cho trước. Chú ý không gõ lại từ đầu tiên",
        title: "Trò chơi Tìm từ bắt đầu với" ,
        localImageSrc: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExZTk3YjBiODEzMjc1NWRlYWM2MGRhY2Q0Nzk5MThlMDZmZDgyZGEyNiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/RXQozJSYhRxnLA50Fp/giphy.gif",
        backgroundColor: AppColors.primaryColor),
    ExplanationData(
        description:
        "au khi đã nhập xong nhấn nút Gửi và đợi Thông báo cộng điểm",
        title: "Trò chơi Tìm từ bắt đầu với" ,
        localImageSrc: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExMmRiNWE2NDE4YmNhMjg0ZjAzYThhOTRmNDBjZTg4ZDNlYjcyN2Y4NCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/rTqOJidmIWxWJXuR7o/giphy.gif",
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

  Future<void> setStaryPlay() async {
    bool saveSetPlay = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveSetPlay = prefs.getBool("setPlaygameLang1") ?? false;
    setState(() {
      setPlaygame = saveSetPlay;
    });
    setPlay();
  }

  Future<void> _saveDailyLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("DailyLangue", true);
    await prefs.setInt("date", DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> setPlay() async {
    if (setPlaygame == false) {
      _navigateAndDisplaySelection(context);
      stopTime = true;
      setPlaygame = true;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setPlaygameLang1', setPlaygame);
  }

  setStartLetter() async {
    // Obtain shared preferences.
    final letterUsedLanguage1 = await SharedPreferences.getInstance();
    List<String> letterUsedLanguage10 =
        letterUsedLanguage1.getStringList("letterUsedLanguage1") ?? [];

    setState(() {
      _usedLetter = letterUsedLanguage10!.toList();
    });
  }

  // //! Save Daily workout Langues
  Future<void> _saveDailyL() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("DailyLangue", true);
    await prefs.setInt("date", DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> setEndTimer() async {
    answerDuration = Duration(seconds: 0);
    countdownTimer!.cancel();
    int test = score;
    List<String> testString = _userLetter;
    String concatenatedString = _userLetter.join(',');
    _saveDailyLang();
    filter["score"] = test;
    filter["wordList"] = concatenatedString;

    var res = await Services.instance.setContext(context).addDataPlayGameUser(filter: filter);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResultScreen(
                result: Result(test, testString),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LanguageScreen()));
                  Navigator.popUntil(
                      context, ModalRoute.withName('/languageScreen'));
                },
              )),
    );
    setState(() {
      _saveDailyL();
      answerDuration = const Duration();
      score = 0;
      _firstLetter = [''];
      _userLetter = [];
      firstLetter = "";
      wordInput = "";
      numberWord = 0;
      fetchRandomCharacter();
      controllerInput.clear();
      startTimer();
    });
    // });
  }

  void setCountDown() {
    if (stopTime == false) {
      reduceSecondsBy = 1;
    } else {
      reduceSecondsBy = 0;
    }
    setState(() {
      final seconds = answerDuration.inSeconds - reduceSecondsBy;
      if (seconds <= 0) {
        setEndTimer();
      } else {
        answerDuration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    answerDuration = Duration(seconds: answerDurationInSeconds);

    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  // Future<bool> checkValidWord(String value) async {
  //   final String response = await rootBundle.loadString(total_dictionary);
  //   final data = await json.decode(response);
  //   print(data["word"].length);

  //   for (var i = 0; i < data["word"].length; i++) {
  //     String firstCharacter2 = data["word"][i].split(' ')[0];
  //     if (value == firstCharacter2) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }
  Future<bool> checkValidWord(String value) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    final response = await http.post(Uri.parse(validlanguagesUrl),
        headers: headers, body: jsonEncode({"text": value}));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> checkMatchWord(String value) async {
    for (int i = 0; i < _userLetter.length; i++) {
      if (value == _userLetter[i]) {
        return false;
      }
    }
    return true;
  }

  Future<bool> randomLetter(String value) async {
    final String response = await rootBundle.loadString(listLetter);
    final data = await json.decode(response);
    for (int i = 0; i < _usedLetter.length; i++) {
      if (value == _usedLetter[i]) {
        return false;
      }
    }
    return true;
  }

  Future<void> fetchRandomCharacter() async {
    final String response = await rootBundle.loadString(listLetter);
    final data = await json.decode(response);
    final letterUsedLanguage1 = await SharedPreferences.getInstance();
    int currentIndex = Random().nextInt(data["letter"].length);
    String firstCharacter = data["letter"][currentIndex].split(' ')[0];

    bool checkramdomLetter = await randomLetter(firstCharacter);

    setState(() {
      if (checkramdomLetter) {
        _firstLetter.add(firstCharacter);
        firstLetter = _firstLetter[1];
        letterList = data["letter"];
        _usedLetter.add(firstCharacter);
        letterUsedLanguage1.setStringList('letterUsedLanguage1', _usedLetter);

      } else if (!checkramdomLetter &&
          (_usedLetter.length < data["letter"].length)) {
        fetchRandomCharacter();
      } else if (!checkramdomLetter &&
          (_usedLetter.length >= data["letter"].length)) {
        _usedLetter = [];
        fetchRandomCharacter();
      }

    });
  }

  void handleClickCheck() async {
    String userAnswer = controllerInput.text;
    String firstLetter = _firstLetter[1];
    String checkingWord = "$firstLetter$userAnswer";
    numberWord = _firstLetter.length - 1;
    bool isValidWord = await checkValidWord(checkingWord);
    bool isMatchWord = await checkMatchWord(checkingWord);
    if (!isMatchWord) {
      showToastErrorMatch();
    }
    if (!isValidWord) {
      showToastError();
    }

    if (isValidWord && isMatchWord) {
      if (checkingWord.length == 2) {
        setState(() {
          _userLetter.add(checkingWord);
          _firstLetter.add(checkingWord);
          score += 200;
          showToastCorrect("+ 200");
        });
      } else if (checkingWord.length == 3) {
        setState(() {
          _firstLetter.add(checkingWord);
          _userLetter.add(checkingWord);
          score += 300;
          showToastCorrect("+ 300");
        });
      } else if (checkingWord.length == 4) {
        setState(() {
          _firstLetter.add(checkingWord);
          _userLetter.add(checkingWord);
          score += 400;
          showToastCorrect("+ 400");
        });
      } else if (checkingWord.length == 5) {
        setState(() {
          _firstLetter.add(checkingWord);
          _userLetter.add(checkingWord);
          score += 500;
          showToastCorrect("+ 500");
        });
      } else if (checkingWord.length == 6) {
        setState(() {
          _firstLetter.add(checkingWord);
          _userLetter.add(checkingWord);
          score += 600;
          showToastCorrect("+ 600");
        });
      } else if (checkingWord.length == 7) {
        setState(() {
          _firstLetter.add(checkingWord);
          _userLetter.add(checkingWord);
          score += 700;
          showToastCorrect("+ 700");
        });
      }
    }
    setState(() {
      controllerInput.clear();
      wordInput = "";
    });
  }

  void handleCheckResult() {
    if (wordInput.isNotEmpty) {
      handleClickCheck();
    }
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LanguageScreen()));
        Navigator.popUntil(context, ModalRoute.withName('/languageScreen'));
        final letterUsedLanguage1 = await SharedPreferences.getInstance();
        await letterUsedLanguage1.setStringList(
            'letterUsedLanguage1', _usedLetter);
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

  Future<bool?> showMyDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text('Bạn có muốn thoát ra ?'),
          actions: [
            TextButton(
              child:const Text('Không'),
              onPressed: () {
                back = false;
                Navigator.pop(context, back);
              },
            ),
            TextButton(
              child:const Text('Có'),
              onPressed: () async {
                back = true;
                Navigator.pop(context, back);
                final letterUsedLanguage1 =
                    await SharedPreferences.getInstance();
                await letterUsedLanguage1.setStringList(
                    'letterUsedLanguage1', _usedLetter);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isKeyborad = MediaQuery.of(context).viewInsets.bottom != 0;

    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
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
                      Expanded(
                        flex: 2,
                        child: Container(
                          // margin: const EdgeInsets.all(16),
                          // height:  size.height * 0.60,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
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
                                          // IconButton(
                                          //   onPressed: () {
                                          //     // stopTime = true;
                                          //     setEndTimer();
                                          //   },
                                          //   icon: const Icon(
                                          //     Icons.flag_circle_rounded,
                                          //     size: 40,
                                          //   ),
                                          //   color: Colors.black,
                                          // ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              // _dialogBuilderTwo(context);
                                              stopTime = true;

                                              _navigateAndDisplaySelection(context);

                                            },
                                            icon: const Icon(
                                              Icons.question_mark_rounded,
                                              size: 35,
                                            ),
                                            color: Colors.black,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              stopTime = true;
                                              setEndTimer();
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
                                  const SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    height: size.height * 0.04,
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
                                              widthFactor:
                                                  answerDuration.inSeconds /
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
                                              return Text(
                                                  '${answerDuration.inSeconds} seconds');
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
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: size.width,
                                            margin: const EdgeInsets.only(
                                              top: 20,
                                              bottom: 20,
                                              left: 20,
                                              right: 20,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 22),
                                            decoration: BoxDecoration(
                                              color: LightColors.kLightYellow,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 30,
                                                  ),
                                                  child: AutoSizeText(
                                                      "Nhập từ thích hợp bắt đầu bằng chữ $firstLetter : ",
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      maxFontSize: 80,
                                                      minFontSize: 16,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 25)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20, bottom: 20),
                                                  child: AutoSizeText(
                                                      wordInput == ""
                                                          ? "$firstLetter _____"
                                                          : "$firstLetter$wordInput",
                                                      maxLines: 1,
                                                      minFontSize: 22,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 30)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // Add the line below
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        // padding: const EdgeInsets.all(16),
                        clipBehavior: Clip.hardEdge,
                        height: size.height * 0.01,
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
                        height: size.height * 0.01,
                        decoration: const BoxDecoration(
                          color: Color(0xfffff3e0),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            SizedBox(
                              width: size.width * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 10),
                                child: TextField(
                                  controller: controllerInput,
                                  textAlign: TextAlign.center,
                                  maxLength: 6,
                                  style:
                                  const TextStyle(color: Colors.black, fontSize: 25),
                                  onChanged: (text) {
                                    setState(() {
                                      wordInput = text;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "nhập từ ở đây",
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: ElevatedButton(
                                  onPressed: () {
                                    handleCheckResult();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellow[600],
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 14),
                                      textStyle: const TextStyle(fontSize: 24)),
                                  child: const AutoSizeText('Gửi',
                                      maxLines: 1,
                                      minFontSize: 16,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20)),
                                )),
                          ],
                        ),
                      ),
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
