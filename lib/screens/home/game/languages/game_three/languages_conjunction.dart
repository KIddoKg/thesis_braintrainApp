import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import '../../../../../viewModel/data/data_onborad/data_languages_3.dart';
import 'package:brain_train_app/models/check_languages.dart';
import 'package:brain_train_app/models/result_model.dart';
import '../../../../../services/services.dart';
import '../../../../../shared/app_styles.dart';
import '../../../../../shared/custom_button.dart';
import '../../../../../shared/light_colors.dart';
import '../../../../../shared/share_widgets.dart';
import '../../../../../shared/toast.dart';
import '../../../../onboarding/explanation.dart';
import '../../../../onboarding/home.dart';
import '../Language_Screen.dart';

class LanguageGameThree extends StatefulWidget {
  const LanguageGameThree({super.key});

  @override
  State<LanguageGameThree> createState() => _LanguageGameThreeState();
}


class _LanguageGameThreeState extends State<LanguageGameThree> {
  final int answerDurationInSeconds = 60;
  final int pointPerCorrectAnswer = 200;
  int currentIndex = 0;
  String listLetter = "lib/viewModel/data/data_language/word.json";
  String total_dictionary = "lib/viewModel/data/data_language/total_dictionary.json";
  Duration answerDuration = const Duration();
  Timer? countdownTimer;
  int numberWord = 0;
  bool stopTime = false;
  bool back = false;
  int reduceSecondsBy = 1;
  TextEditingController controller = TextEditingController();
  late Future<String> firstCharacter;
  List<String> _answer = [' ', ' ', ' '];
  List<String> _usedWord = [];
  List<String> _checkMathWord = [];
  String firstLetter = "";
  int _point = 0;
  bool setPlaygame = false;

  Map<String, dynamic> filter = {
    "gameType": "LANGUAGE",
    "gameName": "NEXT_WORD",
    "score": null,
    "wordList": null,
  };


