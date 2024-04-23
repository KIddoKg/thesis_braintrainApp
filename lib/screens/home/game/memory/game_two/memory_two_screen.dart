import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../viewModel/data/data_memory/data_memory_two.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';
import '../../../../../viewModel/data/data_onborad/data_memory_2.dart';
import '../../../../../shared/app_styles.dart';
import '../../../../onboarding/explanation.dart';
import '../../../../onboarding/home.dart';
import '../Memory_Screen.dart';
import 'result_m2.dart';

class MemoryTwoScreen extends StatefulWidget {
  final String levelValue;
  const MemoryTwoScreen({required this.levelValue});

  @override
  State<MemoryTwoScreen> createState() => _MemoryTwoScreenState();
}

class _MemoryTwoScreenState extends State<MemoryTwoScreen> {
  bool _showSuccess = false;
  bool _disableTap = false;
  bool _showFail = false;
  bool _end = false;
  bool _isSwitch = false;
  Timer? timer;
  bool _isLoading = false;
  int? card;

  final double runSpacing = 5;
  final double spacing = 1;
  int columns = 0;
  bool setPlaygame = false;

  Future<void> setStaryPlay() async {
    bool saveSetPlay = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveSetPlay = prefs.getBool("setPlaygameMemo2") ?? false;
    setState(() {
      setPlaygame = saveSetPlay;
    });
    setPlay();
  }

