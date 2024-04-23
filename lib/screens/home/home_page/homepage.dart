import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:brain_train_app/models/user_model.dart';
import 'package:brain_train_app/shared/light_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:animator/animator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:brain_train_app/models/daily_model.dart';
import '../../../routes/app_route.dart';
import '../../../services/notification_services.dart';
import '../../../services/services.dart';
import '../../../shared/app_styles.dart';
import '../../../shared/notification_ui.dart';
import '../../wrapper.dart';
import 'stack_custom.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool lock = true;
  String tokenNE = "";
  late Daily checkEmoj;
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();

    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Gọi hàm showScreenLock sau khi widget đã được xây dựng hoàn toàn
      initData();
    });

    // if(lock == false)
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomLottieDialog();
          },
        );
      }
    });
  }

  Future<void> saveToken(String token) async {
    try {
      if (UserModel.instance.tokenNotify != token) {
        var res =
            await Services.instance.setContext(context).postNotifyToken(token);
        if (res == true) {
          UserModel.instance.tokenNotify = token;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while saving token: $e");
      }
      // Handle the error as appropriate for your app.
    }
  }

  void initData() async {
    late bool emoj;
    var res = await Services.instance.setContext(context).getDaily();

    if (res == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => EmojiScreen()));
    }
    if (res!.isSuccess) {
      var data = res.cast<Daily>();
      checkEmoj = data;
      if (checkEmoj.sleepHrs == null && checkEmoj.mood == null) {
        emoj = true;
      } else {
        emoj = false;
      }
      setState(() {});
    } else {
      emoj = false;
      setState(() {});
    }
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
      saveToken(value);
    });

    // checkFirebaseConnection();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isActivated = prefs.getBool('lock') ?? true;
    // bool emoj = prefs.getBool('emoj') ?? true; // Retrieving 'emoj'
    if (UserModel.instance.passwordTwo.isNotEmpty && isActivated == true) {
      screenLock(
        context: context,
        title: const Text('Nhập mật khẩu cấp hai'),
        correctString: '${UserModel.instance.passwordTwo}',
        canCancel: false,
        cancelButton: const Icon(Icons.close),
        deleteButton: const Icon(Icons.delete),
        onUnlocked: emoj == true ? unlock : null,
      );
      await prefs.setBool('lock', false);
    } else {
      if (emoj == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EmojiScreen()));
      }
    }
  }

  Future<void> unlock() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lock', false);
    // await prefs.setBool('emoj', true); // Setting 'emoj' to true
    late bool emoj;
    var res = await Services.instance.setContext(context).getDaily();
    if (res!.isSuccess) {
      var data = res.cast<Daily>();
      checkEmoj = data;
      if (checkEmoj.sleepHrs == null && checkEmoj.mood == null) {
        emoj = true;
      } else {
        emoj = false;
      }
      setState(() {});
    } else {
      emoj = false;
      setState(() {});
    }
    bool lockTwo = prefs.getBool('lock') ?? true;

    if (emoj == true && lockTwo == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => EmojiScreen()));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showExitDialog(BuildContext context) {
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.warning,
      title: 'Cảnh báo',
      text: 'Bạn có muốn thoát game?',
      textColor: const Color.fromARGB(255, 60, 60, 60),
      confirmBtnText: 'Có',
      confirmBtnColor: const Color.fromARGB(255, 4, 114, 117),
      onConfirmBtnTap: () async {
        SystemNavigator.pop();
        // Navigator.pop(context);
        // Navigator.pushReplacementNamed(context, RouteGenerator.signin);
        // await auth.logout();
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);
        return true;
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: 900,
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [
            //   Colors.white,
            //       LightColors.kDarkYellow,
            // ])
            color: AppColors.primaryColor,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primaryColorYellow,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: const CircleAvatar(
                              radius: 21,
                              backgroundColor:   Color(0xff37EBBC),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(
                                  "assets/avatar.png",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${UserModel.instance.name}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     Navigator.of(context).pushNamed(RouteGenerator.setting);
                    //   },
                    //   icon: const Icon(Icons.settings),
                    //   color: Colors.black,
                    // )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'CHỌN TRÒ CHƠI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black, fontSize: 25, letterSpacing: 1),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // SizedBox(
              //   width: double.infinity,
              //   height: size.height * 0.03,
              //   child: Animator<double>(
              //     duration: const Duration(milliseconds: 500),
              //     cycles: 0,
              //     curve: Curves.easeInOut,
              //     tween: Tween<double>(begin: 15.0, end: 20.0),
              //     builder: (context, animatorState, child) =>
              //         Icon(
              //           Icons.keyboard_arrow_down,
              //           size: animatorState.value * 3.5,
              //           color: Colors.black,
              //         ),
              //   ),
              // ),
              CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 8),
                    height: size.height * 0.6,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    padEnds: true,
                    viewportFraction: .7,
                  ),
                  items: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: InkWell(
                        onTap: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          bool isActivated = prefs.getBool('lock') ?? true;
                          if (!isActivated ||
                              UserModel.instance.passwordTwo.isEmpty) {
                            Navigator.of(context)
                                .pushNamed(RouteGenerator.memoryScreen);
                          } else {
                            initData();
                          }
                        },
                        child: const CustomStack(
                          image: 'assets/LogoGame/memory-background.png',
                          icon: 'assets/LogoGame/memory.png',
                          text1: 'Trò Chơi Ghi Nhớ',
                          text2: '4 Trò Chơi',
                          padding_left: 5,
                          padding_top: 45,
                          padding: 0,
                          color: Color(0xff444444),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        bool isActivated = prefs.getBool('lock') ?? true;
                        if (!isActivated ||
                            UserModel.instance.passwordTwo.isEmpty) {
                          Navigator.of(context)
                              .pushNamed(RouteGenerator.attentionScreen);
                        } else {
                          initData();
                        }
                      },
                      child: const CustomStack(
                        image: 'assets/LogoGame/attention-background.png',
                        icon: 'assets/LogoGame/attention-icon.png',
                        text1: 'Trò Chơi Tập Trung',
                        text2: '4 Trò Chơi',
                        padding_left: 5,
                        padding_top: 45,
                        padding: 0,
                        color: Color(0xff444444),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        bool isActivated = prefs.getBool('lock') ?? true;
                        if (!isActivated ||
                            UserModel.instance.passwordTwo.isEmpty) {
                          Navigator.of(context)
                              .pushNamed(RouteGenerator.languageScreen);
                        } else {
                          initData();
                        }
                      },
                      child: const CustomStack(
                        image: 'assets/LogoGame/language-background.jpg',
                        icon: 'assets/LogoGame/language-icon.jpg',
                        text1: 'Trò Chơi Ngôn Ngữ',
                        text2: '4 Trò Chơi',
                        padding_left: 5,
                        padding_top: 45,
                        padding: 0,
                        color: Color(0xff2D2D2D),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        bool isActivated = prefs.getBool('lock') ?? true;
                        if (!isActivated ||
                            UserModel.instance.passwordTwo.isEmpty) {
                          Navigator.of(context)
                              .pushNamed(RouteGenerator.mathScreen);
                        } else {
                          initData();
                        }
                      },
                      child: const CustomStack(
                        image: 'assets/LogoGame/math-background.png',
                        icon: 'assets/LogoGame/math-icon.jpg',
                        text1: 'Trò Chơi Tính Toán',
                        text2: '2 Trò Chơi',
                        padding_left: 5,
                        padding_top: 45,
                        padding: 0,
                        color: Color(0xff444444),
                      ),
                    ),
                  ]),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
