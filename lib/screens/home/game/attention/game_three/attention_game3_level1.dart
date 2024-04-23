import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notification_center/notification_center.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../services/services.dart';
import '../../../../../shared/app_styles.dart';
import '../../../../../shared/light_colors.dart';
import '../../../../onboarding/explanation.dart';
import '../../../../onboarding/home.dart';
import '../Attention_Screen.dart';
import '../LevelGame/Level1/game/game_main.dart';
import '../LevelGame/Level1/game/game_test.dart';
import 'menu_Level_game3.dart';


class GameAtte3Level1 extends StatefulWidget {
  const GameAtte3Level1({Key? key}) : super(key: key) ;

  @override
  State<GameAtte3Level1> createState() => _GameAtte3Level1State();
}


class _GameAtte3Level1State extends State<GameAtte3Level1> {

  @override
  void initState() {
    super.initState();
    setStaryPlay();
  }

  @override
  void dispose() {
    NotificationCenter().unsubscribe('updateCounter');
    super.dispose();
  }
  bool gameRun = false;
  bool back = false;
  late int AttePass ;
  bool setPlaygame = false;

  //! save daily workout of game math
  Future<void> _saveDailyAtte() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("DailyAtt", true);
    await prefs.setInt("date", DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> setStaryPlay() async {
    bool saveSetPlay = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    saveSetPlay = prefs.getBool("setPlaygameAtte3")??false;
    setState(() {
      setPlaygame = saveSetPlay;
    });
    setPlay();
  }

  Future<void> setPlay()async {
    if(setPlaygame == false){
      _navigateAndDisplaySelection(context);
      setPlaygame = true;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setPlaygameAtte3', setPlaygame);
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
                Navigator.pop(context, back);
              },
            ),
            TextButton(
              child: const Text('Có'),
              onPressed: () {
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

        Navigator.pushReplacement( context,
            MaterialPageRoute(builder: (context) =>const AttentionScreen()));
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
        Navigator.pop(context, back);
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
        "Nhấn vào ô sẵn sàng để bắt đầu game nhiệm vụ của bạn là bắt những chú cá mập lại bắng cách nhập vào những con tuyền nếu trong phạm vi thuyền sẽ phóng ra lưới",
        title: "Trò chơi Bắt cá" ,
        localImageSrc: "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExOTU5OWVlMDljNWQzODE2YjViZGY4YjMwOWQ1MzZmNDZmNzk2MjcxYSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/UPF0adMulZIJUxZK8w/giphy.gif",
        backgroundColor: AppColors.primaryColor),
    ExplanationData(
        description:
        "Nếu bạn để cá mập chạm vào thuyền thanh máu của thuyền sẽ bị giảm đi giảm đến một lượng nhất định bạn sẽ không thể vượt qua màn mới",
        title: "Trò chơi Bắt cá" ,
        localImageSrc: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExNjc4ZGUxZjNiNGE2NmMwOGIxYmIwYTQ2YmM3ODJkY2UzNjhjZmNlZSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/HK2oPQC7Da0JYSSMkj/giphy.gif",
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
      setState(() {

      });
      // Now you can use the `isTrue` boolean value
    }
    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.

  }

  void _handleCheckboxChange(bool value) {
    setState(() {
      gameRun = value;
    });
  }
  Widget _pauseMenuBuilder(BuildContext buildContext, GameMain game) {
    final size = MediaQuery.of(context).size;
    double scrHeight = MediaQuery.of(context).size.height;
    return  WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement( context,
              MaterialPageRoute(builder: (context) => const AttentionScreen()));
          Navigator.popUntil(context, ModalRoute.withName('/attentionScreen'));
          return true;
        },
        child: Scaffold(
          body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Bạn đã Sẵn sàng!',
                      style: TextStyle(
                        color: Color.fromARGB(255, 228, 45, 32),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.3,
                      ),
                    ),
                    SizedBox(height: scrHeight / 60),
                    const Text(
                      'Bảo vệ những con thuyền khỏi những chú cá mập',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                
                        color: Color.fromARGB(255, 83, 74, 73),
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(height: scrHeight / 30),
                    Lottie.asset(
                      'assets/sailing-ship.json',
                      height: size.height*0.3,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: scrHeight / 30),
                    SizedBox(height: scrHeight / 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: gameRun,
                          onChanged: (bool? value) {
                            if (value != null) {
                              _handleCheckboxChange(value);
                            }
                          },
                        ),
                        const Text("Tôi đã đọc kỹ hướng dẫn chơi game")
                      ],
                      
                    ),

                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor : gameRun ?
                        MaterialStateProperty.all(const Color.fromARGB(
                            255, 42, 135, 31)) : MaterialStateProperty.all(const Color.fromARGB(
                            255, 105, 104, 104)) ,
                        elevation: MaterialStateProperty.all(1),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 50, vertical: 25)),
                        shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                              (_) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      onPressed: ()  async {
                        if(gameRun == true) {
                          game.start();
                          game.overlays.remove('start');
                        }else {
                          null;
                        }

                      },
                      child: const Text(
                        'Sẵn sàng, bắt đầu thôi nào!',
                        style: TextStyle(fontSize: 19,color: Colors.white),
                      ),
                    ),
                  ],),
              )),)
    );

  }

  Widget _nextMenuBuilder(BuildContext context, GameMain game) {
    bool back = false;

    double scrHeight = MediaQuery.of(context).size.height;
    _saveDailyAtte();
    String textUnclock;
    return FutureBuilder<SharedPreferences>(

      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.hasData) {
          int? killedEnemy = snapshot.data!.getInt('kill_Result');
          int? heathResult = snapshot.data!.getInt('heath_Result')!;
          int checkLevel =  snapshot.data!.getInt('AttePass') ?? 1;
          if(checkLevel < 2 ) {
            textUnclock= "Cấp độ 2 đã được mở khóa";
          }else{
            textUnclock ="Quay lại màn hình chính";
          }
          if (killedEnemy != null) {
            sendData(killedEnemy,heathResult,"true", level: 1);
            return WillPopScope(
                onWillPop: () async {
                  Navigator.pushReplacement( context,
                      MaterialPageRoute(builder: (context) => const AttentionScreen()));
                  Navigator.popUntil(context, ModalRoute.withName('/attentionScreen'));
                  return true;
                },
                child: Scaffold(
                  body: SafeArea(
                    child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Chúc Mừng!',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 228, 45, 32),
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.3,
                                ),
                              ),
                              SizedBox(height: scrHeight / 60),
                              const Text(
                                'Bạn đã vượt qua cấp độ 1',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 83, 74, 73),
                                  fontSize: 19,
                                ),
                              ),
                              SizedBox(height: scrHeight / 30),
                              Lottie.asset(
                                'assets/congratulation.json',
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: scrHeight / 30),
                              Text(
                                'Điểm: $heathResult\nSố cá bạn đã bắt: $killedEnemy con',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'RobotoSlab',
                                  wordSpacing: 1.2,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: scrHeight / 15),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(const Color.fromARGB(255, 53, 28, 92)),
                                  elevation: MaterialStateProperty.all(1),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(horizontal: 50, vertical: 25)),
                                  shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                                        (_) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                onPressed: () async {

                                  AttePass=2;
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setInt('AttePass', AttePass);
                                  game.overlays.remove('nextlevel');

                                  Navigator.pushReplacement( context,
                                      MaterialPageRoute(builder: (context) => LevelsScreen()));
                                  // Navigator.popUntil(context, ModalRoute.withName('/levelattengame3'));
                                },
                                child:
                                    Text(
                                textUnclock,
                                  style: const TextStyle(fontSize: 19),
                                )
                              ),
                            ],),
                        )),
                  ),)
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
  Map<String, dynamic> filter = {
    "gameType": "ATTENTION",
    "gameName": "FISHING",
    "score": null,
    "noOfFishCaught": null,
    "boatStatus": null,
    "maxLevel": 1,
  };

  sendData(int killedEnemy, int heathResult, String status,{int? level}  ) async {
    filter["score"] = heathResult;
    filter["noOfFishCaught"] = killedEnemy;
    filter["boatStatus"] = status;
    filter["maxLevel"] = level;
    var res = await Services.instance.setContext(context).addDataPlayGameUser(filter: filter);

  }


  Widget _gameOverBuilder(BuildContext context, GameMain game) {
    bool back = false;
    double scrHeight = MediaQuery.of(context).size.height;


    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.hasData) {
          int? killedEnemy = snapshot.data!.getInt('kill_Result');
          int? heathResult = snapshot.data!.getInt('heath_Result')!;

          if (killedEnemy != null) {
            sendData(killedEnemy,heathResult,"false");
            return  WillPopScope(
              onWillPop: () async {
                Navigator.pushReplacement( context,
                    MaterialPageRoute(builder: (context) => const AttentionScreen()));
                Navigator.popUntil(context, ModalRoute.withName('/attentionScreen'));
                return true;
              },
              child: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Thất bại!',
                        style: TextStyle(
                          color: Color.fromARGB(255, 228, 45, 32),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.3,
                        ),
                      ),
                      SizedBox(height: scrHeight / 60),
                      const Text(
                        'Cá mập đã là thuyền của chúng ta bị hư rồi',
                        style: TextStyle(
                          color: Color.fromARGB(255, 83, 74, 73),
                          fontSize: 19,
                        ),
                      ),
                      SizedBox(height: scrHeight / 30),
                      Lottie.asset(
                        'assets/68436-you-lose.json',
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: scrHeight / 30),
                      SizedBox(
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                'Điểm:$heathResult\nSố cá bạn đã bắt : $killedEnemy con',
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'RobotoSlab',
                                  wordSpacing: 1.2,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            isRepeatingAnimation: false,
                          ),
                        ),
                      ),
                      SizedBox(height: scrHeight / 15),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 53, 28, 92)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 50, vertical: 25)),
                          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, back);
                          game.start();

                          game.overlays.remove('gameover');
                        },
                        child: const Text(
                          'Quay lại màn hình chính',
                          style: const TextStyle(fontSize: 19),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );

  }
  @override
  Widget build(BuildContext context) {
    // test();
    GameTest game = GameTest();
    GameMain gamemain = GameMain();
    return WillPopScope(
      onWillPop: () async {
        final back = await showMyDialog(context);
        return back ?? false;
      },
      child:
      // WillPopScope(
      // onWillPop: () async {
      //   final back = await showMyDialog(context);
      //   return back ?? false;
      // },
      Scaffold(
        body: SafeArea(
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
                        height: 350,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 0),
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
                                          onPressed: (){

                                            !gameRun ?  _navigateAndDisplaySelection(context) : null;
                                                            },
                                          icon: const Icon(
                                            Icons.question_mark_rounded,
                                            size: 35,
                                          ),
                                          color: !gameRun ? Colors.black : Colors.grey,
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
                                const SizedBox(height: 10),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: GameWidget<GameMain>(

                                          game: game,
                                          overlayBuilderMap: {
                                            // "${WeaponViewWidget.name}-0": WeaponViewWidget.builder,
                                            // "${WeaponViewWidget.name}-1": WeaponViewWidget.builder,
                                            'start': _pauseMenuBuilder,
                                            'gameover': _gameOverBuilder,
                                            'nextlevel': _nextMenuBuilder,
                                          },
                                          initialActiveOverlays: const [
                                            'start'
                                          ],
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

//   @override
//   void initState() {
//     super.initState();
//     // startTimer();
//     // game.start();
//   }

// Future<void> getData() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   int? killResult = prefs.getInt('kill_Result');
//   print(killResult);
//   if (killResult != null) {
//     // Gán giá trị killResult cho biến __killedEnemy
//     __killedEnemy = killResult;
//   }
//   print("djai");
//
// }



