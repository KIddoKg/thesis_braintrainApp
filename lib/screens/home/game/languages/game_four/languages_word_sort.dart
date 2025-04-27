import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

// import 'package:brain_train_app/data/data_language/list_question_four.dart';
import 'package:brain_train_app/services/services.dart';
import 'package:brain_train_app/shared/share_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:word_search/word_search.dart';

import '../../../../../viewModel/data/data_onborad/data_languages_4.dart';
import '../../../../../shared/app_styles.dart';
import '../../../../../shared/light_colors.dart';
import '../../../../../shared/share_data.dart';
import '../../../../onboarding/explanation.dart';
import '../../../../onboarding/home.dart';
import '../Language_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordFind extends StatefulWidget {
  const WordFind({Key? key}) : super(key: key);

  @override
  _WordFindState createState() => _WordFindState();
}

class _WordFindState extends State<WordFind> {
  // sent size to our widget
  GlobalKey<_WordFindWidgetState> globalKey = GlobalKey();

  // make list question for puzzle
  // make class 1st

  @override
  void initState() {
    super.initState();
    initData(); // Call initData here
  }

  Future<List<String>> getWordsFromFirestore() async {
    List<String> wordsList = [];

    try {
      // Lấy tham chiếu của collection "BrainTrainGame"
      CollectionReference brainTrainGameCollection = FirebaseFirestore.instance.collection('BrainTrainGame');

      // Lấy document "WordLanguage4" từ collection "BrainTrainGame"
      DocumentSnapshot wordLanguageDoc = await brainTrainGameCollection.doc('WordLanguage4').get();

      // Kiểm tra xem document có tồn tại không
      if (wordLanguageDoc.exists) {
        // Lấy dữ liệu từ trường 'words' bên trong document
        List<dynamic> words = (wordLanguageDoc.data() as Map<String, dynamic>?)?['words'];

        // Thêm từng từ vào danh sách
        wordsList.addAll(words.map((word) => word.toString()));
      } else {
        print('Document "WordLanguage4" does not exist');
      }
    } catch (error) {
      print('Error retrieving data: $error');
    }

    return wordsList;
  }

  String jsonFile = "lib/viewModel/data/data_language/question_languages_four.json";
  final listQuestions = <WordFindQues>[];

  Future<List<String>> dataFrist() async {
    // final String jsonContent = await rootBundle.loadString(jsonFile);
    // final jsonData = await json.decode(jsonContent);
    // List<String> wordList = (jsonData['word'] as List).cast<String>();
    List<String> wordList = await getWordsFromFirestore();
    return wordList;
  }

