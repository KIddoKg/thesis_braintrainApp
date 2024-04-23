import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../viewModel/data/data_onborad/data_languages_2.dart';
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

class LanguagesFirstWord extends StatefulWidget {
  const LanguagesFirstWord({super.key});

  @override
  State<LanguagesFirstWord> createState() => _LanguagesFirstWordState();
}

class _LanguagesFirstWordState extends State<LanguagesFirstWord> {
  String listWord = "lib/viewModel/data/data_language/question_languages_two.json";
  String total_dictionary = "lib/data/data_language/total_dictionary.json";
  final int answerDurationInSeconds = 200;
  List<String> _firstWord = [""];
  List<String> _userWord = [];
  List<String> _usedWord = [];
  String wordInput = "";
  int statusCode = 0;
  bool stopTime = false;
  int numberWord = 0;
  bool back = false;
  int reduceSecondsBy = 1;
  int score = 0;
  String firstWord = "";
  // int currentIndex = 0;
  String firstCharacter = "";
  List wordList = [];
  Timer? countdownTimer;
  TextEditingController controllerInput = TextEditingController();
  Duration timeDuration = const Duration();
  int flex = 2;
  bool setPlaygame = false;
  late StreamSubscription<bool> keyboardSubscription;

  Map<String, dynamic> filter = {
    "gameType": "LANGUAGE",
    "gameName": "STARTING_WORD",
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
    timeDuration = const Duration();
    // keyboardSubscription.cancel();
    countdownTimer!.cancel();
    controllerInput.dispose();
  super.dispose();
  }
  Future<void> _saveDailyLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("DailyLangue", true);
    await prefs.setInt("date", DateTime.now().millisecondsSinceEpoch);
  }
  Future<void> setStaryPlay() async {
    bool saveSetPlay = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveSetPlay = prefs.getBool("setPlaygameLang2")??false;
    setState(() {
      setPlaygame = saveSetPlay;
    });
    setPlay();
  }

  Future<void> setPlay()async {
    if(setPlaygame == false){
      _navigateAndDisplaySelection(context);
      stopTime = true;
      setPlaygame = true;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setPlaygameLang2', setPlaygame);
  }

  setStartLetter() async {
    // Obtain shared preferences.
    final wordUsedLanguage2 = await SharedPreferences.getInstance();
    List<String>? wordUsedLanguage20 = wordUsedLanguage2.getStringList("wordUsedLanguage2");
    setState(() {
      _usedWord =wordUsedLanguage20!.toList();
    });
  }

  Future<void> setEndTimer() async {
    countdownTimer!.cancel();
    timeDuration = Duration(seconds: 0);
    // _showNotify("Hết giờ", "$score", () {
    //   Navigator.of(context).pop();
    int test =score;
    _saveDailyLang();
    List<String> testString= _userWord;
    String concatenatedString = _userWord.join(',');
    filter["score"] = test;
    filter["wordList"] = concatenatedString;

    var res = await Services.instance.setContext(context).addDataPlayGameUser(filter: filter);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ResultScreen(result: Result(test, testString ), onTap: () {  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LanguageScreen()));
              Navigator.popUntil(
                  context, ModalRoute.withName('/languageScreen')); },)),
    );
    setState(() {
      timeDuration = const Duration();
      score = 0;
      _firstWord = [''];
      _userWord = [];
      numberWord = 0;
      firstWord = "";
      wordInput = "";
      fetchRandomCharacter();
      controllerInput.clear();
      startTimer();
      // });
    });
  }

  void setCountDown() {
    if (stopTime == false) {
      reduceSecondsBy = 1;
    } else {
      reduceSecondsBy = 0;
    }
    setState(() {
      final seconds = timeDuration.inSeconds - reduceSecondsBy;
      if (seconds <= 0) {
        setEndTimer();
      } else {
        timeDuration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timeDuration = Duration(seconds: answerDurationInSeconds);
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

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
    // String userAnswer = controllerInput.text;
    // for (int i = 0; i < _firstWord.length; i++) {
    //   if ("$userAnswer" == _firstWord[i]) {
    //     return false;
    //   }
    // }
    // return true;
    for (int i = 0; i < _userWord.length; i++) {
      if (value == _userWord[i]) {
        return false;
      }
    }
    return true;
  }

  Future<bool> randomLetter(String value) async {
    final String response = await rootBundle.loadString(listWord);
    final data = await json.decode(response);
    for (int i = 0; i < _usedWord.length; i++) {
      if (value == _usedWord[i]) {
        return false;
      }
    }
    return true;
  }

  Future<void> fetchRandomCharacter() async {
    final String response = await rootBundle.loadString(listWord);
    final data = await json.decode(response);
    final wordUsedLanguage2 = await SharedPreferences.getInstance();
    int currentIndex = Random().nextInt(data["word"].length);

    String firstCharacter = data["word"][currentIndex].split(' ')[0];

    bool checkramdomLetter = await randomLetter(firstCharacter);


    setState(() {
      // String firstCharacter = data["word"][currentIndex].split(' ')[0];
      // _firstWord.add(firstCharacter);
      // firstWord = _firstWord[1];
      // wordList = data["word"];

      if(checkramdomLetter){
        _firstWord.add(firstCharacter);
        firstWord = _firstWord[1] ;
        wordList = data["word"];
        _usedWord.add(firstCharacter);
        wordUsedLanguage2.setStringList('wordUsedLanguage2', _usedWord);

      }
      else if(!checkramdomLetter && (_usedWord.length < data["word"].length)){
        fetchRandomCharacter();
      }
      else if(!checkramdomLetter && (_usedWord.length >= data["word"].length)){
        _usedWord=[];
        fetchRandomCharacter();
      }

    });
  }

  void handleClickCheck() async {
    String userAnswer = controllerInput.text;
    String firstWord = _firstWord[1];
    numberWord = _firstWord.length - 1;
    String checkingWord = "$firstWord $userAnswer";
    bool isValidWord = await checkValidWord(checkingWord);
    bool isMatchWord = await checkMatchWord(checkingWord);
    if (!isMatchWord) {
      showToastErrorMatch();
    }
    if (!isValidWord) {
      showToastError();
    }

    if (isValidWord && isMatchWord) {
      _userWord.add(checkingWord);
      score += 200;
      showToastCorrect("+ 200");
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

  final List<ExplanationData> data = [
    ExplanationData(
        description:
        "Đầu tiên nhấn vào ô trống 'Nhập từ ở đây' bàn phím sẽ hiện lên ngay sau đó",
        title: "Trò chơi Tìm từ tiếp theo" ,
        localImageSrc: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExNWYzMzhkOTlmMGEwYWY1NjZjOWQxNTliZjYyNDFjNzNhNzE2ZGFhMyZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/fnGOUWBhwx3FwFnib8/giphy.gif",
        backgroundColor: AppColors.primaryColor),
    ExplanationData(
        description:'Tiếp theo nhập từ vào ô để tạo thành từ có nghĩa',
        title: "Trò chơi Tìm từ tiếp theo" ,
        localImageSrc: "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExMDQ4ZjNiZWNjMzYxZTU5YzNlOWZjOGFlZTc5YjcwNzAzNWZlNDY1MiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/AJO9MtXviec8ZpmeEi/giphy.gif",

        backgroundColor: AppColors.primaryColor),
    ExplanationData(
        description:
        "Sau khi đã nhập xong nhấn nút Gửi và đợi Thông báo cộng điểm",
        title: "Trò chơi Tìm từ tiếp theo" ,
        localImageSrc:  "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExODg0ZmRiMzA5OTQ2OTg2M2RiNzMxZGJjYmUzNmY2YjAyNmJiZjQ0MyZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/4OQPcK6w7Q5e2bODPy/giphy.gif",

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

        Navigator.pushReplacement( context,
            MaterialPageRoute(builder: (context) =>const LanguageScreen()));
        Navigator.popUntil(context, ModalRoute.withName('/languageScreen'));
        final wordUsedLanguage2 = await SharedPreferences.getInstance();
        await wordUsedLanguage2.setStringList('wordUsedLanguage2', _usedWord);
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
                final wordUsedLanguage2 = await SharedPreferences.getInstance();
                await wordUsedLanguage2.setStringList('wordUsedLanguage2', _usedWord);
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
                    left: -290,
                    right: -5,
                    child: Image(
                      image: NetworkImage('https://media2.giphy.com/media/ZNHqbuUEeJKjx7B3GJ/giphy.gif'),
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
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    height:  size.height*0.04,
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
                                              timeDuration.inSeconds /
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
                                                  '${timeDuration.inSeconds} seconds');
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
                                            height:  size.height*0.2,
                                            decoration: BoxDecoration(
                                              color: LightColors.kLightYellow,
                                              borderRadius:
                                              BorderRadius.circular(12),
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      top: 30,
                                                      bottom: 10,
                                                    ),
                                                    child: AutoSizeText(
                                                        "Nhập từ thích hợp bắt đầu bằng chữ $firstWord : ",
                                                        textAlign: TextAlign.center,
                                                        maxLines: 2,
                                                        maxFontSize: 80,
                                                        minFontSize: 22,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 20)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 20, bottom: 20),
                                                    child: AutoSizeText(
                                                        wordInput == ""
                                                            ? "$firstWord _____"
                                                            : "$firstWord $wordInput",
                                                        maxLines: 1,
                                                        minFontSize: 26,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 20)),
                                                  ),
                                                ],
                                              ),
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
                        height:  size.height * 0.01,
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
                      const SizedBox(height: 5),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            SizedBox(
                              width: size.width * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 1, bottom: 1),
                                child: TextField(
                                  controller: controllerInput,
                                  textAlign: TextAlign.center,
                                  maxLength: 7,
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
                                padding: const EdgeInsets.only( bottom: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    handleCheckResult();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellow[600],
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 14),
                                      textStyle: const TextStyle(fontSize: 24)),
                                  child:const AutoSizeText('Gửi',
                                      maxLines: 1,
                                      minFontSize: 22,
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
