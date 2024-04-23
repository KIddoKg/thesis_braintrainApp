import 'package:animations/animations.dart';
import 'package:brain_train_app/routes/app_route.dart';
import 'package:brain_train_app/screens/home/about_us/acount_info.dart';
import 'package:brain_train_app/screens/home/info_page/achievemen_screen.dart';
import 'package:brain_train_app/screens/home/info_page/chart_screen.dart';
import 'package:brain_train_app/services/services.dart';
import 'package:brain_train_app/shared/app_styles.dart';
import 'package:brain_train_app/shared/light_colors.dart';
import 'package:brain_train_app/shared/share_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/daily_model.dart';
import 'models/user_model.dart';

class TestWidget extends StatefulWidget {
  TestWidget({Key? key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  String indexTab = "Nhiệm vụ";
  late Daily checkDaily;

  // late PageController _pageController;

  bool unClock1 = false;
  bool unClock2 = false;
  bool unClock3 = false;
  bool unClock4 = false;
  String day = "";
  int checkMissionCount = 0;

  void checkMission() {
    int trueCount = 0;

    if (unClock1) trueCount++;
    if (unClock2) trueCount++;
    if (unClock3) trueCount++;
    if (unClock4) trueCount++;
    checkMissionCount = trueCount;
    setState(() {});

  }

  Future<void> _loadSavedState() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // DateTime savedDate =
    // DateTime.fromMillisecondsSinceEpoch(prefs.getInt('date') ?? 0);
    // DateTime now = DateTime.now();
    // day = "${now.day}/${now.month}/${now.year}";
    //
    // if (savedDate.year != now.year ||
    //     savedDate.month != now.month ||
    //     savedDate.day != now.day) {
    //   setState(() {
    //     print("FALSE");
    //     unClock1 = false;
    //     unClock2 = false;
    //     unClock3 = false;
    //     unClock4 = false;
    //   });
    //   await prefs.setBool('DailyMemory', false);
    //   await prefs.setBool("DailyAtt", false);
    //   await prefs.setBool("DailyLangue", false);
    //   await prefs.setBool("DailyMath", false);
    //   await prefs.setInt("date", now.millisecondsSinceEpoch);
    // } else {
    //   print("TRUE");
    //   setState(() {
    //     unClock1 = prefs.getBool('DailyMemory') ?? false;
    //     unClock2 = prefs.getBool("DailyAtt") ?? false;
    //     unClock3 = prefs.getBool("DailyLangue") ?? false;
    //     unClock4 = prefs.getBool("DailyMath") ?? false;
    //   });
    // }
    DateTime now = DateTime.now();
    day = "${now.day}/${now.month}/${now.year}";
    var res = await  Services.instance.setContext(context).getDaily();
    if(res!.isSuccess){
      var data = res.cast<Daily>();
      checkDaily = data;
      unClock1 = checkDaily.memoryPlayed;
          unClock2 = checkDaily.attentionPlayed;
          unClock3 = checkDaily.languagePlayed;
          unClock4 = checkDaily.mathPlayed;
    }
    checkMission();
  }

  @override
  void initState() {
    super.initState();
    // _pageController = PageController();
    _pageController.addListener(_handlePageChange);
    _loadSavedState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChange() {
    int? currentPage = _pageController.page?.round();
    switch (currentPage) {
      case 0:
        indexTab = "Nhiệm vụ";
        break;
      case 1:
        indexTab = "Thành tựu";
        break;
      case 2:
        indexTab = "Biểu đồ";
        break;
    }
    setState(() {

    });
    // Perform actions based on the current page.
    // print("Current page: $currentPage");
  }

  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColorBlack,
        centerTitle: true,
        title: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.leaderboard,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 200,
                height: 50,
                child: Marquee(
                    text: "Trung tâm thông tin",
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    blankSpace: 50.0,
                    velocity: 25.0,
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        letterSpacing: 0.53)),
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          ),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 21,
                            backgroundColor:   Color(0xff37EBBC),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(
                                "assets/avatar.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      "${UserModel.instance.name}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 332,
                            height: 35,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              border: Border.all(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0),
                                    ),
                                    color: indexTab == "Nhiệm vụ"
                                        ? AppColors.primaryColor
                                        : LightColors.kLightYellow,
                                  ),

                                  child: TextButton(
                                      onPressed: () {
                                        _pageController.animateToPage(0,
                                            duration:
                                            const Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                        indexTab = "Nhiệm vụ";
                                        setState(() {});
                                      },
                                      child: Text(
                                        "Nhiệm vụ",
                                        style: TextStyle(
                                            color: indexTab == "Nhiệm vụ"
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: indexTab == "Nhiệm vụ"
                                                ? FontWeight.w700
                                                : FontWeight.w600),
                                      )),
                                ),
                                Container(

                                  decoration: BoxDecoration(
                                    color: indexTab == "Thành tựu"
                                        ? AppColors.primaryColor
                                        : LightColors.kLightYellow,
                                    border: const Border(
                                      left: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                      right: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: TextButton(
                                      onPressed: () {

                                        _pageController.animateToPage(1,
                                            duration:
                                            const Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                        indexTab = "Thành tựu";
                                        setState(() {});
                                      },
                                      child: Text(
                                        "Thành tựu",
                                        style: TextStyle(
                                            color: indexTab == "Thành tựu"
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: indexTab == "Thành tựu"
                                                ? FontWeight.w700
                                                : FontWeight.w600),
                                      )),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                    color: indexTab == "Biểu đồ"
                                        ? AppColors.primaryColor
                                        : LightColors.kLightYellow,
                                  ),

                                  child: TextButton(
                                      onPressed: () {
                                        indexTab = "Biểu đồ";
                                        setState(() {});
                                        _pageController.animateToPage(2,
                                            duration:
                                            const Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      },
                                      child: Text(
                                        "Biểu đồ",
                                        style: TextStyle(
                                            color: indexTab == "Biểu đồ"
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: indexTab == "Biểu đồ"
                                                ? FontWeight.w700
                                                : FontWeight.w600),
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            )),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height + 150,
          color: AppColors.primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(top:8.0, bottom: 60, right: 8.0,left: 8.0),
            child: Container(
              decoration:const BoxDecoration(
                borderRadius:   BorderRadius.all(
                  Radius.circular(20.0),
                ),
                color: Colors.white,
              ),
              child: PageView(
                controller: _pageController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 16, right: 6, bottom: 5),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Container(
                                width:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width /
                                    2 -
                                    10,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                  color: LightColors.kLightPurple,
                                ),
                                child:const Padding(
                                  padding:   EdgeInsets.all(9),
                                  child: Text(
                                    "Nhiệm vụ của bạn là hàng ngày phải hoàn thành nhiệm vụ rèn luyện trí não mỗi ngày bằng cách hoàn thành 4 nhiệm vụ sau : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              Container(
                                width:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width /
                                    2 -
                                    50,
                                decoration:const BoxDecoration(
                                  borderRadius:   BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                  color: Colors.transparent,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(9),
                                  child: Image.asset(
                                      "assets/images/daily2.png"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                "Nhiệm vụ ngày hôm nay:",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "Nhiệm vụ: 4 Hoàn thành: $checkMissionCount"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child:    LinearPercentIndicator(
                            padding: EdgeInsets.zero,
                            width:
                            MediaQuery
                                .of(context)
                                .size
                                .width - 50,
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2000,
                            percent: checkMissionCount / 4,
                            barRadius: const Radius.circular(16),
                            progressColor:
                            AppColors.primaryColorGreenPer,
                            backgroundColor:
                            LightColors.backgroundActiveColor,
                          ),
                        ),

                        couponWidget(
                            1,
                            "Hoàn thành một lần chơi game Ghi nhớ",
                            day,
                            unClock1),
                        couponWidget(
                            2,
                            "Hoàn thành một lần chơi game Tập trung",
                            day,
                            unClock2),
                        couponWidget(
                            3,
                            "Hoàn thành một lần chơi game Ngôn ngữ",
                            day,
                            unClock3),
                        couponWidget(
                            4,
                            "Hoàn thành một lần chơi game Toán học",
                            day,
                            unClock4),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  const AchievementScreen(),
                  StatisticalPage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget couponWidget(int index, String title, String dateExp, bool isDone) {
    return Container(
      height: 200,
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: ClipPath(
        clipper: DolDurmaClipper(
            holeRadius: 20, right: MediaQuery
            .of(context)
            .size
            .width * 0.6),
        child: Container(
          decoration: BoxDecoration(
            color: !isDone
                ? AppColors.primaryColorYellow
                : LightColors.backgroundActiveColor,
            border: Border(
              right: BorderSide(
                color: !isDone
                    ? Colors.deepOrange
                    : AppColors.primaryColorGreen, // Màu viền bên phải
                width: 5.0, // Độ rộng của viền
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.23,
                child: Center(
                    child: TextButton(
                      onPressed: () {
                        if (!isDone) {
                          switch (index) {
                            case 1:
                              Navigator.of(context)
                                  .pushNamed(RouteGenerator.memoryScreen);
                              break;
                            case 2:
                              Navigator.of(context)
                                  .pushNamed(RouteGenerator.attentionScreen);
                              break;
                            case 3:
                              Navigator.of(context)
                                  .pushNamed(RouteGenerator.languageScreen);
                              break;
                            case 4:
                              Navigator.of(context)
                                  .pushNamed(RouteGenerator.mathScreen);
                              break;
                          }
                        }
                      },
                      child: Text(
                        !isDone ? "Chưa hoàn thành" : "Hoàn Thành",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: LightColors.kDarkGreenOP,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    )),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                    150 ~/ 10,
                        (index) =>
                        Expanded(
                          child: Container(
                            color: index % 2 == 0
                                ? Colors.transparent
                                : Colors.grey,
                            width: 2,
                          ),
                        )),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 25, left: 25, bottom: 10),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          // width: double.infinity,
                          // height: 30,
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Hết hạn vào ngày $dateExp",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red.withOpacity(0.5),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ), // Bottom widgets
            ],
          ),
        ),
      ),
    );
  }

  Widget accountAppBar(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;

    return Container(
      color: LightColors.kDarkYellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: IconButton(
                icon: UserModel.instance.profileUrl == null ||
                    UserModel.instance.profileUrl == ""
                    ? SvgPicture.asset('assets/avatar.png')
                    : Image.network(UserModel.instance.profileUrl),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