  Future<void> initData() async {
    print("djkashdksjahdkajhdkjahdkjashk");
    List<String> jsonLista = await dataFrist();
    print(jsonLista.last);

    for (final word in jsonLista) {
      final words = word.split(' ');

      if (words.length == 2) {
        const question = "Hãy sắp xếp những từ sau thành từ có nghĩa";
        final answer = words.join('');
        final hintindex = answer.indexOf(words[1]);
        final count = answer.length;

        final wordFindQues = WordFindQues(
          question: question,
          answer: answer,
          hintindex: hintindex,
          count: count.toString(),
        );

        listQuestions.add(wordFindQues);
      }

      setState(() {
        // Gọi setState sau khi dữ liệu đã được xử lý để cập nhật giao diện
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    color: Colors.black,
                    // lets make our word find widget
                    // sent list tßo our widget
                    child: FutureBuilder(
                      future: Future.value(true), // Use a dummy future
                      builder: (context, snapshot) {
                        if (listQuestions.isNotEmpty) {
                          return WordFindWidget(
                            constraints.biggest,
                            listQuestions.map((ques) => ques.clone()).toList(),
                            key: globalKey,
                          );
                        } else {
                          return LoadingDot();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// make statefull widget name WordFindWidget
class WordFindWidget extends StatefulWidget {
  Size size;
  List<WordFindQues> listQuestions;

  WordFindWidget(this.size, this.listQuestions, {required Key key})
      : super(key: key);

  @override
  _WordFindWidgetState createState() => _WordFindWidgetState();
}

class _WordFindWidgetState extends State<WordFindWidget> {
  late Size size;
  late List<String> _questionWord;
  late SharedPreferences prefs;
  late List<WordFindQues> listQuestions;

  final int answerDurationInSeconds = 30;
  int indexQues = 0; // current index question
  int hintCount = 0;
  List bao = [0, 1, 2, 3, 4];
  int count = 0;
  bool timeHint = false;
  var i = 0;
  int best = 0;
  int count2 = 3;
  var nextcount = 0;
  int reduceSecondsBy = 1;
  bool back = false;
  bool stopTime = false;
  Timer? countdownTimer;
  Duration answerDuration = const Duration();
  late Timer _timer;

  // thanks for watching.. :)
  int _counter = 60;
  bool resetcount = true;
  bool setPlaygame = false;
  bool resetHint = false;

  Map<String, dynamic> filter = {
    "gameType": "LANGUAGE",
    "gameName": "LETTERS_REARRANGE",
    "maxLevel": null,
    "score": null,
  };

  @override
  void initState() {
    super.initState();
    setStaryPlay();
    size = widget.size;
    listQuestions = widget.listQuestions;

    getLevel();
    generateHint();
    generatePuzzle();
    startTimer();
  }

  @override
  void dispose() {
    // countdownTimer!.cancel();
    _timer.cancel();
    super.dispose();
  }

  Future<void> setStaryPlay() async {
    bool saveSetPlay = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveSetPlay = prefs.getBool("setPlaygameLang4") ?? false;
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
    await prefs.setBool('setPlaygameLang4', setPlaygame);
  }

  getLevel() async {
    // Obtain shared preferences.
    var res = await Services.instance
        .setContext(context)
        .getDataPlayGameUser("LETTERS_REARRANGE");
    if (res!.isSuccess) {
      best = res.data['level'] ?? 1;
    } else {
      best = 1;
    }

    // final prefs = await SharedPreferences.getInstance();
    // int value = prefs.getInt(ShareData.counter) ?? 0;
    // final prefs = await SharedPreferences.getInstance();
    // int level = prefs.getInt(ShareData.level) ?? 0;

    // best = level.toInt();
    setState(() {
      indexQues = best.toInt();
      size = widget.size;
      // listQuestions = value.toString() as List<WordFindQues>;
      generatePuzzle();
    });
  }

  sendData(int best) async {
    filter['maxLevel'] = best;
    filter['score'] = best;

    setState(() {});
    await Services.instance
        .setContext(context)
        .addDataPlayGameUser(filter: filter);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // print(_counter);
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          timeHint = true;
          setEndTimer();
        }
      });
    });
  }

  // void setCountDown() {
  //
  //     reduceSecondsBy = 1;
  //   setState(() {
  //     final seconds = answerDuration.inSeconds - reduceSecondsBy;
  //     print(seconds);
  //     if (seconds == 0) {
  //       timeHint = true;
  //       countdownTimer!.cancel();
  //     } else {
  //       answerDuration = Duration(seconds: seconds);
  //     }
  //   }
  //   );
  // }

  void setEndTimer() {
    _timer.cancel();
    setState(() {
      startTimer();
    });
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
              onPressed: () async {
                back = false;
                Navigator.pop(context, back);
                // Obtain shared preferences.
              },
            ),
            TextButton(
              child: const Text('Có'),
              onPressed: () async {
                back = true;
                Navigator.pop(context, back);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setInt(ShareData.counter, indexQues.toInt());

                // await prefs.setString(
                //     ShareData.counter, listQuestions.toString());
              },
            ),
          ],
        );
      },
    );
  }

  final List<ExplanationData> data = [
    ExplanationData(
      description:
      "Nhấn vào các ô chữ bên dưới, sau đó chữ sẽ hiện lên các ô ở trên",
      title: "Trò chơi Sắp xếp từ",
      localImageSrc:
      "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExN2RjZWY5NTlkNTMzZTg3NDkwMWNhMjI3MDY5ZWVmYzhjMGUzOTY5ZiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/cP2hBBRNjtVSEzXBXt/giphy.gif",
      backgroundColor: AppColors.primaryColor,
    ),
    ExplanationData(
      description:
      "Nếu ấn sai có thể nhấn vào chữ bên trên để chữ có thể trở về vị trí cũ",
      title: "Trò chơi Sắp xếp từ",
      localImageSrc:
      "https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExODM3ZDNmZjRmMDM2NTEzZWE0OWM3MjU1NmYzMTI0M2ZhNWEzODVlOCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/wiIkCCZr4I2ApJd6ZT/giphy.gif",
      backgroundColor: AppColors.primaryColor,
    ),
    ExplanationData(
      description:
      "Sau khi lấp đầy ô chữ, nếu sai các ô sẽ hiện màu đỏ. Có thể bấm vào biểu tượng 2 mũi tên để reset nhanh",
      title: "Trò chơi Sắp xếp từ",
      localImageSrc:
      "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExNjk3OTU2NjA1MmNhZTRhYWJmOTNjOGVjODgwYjg5YWUyMDgyNjA4MyZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/hsKxF3mYkU5WI5B1mQ/giphy.gif",
      backgroundColor: AppColors.primaryColor,
    ),
    ExplanationData(
      description:
      "Nếu quá khó, có thể nhấn vào biểu tượng bóng đèn. Các chữ cái được gợi ý sẽ có màu xanh",
      title: "Trò chơi Sắp xếp từ",
      localImageSrc:
      "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExMWE3MmZlMjEwZmJiN2QzYzdjN2Q5MjVmMjZmOTkwNTYyOWMwMmI4ZSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/aM4Ry9mjEpqBTAArY3/giphy.gif",
      backgroundColor: AppColors.primaryColor,
    ),
    ExplanationData(
      description:
      "Sau khi hoàn thành đúng chữ cái, các ô sẽ hiện màu xanh và tự sang màn",
      title: "Trò chơi Sắp xếp từ",
      localImageSrc:
      "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExYTBkOTU0OTdjNWY0MTE1YWMyZTBhOWIwMDQwMDkxYjAyODkyMmFlMiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/b8HWCPbXJgNOKvzbtk/giphy.gif",
      backgroundColor: AppColors.primaryColor,
    ),
    ExplanationData(
      description:
      "Nếu muốn chơi lại các câu trước, có thể bấm vào nút '<' để trở lại câu trước",
      title: "Trò chơi Sắp xếp từ",
      localImageSrc:
      "https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExOTYzOWQyN2ZlYWFjMWQyMTZhMzc2YTRjOWU0Y2RkOGU2NTZmNDk3ZSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/V4JeDOpRXt6ZKhkYGN/giphy.gif",
      backgroundColor: AppColors.primaryColor,
    ),
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

      stopTime = isTrue;
      setState(() {});
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
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LanguageScreen()));
        Navigator.popUntil(context, ModalRoute.withName('/languageScreen'));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(ShareData.counter, indexQues.toInt());
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
    // lets make ui
    // let put current data on question

    final size = MediaQuery.of(context).size;
    WordFindQues currentQues = listQuestions[indexQues];
    Color? ColorsHint;
    Color? ColorsReset;
    Color? ColorsNext;
    Color? ColorsBack;
    Color? ColorResetHint;
    var test = int.parse(currentQues.count);
    if (indexQues == 0) {
      ColorsBack = ColorsHint = Colors.grey;
    } else {
      ColorsBack = Colors.yellow[900];
    }
    if (count2 > 1 && timeHint == true) {
      ColorsHint = Colors.yellow[900];
    } else {
      ColorsHint = Colors.grey;
    }
    if (resetcount == true && indexQues < best) {
      ColorsReset = Colors.yellow[900];
    } else {
      ColorsReset = Colors.grey;
    }
    if (resetHint == true && indexQues < best && resetcount == false) {
      ColorResetHint = Colors.yellow[900];
    } else if (indexQues < best && currentQues.isDone == false) {
      ColorResetHint = Colors.yellow[900];
    } else {
      ColorResetHint = LightColors.kLightYellow;
    }

    if (currentQues.isDone == true) {
      ColorsNext = Colors.yellow[900];
    } else {
      ColorsNext = Colors.grey;
    }

    // ignore: unnecessary_type_check
    assert(test is int);
    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.maxFinite,
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
                        'https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExNjkyYjNhMzMwMWEzZjFjMDkzZDVmZWQwODE4NWM3Y2Y2MjQxZWZlZCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PXM/emT3fIo9aSbyPvnnuG/giphy.gif'),
                    height: 200,
                    width: 400,
                    //   width:400,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      // margin: const EdgeInsets.all(16),
                      height: size.height * 0.60,
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 16),
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
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 2),
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
                                                    Icons
                                                        .arrow_circle_left_outlined,
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
                                                    _navigateAndDisplaySelection(
                                                        context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.question_mark_rounded,
                                                    size: 35,
                                                  ),
                                                  color: Colors.black,
                                                ),
                                                IconButton(
                                                  onPressed: () {},
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
                                          margin: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 5,
                                            right: 5,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6, horizontal: 22),
                                          height: size.height * 0.43,
                                          decoration: BoxDecoration(
                                            color: LightColors.kLightYellow,
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                  const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  if (count2 >
                                                                      1 &&
                                                                      timeHint ==
                                                                          true) {
                                                                    currentQues
                                                                        .isDone =
                                                                    false;
                                                                    for (var i =
                                                                    0;
                                                                    i < 4;
                                                                    i++) {
                                                                      generatePuzzle(
                                                                          next:
                                                                          true);
                                                                    }
                                                                    generateHint();
                                                                    timeHint =
                                                                    false;
                                                                    currentQues
                                                                        .isFull =
                                                                    false;
                                                                  }

                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .tungsten_outlined,
                                                                  size: 45,
                                                                  color:
                                                                  ColorsHint,
                                                                ),
                                                              ),
                                                              _counter != 0
                                                                  ? Text(
                                                                "$_counter",
                                                                style: const TextStyle(
                                                                    color:
                                                                    Colors.black),
                                                              )
                                                                  : const SizedBox(
                                                                  height:
                                                                  10)
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  if (resetcount ==
                                                                      true &&
                                                                      indexQues <
                                                                          best) {
                                                                    currentQues
                                                                        .isDone =
                                                                    false;
                                                                    generatePuzzle(
                                                                        next:
                                                                        true);
                                                                    // for (var i = 0;
                                                                    // i < 4;
                                                                    // i++) {
                                                                    //   generatePuzzle(
                                                                    //       next: true);
                                                                    // }

                                                                    startTimer();
                                                                    currentQues
                                                                        .isFull =
                                                                    false;

                                                                    setState(
                                                                            () {
                                                                          resetcount =
                                                                          false;
                                                                          resetHint =
                                                                          true;
                                                                        });
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .sync_outlined,
                                                                  size: 45,
                                                                  color:
                                                                  ColorsReset,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  _timer
                                                                      .cancel();
                                                                  if (indexQues !=
                                                                      0) {
                                                                    generatePuzzle(
                                                                        left:
                                                                        true);

                                                                    generateHintAll();
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_back_ios,
                                                                  size: 45,
                                                                  color:
                                                                  ColorsBack,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  _timer
                                                                      .cancel();
                                                                  if (currentQues
                                                                      .isDone ==
                                                                      true) {
                                                                    startTimer();
                                                                    generatePuzzle(
                                                                        next:
                                                                        true);
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 45,
                                                                  color:
                                                                  ColorsNext,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  "Câu hỏi số ${indexQues + 1}",
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                                Container(
                                                  padding:const EdgeInsets.all(10),
                                                  margin: const EdgeInsets.fromLTRB(
                                                      20, 15, 30, 10),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    "${currentQues.question ?? ''}",
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 30,
                                                      horizontal: 0),
                                                  alignment: Alignment.center,
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (context, constraints) {
                                                      return Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        mainAxisSize:
                                                        MainAxisSize.max,
                                                        children: currentQues
                                                            .puzzles
                                                            .map((puzzle) {
                                                          // later change color based condition
                                                          Color? color;

                                                          if (currentQues
                                                              .isDone) {
                                                            color = Colors
                                                                .green[600];
                                                          } else if (puzzle
                                                              .hintShow) {
                                                            color = Colors
                                                                .green[600];
                                                          } else if (currentQues
                                                              .isFull) {
                                                            color = Colors.red;
                                                          } else {
                                                            color = LightColors
                                                                .kLightYellow2;
                                                          }

                                                          return InkWell(
                                                            onTap: () {
                                                              if (puzzle
                                                                  .hintShow ||
                                                                  currentQues
                                                                      .isDone) {
                                                                return;
                                                              }
                                                              currentQues
                                                                  .isFull =
                                                              false;
                                                              // currentQues.isDone = false;
                                                              puzzle
                                                                  .clearValue();
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              alignment:
                                                              Alignment
                                                                  .center,
                                                              decoration:
                                                              BoxDecoration(
                                                                color: color,
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    10),
                                                              ),
                                                              width: constraints
                                                                  .biggest
                                                                  .width /
                                                                  test -
                                                                  6,
                                                              height: constraints
                                                                  .biggest
                                                                  .width /
                                                                  8,
                                                              margin: const EdgeInsets
                                                                  .all(3),
                                                              child: Text(
                                                                "${puzzle.currentValue ?? ''}"
                                                                    .toUpperCase(),
                                                                style:
                                                                const TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Center(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      if (resetHint == true) {
                                                        generateHintAll();
                                                        setState(() {
                                                          resetHint = false;
                                                          resetcount = true;
                                                        });
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .fluorescent_outlined,
                                                      size: 45,
                                                      color: ColorResetHint,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
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
                    const SizedBox(height: 50),
                    if (currentQues.isDone == false)
                      Column(
                        children: [
                          Container(
                            padding:const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: GridView.builder(
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1,
                                crossAxisCount: 5,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 4,
                              ),
                              itemCount: test, // later change
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                bool statusBtn = currentQues.puzzles.indexWhere(
                                        (puzzle) =>
                                    puzzle.currentIndex == index) >=
                                    0;

                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    Color? color = statusBtn
                                    // ? Color(0xFFFFD600)
                                    // : Color(0xFFFFFD9D);
                                        ? const Color(0xFFFFF9EC)
                                        : const Color(0xFFFFFD9D);
                                    Color ColorsRemove;
                                    if (statusBtn == true) {
                                      ColorsRemove = LightColors.kLightYellow;
                                    } else {
                                      ColorsRemove = Colors.black;
                                    }
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      // margin: ,
                                      alignment: Alignment.center,
                                      child: TextButton(
                                        // height: constraints.biggest.height,
                                        child: Text(
                                          currentQues.arrayBtns[index]
                                              .toUpperCase(),
                                          style: TextStyle(
                                            color: ColorsRemove,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (!statusBtn) setBtnClick(index);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> generatePuzzle({
    List<WordFindQues>? loop,
    bool next = false,
    bool left = false,
  }) async {
    _counter = 60;
    resetcount = true;
    // startTimer();
    nextcount = Random().nextInt(listQuestions.length);
    count2 = 3;

    // lets finish up generate puzzle
    if (loop != null) {
      indexQues = 0;
      listQuestions = <WordFindQues>[];
      listQuestions.addAll(loop);
    } else {
      if (next &&
          listQuestions[indexQues].isDone &&
          indexQues < listQuestions.length - 1) {
        nextcount++;
        // await Future.delayed(Duration(seconds: 1));
        indexQues++;
        _saveDailyLang();
        timeHint = false;
        if (indexQues != 0 &&
            indexQues > best &&
            indexQues < listQuestions.length - 1) {
          best++;
          timeHint = false;
          sendData(best);
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(ShareData.level, best.toInt());
      } else if (left && indexQues != 0) {
        indexQues--;
        timeHint = false;
      } else if (indexQues >= listQuestions.length - 1) return;

      setState(() {});

      if (listQuestions[indexQues].isDone) {
        return;
      }
    }

    WordFindQues currentQues = listQuestions[indexQues];

    setState(() {});

    final List<String> wl = [currentQues.answer];
    var test = int.parse(currentQues.count);

    _questionWord = wl[0].split("");

    assert(test is int);


    // check if got error generate random word
    if (_questionWord.isNotEmpty) {
      currentQues.arrayBtns = _questionWord;
      currentQues.arrayBtns.shuffle();
      bool isDone = currentQues.isDone;

      if (!isDone) {
        currentQues.puzzles = List.generate(wl[0].split("").length, (index) {
          return WordFindChar(
              correctValue: currentQues.answer.split("")[index]);
        });
      }
    }

    hintCount = 0; //number hint per ques we hit
    setState(() {});
  }

  generateHint() async {
    // let dclare hint

    WordFindQues currentQues = listQuestions[indexQues];

    // var currentQues;
    List<WordFindChar> puzzleNoHints = currentQues.puzzles
        .where((puzzle) => !puzzle.hintShow && puzzle.currentIndex == null)
        .toList();

    if (puzzleNoHints.isNotEmpty && count2 > 0) {
      hintCount++;
      // int indexHint = Random().nextInt(puzzleNoHints.length);
      // int indexHint2 = Random().nextInt(puzzleNoHints.length);
      int indexHint = 0;
      int indexHint2 = currentQues.hintindex.toInt();
      int countTemp = 0;
      // print(currentQues.hintindex);

      currentQues.puzzles = currentQues.puzzles.map((puzzle) {
        if (!puzzle.hintShow && puzzle.currentIndex == null) countTemp++;

        if (indexHint == countTemp - 1 || indexHint2 == countTemp - 1) {
          puzzle.hintShow = true;
          puzzle.currentValue = puzzle.correctValue;
          count2--;
          puzzle.currentIndex = currentQues.arrayBtns
              .indexWhere((btn) => btn == puzzle.correctValue);
        }

        return puzzle;
      }).toList();

      // check if complete

      if (await currentQues.fieldCompleteCorrect()) {
        currentQues.isDone = true;

        setState(() {});

        await Future.delayed(const Duration(seconds: 1));
        generatePuzzle(next: true);
      }

      // my wrong..not refresh.. damn..haha
      setState(() {});
    }
  }

  generateHintAll() async {
    // let dclare hint
    WordFindQues currentQues = listQuestions[indexQues];

    List<WordFindChar> puzzleNoHints = currentQues.puzzles
        .where((puzzle) => !puzzle.hintShow && puzzle.currentIndex == null)
        .toList();
    // print(puzzleNoHints.length);
    for (var i = 0; i <= puzzleNoHints.length; i++) {
      if (puzzleNoHints.isNotEmpty) {
        hintCount++;
        // int indexHint;
        // for (var i = 0; i <= 10; i++) {

        int indexHint = 0;

        int countTemp = 0;
        // print("hint $indexHint");

        currentQues.puzzles = currentQues.puzzles.map((puzzle) {
          if (!puzzle.hintShow && puzzle.currentIndex == null) countTemp++;

          if (indexHint == countTemp - 1) {
            puzzle.hintShow = true;
            puzzle.currentValue = puzzle.correctValue;
            puzzle.currentIndex = currentQues.arrayBtns
                .indexWhere((btn) => btn == puzzle.correctValue);
          }

          return puzzle;
        }).toList();
        indexHint++;
        // check if complete

        if (await currentQues.fieldCompleteCorrect()) {
          currentQues.isDone = true;

          // setState(() {});

          // await Future.delayed(Duration(seconds: 1));
          // generatePuzzle(next: true);
        }

        // my wrong..not refresh.. damn..haha
        setState(() {});
        // }
      }
    }
  }

  Future<void> setBtnClick(int index) async {
    WordFindQues currentQues = listQuestions[indexQues];

    int currentIndexEmpty =
    currentQues.puzzles.indexWhere((puzzle) => puzzle.currentValue == null);

    if (currentIndexEmpty >= 0) {
      currentQues.puzzles[currentIndexEmpty].currentIndex = index;
      currentQues.puzzles[currentIndexEmpty].currentValue =
      currentQues.arrayBtns[index];

      if (await currentQues.fieldCompleteCorrect()) {
        currentQues.isDone = true;

        setState(() {});

        await Future.delayed(const Duration(seconds: 1));
        generatePuzzle(next: true);
      }
      setState(() {});
    }
  }
}

class WordFindQues {
  var question;
  var shuffled;
  var hintindex;
  var count;
  var answer;
  bool isDone = false;
  bool isFull = false;
  List<WordFindChar> puzzles = <WordFindChar>[];
  List<String> arrayBtns = <String>[];

  WordFindQues({
    this.count,
    this.question,
    this.answer,
    this.hintindex,
    // this.arrayBtns,
  });

  void setWordFindChar(List<WordFindChar> puzzles) => this.puzzles = puzzles;

  void setIsDone() => isDone = true;

  Future<bool> fieldCompleteCorrect() async {
    // lets declare class WordFindChar 1st
    // check all field already got value
    // fix color red when value not full but show red color
    bool complete =
        puzzles.where((puzzle) => puzzle.currentValue == null).isEmpty;

    if (!complete) {
      // no complete yet
      isFull = false;
      return complete;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ShareData.counter, complete.toString());
    // print(complete);

    isFull = true;

    // if already complete, check correct or not

    String answeredString =
    puzzles.map((puzzle) => puzzle.currentValue).join("");
    // if same string, answer is correct..yeay

    return answeredString == answer;
  }

  // more prefer name.. haha
  WordFindQues clone() {
    return WordFindQues(
      answer: answer,
      count: count,
      hintindex: hintindex,
      question: question,
    );
  }

// lets generate sample question
}

// done
class WordFindChar {
  var currentValue;
  var currentIndex;
  var correctValue;
  bool hintShow;

  WordFindChar({
    this.hintShow = false,
    this.correctValue,
    this.currentIndex,
    this.currentValue,
  });

  getCurrentValue() {
    if (correctValue != null) {
      return currentValue;
    } else if (hintShow) return correctValue;
  }

  void clearValue() {
    currentIndex = null;
    currentValue = null;
  }
}