  Future<void> setStaryPlay() async {
    bool saveSetPlay = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveSetPlay = prefs.getBool("setPlaygameLang3")??false;
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
  Future<void> setPlay()async {
    if(setPlaygame == false){
      _navigateAndDisplaySelection(context);
      stopTime = true;
      setPlaygame = true;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setPlaygameLang3', setPlaygame);
  }
  // Timer Handler
  void startTimer() {
    answerDuration = Duration(seconds: answerDurationInSeconds);

    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
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
        // changeStatus(GameStatus.end);
      } else {
        answerDuration = Duration(seconds: seconds);
      }
    });
  }

  setStartLetter() async {
    // Obtain shared preferences.
    final wordUsedLanguage3 = await SharedPreferences.getInstance();
    List<String>? wordUsedLanguage30 =
   wordUsedLanguage3.getStringList("wordUsedLanguage3");

    setState(() {
      _usedWord = wordUsedLanguage30!.toList();
    });
  }

  Future<void> setEndTimer() async {
    countdownTimer!.cancel();
    // _showNotify("Hết giờ", "$_point", () {
    //   Navigator.of(context).pop();
    int test = _point;
    List<String> testString = _checkMathWord;
    String concatenatedString = _checkMathWord.join(',');
    _saveDailyLang();
    filter["score"] = test;
    filter["wordList"] = concatenatedString;
    var res = await Services.instance.setContext(context).addDataPlayGameUser(filter: filter);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ResultScreen(result: Result(test, testString), onTap: () {  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LanguageScreen()));
              Navigator.popUntil(
                  context, ModalRoute.withName('/languageScreen')); },)),
    );
    setState(() {
      answerDuration = const Duration(seconds: 60);
      _point = 0;
      firstLetter = "";
      _answer = [
        ' ',
        ' ',
        ' ',
      ];
      _checkMathWord = [];
      fetchRandomCharacter();
      controller.clear();
      numberWord = 0;
      startTimer();
      // });
    });
  }

  Future<bool> randomLetter(String value) async {
    final String response = await rootBundle.loadString(listLetter);
    final data = await json.decode(response);
    for (int i = 0; i < _usedWord.length; i++) {
      if (value == _usedWord[i]) {
        return false;
      }
    }
    return true;
  }

  Future<String> fetchRandomCharacter() async {
    final String response = await rootBundle.loadString(listLetter);
    final data = await json.decode(response);
    currentIndex = Random().nextInt(data["letter"].length);
    final wordUsedLanguage3 = await SharedPreferences.getInstance();
    if (data.isNotEmpty) {
      String firstCharacter = data["letter"][currentIndex];

      bool checkramdomLetter = await randomLetter(firstCharacter);
      if (checkramdomLetter) {
        _answer.add(firstCharacter);
        _usedWord.add(firstCharacter);
        wordUsedLanguage3.setStringList('wordUsedLanguage3', _usedWord);

      } else if (!checkramdomLetter &&
          (_usedWord.length < data["letter"].length)) {
        fetchRandomCharacter();
      } else if (!checkramdomLetter &&
          (_usedWord.length >= data["letter"].length)) {
        _usedWord = [];
        fetchRandomCharacter();
      }

      return firstCharacter;
    }
    throw Exception('Failed to load random character in the dictionary');
  }

  // Future<bool> checkValidWord(String word) async {
  //   final String response = await rootBundle.loadString(total_dictionary);
  //   final data = await json.decode(response);
  //   print(word);
  //   for (var i = 0; i < data["word"].length; i++) {
  //     String firstCharacter2 = data["word"][i];

  //     if (word == firstCharacter2) {

  //       // print(firstCharacter2);
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
    String userAnswer = controller.text;
    String firstChar = _answer[_answer.length - 1];
    String checkingWord = '$firstChar $userAnswer';
    for (int i = 0; i < _checkMathWord.length; i++) {
      if (checkingWord == _checkMathWord[i]) {
        return false;
      }
    }
    return true;
  }

  // Logic Handler
  void handleClickCheck() async {
    String userAnswer = controller.text;
    String firstChar = _answer[_answer.length - 1];
    numberWord = _answer.length - 3;
    String checkingWord = '$firstChar $userAnswer';
    bool isValidWord = await checkValidWord(checkingWord);
    bool isMarchWord = await checkMatchWord(checkingWord);

    if (isValidWord) {
      if (!isMarchWord) {
        showToastErrorMatch();
      }
      if (isMarchWord) {
        _answer.add(userAnswer);
        _checkMathWord.add(checkingWord);
        setState(() {
          _point += pointPerCorrectAnswer;
          // Restart timer
          showToastCorrect("+ 200");
          answerDuration = Duration(seconds: answerDurationInSeconds);
        });
      }
    } else {
      showToastError();
    }

    controller.text = '';
  }

  @override
  void initState() {
    super.initState();
    setStaryPlay();
    setStartLetter();
    firstCharacter = fetchRandomCharacter();
    startTimer();
  }

  @override
  void dispose() {
    countdownTimer!.cancel();
    controller.dispose();
    answerDuration = const Duration();
    super.dispose();

  }

  final List<ExplanationData> data = [
    ExplanationData(
        description:
        "Đầu tiên nhấn vào ô trống 'Nhập từ ở đây' bàn phím sẽ hiện lên ngay sau đó",
        title: "Trò chơi Nối từ" ,
        localImageSrc: "https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExZTYzNzE5MjgxZjU3NjAzNTA5MjU1MDBkNGY1Mjg0YmM2OTk2ZDdkYiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/8tY2befV4Ma2Umcx93/giphy.gif",
        backgroundColor: AppColors.primaryColor),
    ExplanationData(
        description:
        "Tiếp theo nhập từ vào ô trống để tạo thành từ có nghĩa",
        title: "Trò chơi Nối từ" ,
        localImageSrc: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExOWJjZmUxMmZjNDE3ZTljNWQwMGVjNWMxMWRkMTI2ODBhN2ZjMDE2YSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/NO9oE4daNRPTLsoUYj/giphy.gif",

        backgroundColor: AppColors.primaryColor),
    ExplanationData(
        description:
        "Sau khi đã nhập xong nhấn nút Gửi và đợi Thông báo cộng điểm",
        title: "Trò chơi Nối từ" ,
        localImageSrc: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExZjFmZDc2NDA5ODg2MzY4NmY5ZWFhOTZiMmEyZjRkMjg0MGFmMTdhNSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/Smb5rajNBR6CHuqGJ8/giphy.gif",

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
                final wordUsedLanguage3 = await SharedPreferences.getInstance();
                await wordUsedLanguage3.setStringList(
                    'wordUsedLanguage3', _usedWord);
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) =>const LanguageScreen()));
        Navigator.popUntil(context, ModalRoute.withName('/languageScreen'));
        final wordUsedLanguage3 = await SharedPreferences.getInstance();
        await wordUsedLanguage3.setStringList('wordUsedLanguage3', _usedWord);
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
    final seconds = answerDuration.inSeconds;
    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(

            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                const Positioned(
                  bottom: -40,
                  left: -5,
                  right: -230,
                  child: Image(
                    image: NetworkImage('https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExNDljMzVjMWU2Y2I5ZGZjMzRlMWJlZTFlZDkyYzFlMDU3NmQ1Y2RhOSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/f1z1uDg6DelbtCsb8z/giphy.gif'),
                    height: 200,
                    width: 400,
                    //   width:400,
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 0,
                        child: Container(
                          // margin: const EdgeInsets.all(16),
                          height: 460,
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
                                            // final questions = ref.watch(questionsProvider);
                                            return FractionallySizedBox(
                                              alignment: Alignment.centerLeft,
                                              widthFactor:
                                              answerDuration.inSeconds /
                                                  answerDurationInSeconds,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(30),
                                                  color: Colors.green[300],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        // Image.asset(
                                        //   'assets/images/slow-loading.png',
                                        //   width: 3980,
                                        //   height:400,
                                        // ),
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
                                              margin: const EdgeInsets.only(
                                                top: 20,
                                                bottom: 20,
                                                left: 20,
                                                right: 20,
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 6, horizontal: 22),
                                              height: 330,
                                              decoration: BoxDecoration(
                                                color: LightColors.kLightYellow,
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                              child: FutureBuilder<String>(
                                                future: firstCharacter,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return  Column(children: [
                                                      const Text('Nối từ',
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 25)),
                                                      Text(
                                                          "Từ đầu tiên: ${_answer[3]}",
                                                          textAlign:
                                                          TextAlign.center,
                                                          style:const TextStyle(
                                                              fontSize: 25)),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                height: 70,
                                                                decoration:
                                                                BoxDecoration(
                                                                  border:
                                                                  Border.all(
                                                                    color: Colors
                                                                        .yellow,
                                                                    width: 5.0,
                                                                  ),
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      10.0),
                                                                ),
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                child: Text(
                                                                    _answer[_answer
                                                                        .length -
                                                                        3],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        color: Colors
                                                                            .black))),
                                                            Container(
                                                                width: 100,
                                                                height: 70,
                                                                decoration:
                                                                BoxDecoration(
                                                                  border:
                                                                  Border.all(
                                                                    color: Colors
                                                                        .yellow,
                                                                    width: 5.0,
                                                                  ),
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      10.0),
                                                                ),
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                child: Text(
                                                                    _answer[_answer
                                                                        .length -
                                                                        2],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        color: Colors
                                                                            .black))),
                                                          ]),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                height: 70,
                                                                decoration:
                                                                BoxDecoration(
                                                                  border:
                                                                  Border.all(
                                                                    color: Colors
                                                                        .yellow,
                                                                    width: 5.0,
                                                                  ),
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      10.0),
                                                                ),
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                child: Text(
                                                                    _answer[_answer
                                                                        .length -
                                                                        1],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        color: Colors
                                                                            .black))),
                                                            Container(
                                                                width: 100,
                                                                height: 70,
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                child: TextField(
                                                                  controller:
                                                                  controller,
                                                                  textAlign:
                                                                  TextAlign
                                                                      .center,
                                                                  style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                      20,
                                                                      height:
                                                                      1.7),
                                                                  decoration:
                                                                  InputDecoration(
                                                                    enabledBorder:
                                                                    OutlineInputBorder(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(6),
                                                                      borderSide:
                                                                      const BorderSide(
                                                                        color: Colors
                                                                            .green,
                                                                        width:
                                                                        1.0,
                                                                      ),
                                                                    ), // OutlineInputBorder
                                                                    focusedBorder:
                                                                    OutlineInputBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          10),
                                                                      borderSide:
                                                                      const BorderSide(
                                                                        color: Colors
                                                                            .yellow,
                                                                        width:
                                                                        5.0,
                                                                      ), // OutlineInputBorder
                                                                    ),
                                                                    hintText:
                                                                    'Nhập từ',
                                                                  ),
                                                                ))
                                                          ]),
                                                    ]);
                                                  } else if (snapshot.hasError) {
                                                    return Text(
                                                        '${snapshot.error}');
                                                  }

                                                  // By default, show a loading spinner.
                                                  return const Center(
                                                      heightFactor: 22.0,
                                                      child:
                                                      CircularProgressIndicator());
                                                },
                                              )),
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
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: controller.text.isNotEmpty
                                ? () => handleClickCheck()
                                : null,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow[600],
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 14),
                                textStyle: const TextStyle(fontSize: 24)),
                            child: const Text('Gửi'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showNotify(
      String title, String content, Function callback) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style: const TextStyle(
                    fontSize: 40,
                    color: Colors.red,
                    decoration: TextDecoration.none),
                textAlign: TextAlign.center),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF9C4), Color(0xFFF9A825)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  bottom: -3,
                  left: -5,
                  right: -250,
                  child: Image(
                    image: AssetImage('assets/images/cat-clap.gif'),
                    height: 100,
                    width: 200,
                    //   width:400,
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: -5,
                  right: -5,
                  child: Image.asset(
                    'assets/images/roi.png',
                    width: 700,
                    height: 400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Số từ đúng: $numberWord",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            decoration: TextDecoration.none),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Điểm của bạn:        ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            decoration: TextDecoration.none),
                      ),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/poly-twist-knots.png',
                                  width: 170,
                                ),
                                Text(
                                  content,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      decoration: TextDecoration.none),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AutoSizeText(
                        "Danh sách từ đúng:$_checkMathWord",
                        textAlign: TextAlign.center,
                        minFontSize: 16,
                        style:const TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            padding: 0,
            text: 'Chơi Lại',
            onPressed: () => callback(),
          ),
        ],
      ),
    );
  }
}