  Future<void> setPlay() async {
    if (setPlaygame == false) {
      _navigateAndDisplaySelection(context);
      setPlaygame = true;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setPlaygameMemo2', setPlaygame);
  }

  //! save daily workout of game math
  Future<void> _saveDailyMemory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("DailyMemory", true);
    await prefs.setInt("date", DateTime.now().millisecondsSinceEpoch);
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

  final List<ExplanationData> data = [
    ExplanationData(
      description: "Bắt đầu game, hãy chọn một hình bất kì và ghi nhớ nó. Ở những lượt tiếp theo, bạn phải chọn những hình mà bạn đã không chọn trước đó",
      title: "Trò chơi Tìm hình mới",
      localImageSrc: "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExZGE3Y2IyYTNkNDdmMWI2MDU4OTBhNzFhMTY1ZGMyZmU0Zjc5Y2Y4YSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/pgjeGFx0DzMxnJhhT7/giphy.gif",
      backgroundColor: AppColors.primaryColor,
    ),
    ExplanationData(
      description: "Nếu chọn sai, bạn sẽ kết thúc lượt một. Lượt 2 sẽ bắt đầu ngay sau đó",
      title: "Trò chơi Tìm hình mới",
      localImageSrc: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExYTlhN2IzYWJkY2MyOGEwMmQ3N2JlZjRmNjZlMzA0OWVkN2U1YjAyZCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/iFAMN8wbUzGt5XmBh2/giphy.gif",
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

  setCard() {
    checkLevelValue();
    if (pairs.length == 80 || pairs.length == 85) {
      card = 45;
    } else if (pairs.length == 28) {
      card = 25;
    }
  }

  getColumn() {
    if (getImg.length <= 12) {
      columns = 3;
    } else if (getImg.length <= 24) {
      columns = 4;
    } else if (getImg.length <= 35) {
      columns = 5;
    } else if (getImg.length <= 50) {
      columns = 6;
    }
    return columns;
  }

  start() {
    numOfCard = 0;
    _disableTap = false;
    _isSwitch = true;
    getImg = pickRandomItemsAsListWithSubList(pairs, 3);
    getImg.shuffle();
    getColumn();
    selectedImageAssetPath = [];
  }

  next() async {
    getImg = getImg
        .where((element) =>
            selectedImageAssetPath.contains(element.imageAssetPath))
        .toList();
    pairs.removeWhere(
        (element) => selectedImageAssetPath.contains(element.imageAssetPath));
    array = pickRandomItemsAsListWithSubList(pairs, 3);
    getImg += array;
    getImg.shuffle();
    getColumn();
  }

  getResult() {
    // * Danh sách chứa các hình ảnh chưa được chọn
    remain = getImg
        .where((element) =>
            !selectedImageAssetPath.contains(element.imageAssetPath))
        .toList();
    // * Dánh sách chứa các chỉ mục của các phẩn tử remain trong getImg
    indicesOfRemain = remain.map((element) => getImg.indexOf(element)).toList();
    // print("Remain: $remain");

    return indicesOfRemain;
  }

  navigationPage() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CongratM2Screen(levelValue: widget.levelValue)),
      );
    });
  }

  Timer? _timerLoad;
  isLoading() {
    _isLoading = true;
    _timerLoad = Timer(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        _disableTap = false;
      });
    });
  }

  // Animation of success
  Timer? _timerSuccess;
  showSuccess() {
    _showSuccess = true;
    _timerSuccess = Timer(const Duration(seconds: 1), () {
      setState(() {
        _showSuccess = false;
      });
    });
  }

  showFail() {
    _showFail = true;
    _timerSuccess = Timer(const Duration(seconds: 2), () {
      setState(() {
        _showFail = false;
      });
    });
  }

  Widget _buildOverlay() {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            color:const  Color(0xffe5f6fe),
          ),
        ),
        // Center(
        //   child: CircularProgressIndicator(),
        // ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    setStaryPlay();
    tries = 1;
    // checkLevelValue();
    setCard();
    score = 0;
    start();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timerSuccess!.cancel();
    timer!.cancel();
    _timerLoad!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = (MediaQuery.of(context).size.width - runSpacing * (columns - 1)) /
        columns;
    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor:const Color(0xffe5f6fe),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icons
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
                  const Text(
                    "Lượt chơi",
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // IconButton(
                      //   onPressed: () {
                      //     print("Back Here");
                      //     // Navigator.push(
                      //     //     context,
                      //     //     MaterialPageRoute(
                      //     //         builder: (context) => const HomePage()));
                      //   },
                      //   icon: const Icon(Icons.lightbulb_outline),
                      //   iconSize: 30,
                      // ),
                      IconButton(
                        onPressed: () {
                          _navigateAndDisplaySelection(context);
                        },
                        icon: const Icon(
                          Icons.question_mark_rounded,
                          size: 30,
                        ),
                        color: Colors.black,
                      ),
                      IconButton(
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
                ],
              ),

              // Dashboard
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const Text(
                        //   "Lượt chơi",
                        //   style: TextStyle(
                        //     color: Colors.black,
                        //     letterSpacing: 1,
                        //     fontSize: 24,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        Text(
                          "$tries/2",
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

              // Game
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Wrap(
                        runSpacing: runSpacing,
                        spacing: spacing,
                        alignment: WrapAlignment.center,
                        children: List.generate(getImg.length, (index) {
                          getResult();
                          return SizedBox(
                            width: w,
                            height: w,
                            child: Tile(
                              imageAssetPath:
                                  getImg[index].getImageAssetPath(),
                              tileIndex: index,
                              parent: this,
                              isBorder: indicesOfRemain.contains(index),
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
                          child: Lottie.network(
                            "https://assets7.lottiefiles.com/packages/lf20_pqpmxbxp.json",
                            height: 200,
                            repeat: true,
                            reverse: true,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    _isLoading ? _buildOverlay() : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  String imageAssetPath;
  int tileIndex;
  _MemoryTwoScreenState parent;
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


                selectedTileIndex = widget.tileIndex;


                widget.parent.setState(() {
                  widget.parent._disableTap = true;
                });
                setState(() {
                  _isSelected = true;
                });
                // *Check selectedImageAssetPath exist image
                // * if exist => Wrong
                // *else not exist => Correct
                checkString = selectedImageAssetPath.where((element) =>
                    element == getImg[widget.tileIndex].getImageAssetPath());


                if (checkString.isEmpty) {
                  // !Correct

                  score += 500;
                  numOfCard++;
                  selectedImageAssetPath
                      .add(getImg[widget.tileIndex].getImageAssetPath());

                  if (selectedImageAssetPath.length == widget.parent.card) {
                    // ! All correct (lượt 1)
                    if (tries < 2) {
                      // *End Tries
                      bonus = numOfCard * 100;
                      score += bonus;
                      numOfCard_1 = numOfCard;

                      widget.parent.showSuccess();
                      widget.parent.timer = Timer(const Duration(seconds: 1), () {
                        widget.parent.setState(() {
                          _isSelected = false;
                          widget.parent.start();
                          tries++;
                        });
                      });
                    } else {
                      // ! End games when all correct (lượt 2)
                      bonus = numOfCard * 200;
                      score += bonus;
                      numOfCard_2 = numOfCard;
                      widget.parent.showSuccess();
                      widget.parent.timer = Timer(const Duration(seconds: 1), () {
                        widget.parent.setState(() {
                          _isSelected = false;
                        });
                      });

                      // widget.parent.timer = Timer(Duration(seconds: 3), () {
                      //   widget.parent.setState(() {
                      //     widget.parent._isSwitch = false;
                      //     widget.parent._end = true;
                      //   });
                      // });

                      widget.parent.timer = Timer(const Duration(seconds: 2), () {
                        widget.parent.setState(() {
                          widget.parent._saveDailyMemory();
                          widget.parent.navigationPage();
                        });
                      });
                    }
                  } else {
                    // *Correct => Continue
                    widget.parent.showSuccess();

                    widget.parent.timer = Timer(const Duration(seconds: 1), () async {
                      widget.parent.isLoading();
                      widget.parent.setState(() {
                        widget.parent.next();
                        _isSelected = false;
                      });
                    });
                  }
                } else {
                  if (tries < 2) {
                    // ! Wrong => END TRIES (lượt 1)
                    print("Wrong/END TRIES");
                    bonus = numOfCard * 100;
                    score += bonus;

                    numOfCard_1 = numOfCard;
                    widget.parent.showFail();
                    widget.parent.timer = Timer(const Duration(seconds: 2), () {
                      widget.parent.setState(() {
                        _isSelected = false;
                      });
                    });

                    widget.parent.timer = Timer(const Duration(seconds: 3), () {
                      widget.parent.setState(() {
                        widget.parent._isSwitch = false;
                        widget.parent._end = true;
                      });
                    });

                    widget.parent.timer = Timer(const Duration(seconds: 5), () {
                      widget.parent.setState(() {
                        widget.parent.start();
                        tries++;
                      });
                    });
                  } else {
                    // ! End games when wrong (lượt 2)
                    bonus = numOfCard * 200;
                    score += bonus;

                    numOfCard_2 = numOfCard;
                    widget.parent.showFail();
                    widget.parent.timer = Timer(const Duration(seconds: 2), () {
                      widget.parent.setState(() {
                        _isSelected = false;
                      });
                    });

                    widget.parent.timer = Timer(const Duration(seconds: 3), () {
                      widget.parent.setState(() {
                        widget.parent._isSwitch = false;
                        widget.parent._end = true;
                      });
                    });

                    widget.parent.timer = Timer(const Duration(seconds: 5), () {
                      widget.parent.setState(() {
                        widget.parent._saveDailyMemory();
                        widget.parent.navigationPage();
                      });
                    });
                  }
                }
              }
            },
      child: Card(
        shape: RoundedRectangleBorder(
          side: widget.parent._isSwitch
              ? _isSelected
                  ? const BorderSide(color: Colors.blue, width: 3)
                  : BorderSide.none
              : widget.parent._end
                  ? widget.isBorder
                      ? const BorderSide(color: Colors.blue, width: 3)
                      : BorderSide.none
                  : BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(widget.imageAssetPath),
          ),
        ),
      ),
    );
  }
}
