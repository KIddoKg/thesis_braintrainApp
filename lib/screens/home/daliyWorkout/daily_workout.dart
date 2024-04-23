import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_route.dart';

class DailyWorkout extends StatefulWidget {
  const DailyWorkout({super.key});

  @override
  State<DailyWorkout> createState() => _DailyWorkoutState();
}

class _DailyWorkoutState extends State<DailyWorkout> {
  bool unClock1 = false;
  bool unClock2 = false;
  bool unClock3 = false;
  bool unClock4 = false;

  Future<void> _loadSavedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime savedDate =
        DateTime.fromMillisecondsSinceEpoch(prefs.getInt('date') ?? 0);
    DateTime now = DateTime.now();

    if (savedDate.year != now.year ||
        savedDate.month != now.month ||
        savedDate.day != now.day) {
      setState(() {
        print("FALSE");
        unClock1 = false;
        unClock2 = false;
        unClock3 = false;
        unClock4 = false;
      });
      await prefs.setBool('DailyMemory', false);
      await prefs.setBool("DailyAtt", false);
      await prefs.setBool("DailyLangue", false);
      await prefs.setBool("DailyMath", false);
      await prefs.setInt("date", now.millisecondsSinceEpoch);
    } else {
      print("TRUE");
      setState(() {
        unClock1 = prefs.getBool('DailyMemory') ?? false;
        unClock2 = prefs.getBool("DailyAtt") ?? false;
        unClock3 = prefs.getBool("DailyLangue") ?? false;
        unClock4 = prefs.getBool("DailyMath") ?? false;
      });
    }
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
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, RouteGenerator.login);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSavedState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F4EF),
              image: DecorationImage(
                image: AssetImage("assets/images/daily2.png"),
                alignment: Alignment.topRight,
              ),
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 50,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight / 20),
                    ClipPath(
                      clipper: BestSellerClipper(),
                      child: Container(
                        color: const Color(0xFFFFD073),
                        padding: const EdgeInsets.only(
                            left: 10, top: 5, right: 20, bottom: 5),
                        child: Text(
                          "Rèn Luyện".toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight / 30),
                    Text("Mỗi ngày",
                        style: kHeadingextStyle.copyWith(fontSize: 32)),
                    SizedBox(height: screenHeight / 30),
                    Row(
                      children: <Widget>[
                        SvgPicture.asset("assets/icons/star.svg"),
                        const SizedBox(width: 5),
                        const Text("Nội dung rèn luyện")
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight / 6),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    // color: Color(0xFFCCD6E8),
                    color: Color(0xfff8e8ee),
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text("CHỨC NĂNG", style: kTitleTextStyle),
                              const SizedBox(height: 30),
                              CourseContent(
                                number: "01",
                                duration: 5.35,
                                title: "Ghi Nhớ",
                                isDone: unClock1,
                              ),
                              CourseContent(
                                number: '02',
                                duration: 19.04,
                                title: "Tập Trung",
                                isDone: unClock2,
                              ),
                              CourseContent(
                                number: '03',
                                duration: 15.35,
                                title: "Ngôn Ngữ",
                                isDone: unClock3,
                              ),
                              CourseContent(
                                number: '04',
                                duration: 5.35,
                                title: "Toán Học",
                                isDone: unClock4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

const kHeadingextStyle = TextStyle(
  fontSize: 28,
  color: Color(0xFF0D1333),
  fontWeight: FontWeight.bold,
);

const kSubtitleTextSyule = TextStyle(
  fontSize: 20,
  color: Color(0xFF0D1333),
  // fontWeight: FontWeight.bold,
);

const kTitleTextStyle = TextStyle(
  fontSize: 20,
  color: Color(0xFF0D1333),
  fontWeight: FontWeight.bold,
);

class BestSellerClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}

class CourseContent extends StatelessWidget {
  final String number;
  final double duration;
  final String title;
  final bool isDone;
  const CourseContent(
      {super.key, required this.number,
      required this.duration,
      required this.title,
      required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: <Widget>[
          Text(
            number,
            style: kHeadingextStyle.copyWith(
              color: const Color(0xFF0D1333).withOpacity(.15),
              fontSize: 32,
            ),
          ),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              children: [
                // TextSpan(
                //   text: "$duration mins\n",
                //   style: TextStyle(
                //     color: Color(0xFF0D1333).withOpacity(.5),
                //     fontSize: 18,
                //   ),
                // ),
                TextSpan(
                  text: title,
                  style: kSubtitleTextSyule.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(left: 20),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: Colors.green.withOpacity(isDone ? 1 : .5),
              color: isDone ? Colors.green : Colors.white.withOpacity(.5),
            ),
            child: const Icon(Icons.check, color: Colors.white),
          )
        ],
      ),
    );
  }
}
