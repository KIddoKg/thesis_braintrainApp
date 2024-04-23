import 'package:brain_train_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';

import 'package:brain_train_app/models/ranking_model.dart';
import '../../../services/services.dart';
import '../../../shared/app_styles.dart';
import '../../../shared/light_colors.dart';
import '../../../shared/share_widgets.dart';

class LeaderScreen extends StatefulWidget {
  const LeaderScreen({Key? key}) : super(key: key);

  @override
  State<LeaderScreen> createState() => _LeaderScreenState();
}

class _LeaderScreenState extends State<LeaderScreen> {
  List<String> listDropdown = ['Tất cả', 'ID', 'Tên', 'Vị trí'];
  DataRanking? dataRanking;
  int _selectedGame = 0;
  String _selectedGameName = "Trí Nhớ";
  List<UserRanking> userDataRanking = [];
  Map<String, dynamic> userRanking = {
    "rank": "Ø",
    "point": "0",
  };
  final PageController _pageController = PageController();
  String indexTab = "Tất cả";
  ScrollController? _hideBottomNavController;
  bool _isVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController.addListener(_handlePageChange);
    _hideBottomNavController = ScrollController();
    _hideBottomNavController?.addListener(
      () {
        if (_hideBottomNavController?.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible) {
            setState(() {
              _isVisible = false;
            });
          }
        }
        if (_hideBottomNavController?.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (!_isVisible) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      },
    );
    initData();
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
        indexTab = "Tất cả";
        break;
      case 1:
        indexTab = "Tuần này";
        break;
      case 2:
        indexTab = "Tháng này";
        break;
    }
    setState(() {});
    // Perform actions based on the current page.
    // print("Current page: $currentPage");
  }

  bool test = false;

  Future<void> initData() async {
    String gameName = selectGameName();
    var res;
    switch (indexTab) {
      case "Tất cả":
        res =
        await Services.instance.setContext(context).getRankingUser(gameName);
        break;
      case "Tuần này":
        res =
        await Services.instance.setContext(context).getRankingUserWeek(gameName);
        break;
      case "Tháng này":
        res =
        await Services.instance.setContext(context).getRankingUserMon(gameName);
        break;
    }


    if (res != null) {
      var data = res.cast<DataRanking>();
      dataRanking = data;
      userDataRanking = data.userRankings;

      if (userDataRanking.isNotEmpty) {
        for (int i = 0; i < dataRanking!.userRankings.length; i++) {
          var e = dataRanking!.userRankings[i];

          if (e.userId == UserModel.instance.accountId) {
            userRanking['rank'] = i + 1;
            userRanking['point'] = e.score;
            break; // Exit the loop when a match is found.
          }
        }
      }

      if (userDataRanking.isEmpty) {
        userRanking['rank'] = "Ø";
        userRanking['point'] = 0;
      } else if (userRanking['rank'] == null) {
        // If no match is found, set "20+" outside of the loop.
        userRanking['rank'] = "20+";
        userRanking['point'] = dataRanking?.myPerformance;
      }


      setState(() {});
    }

    setState(() {});
  }

  Future<void> _handleButtonTap(int selectedIndex, String gameName) async {
    _selectedGame = selectedIndex;
    _selectedGameName = gameName;
    setState(() {});
    await initData();
  }

  String selectGameName() {
    String gameName = "POSITION";
    switch (_selectedGame) {
      case 0:
        gameName = "POSITION";
        break;
      case 1:
        gameName = "NEW_PICTURE";
        break;
      case 2:
        gameName = "LOST_PICTURE";
        break;
      case 3:
        gameName = "DIFFERENCE";

        break;
      case 4:
        gameName = "PAIRING";

        break;
      case 5:
        gameName = "FISHING";

        break;
      case 6:
        gameName = "STARTING_LETTER";

        break;
      case 7:
        gameName = "STARTING_WORD";

        break;
      case 8:
        gameName = "NEXT_WORD";

        break;
      case 9:
        gameName = "LETTERS_REARRANGE";

        break;
      case 10:
        gameName = "SMALLER_EXPRESSION";

        break;
      case 11:
        gameName = "SUM";
        break;
    }
    return gameName;
  }

  final List<String> items = [
    'Mục 1',
    'Mục 2',
    'Mục 3',
    'Mục 4',
    'Mục 5',
    'Mục 1',
    'Mục 2',
    'Mục 3',
    'Mục 4',
    'Mục 5',
    'Mục 1',
    'Mục 2',
    'Mục 3',
    'Mục 4',
    'Mục 5',
    'Mục 6',
    'Mục 7',
    'Mục 8',
    'Mục 9',
  ];

  // @override
  // Widget build(BuildContext context) {
  //   String dropdownValue = listDropdown.first;
  //   return Scaffold(
  //     backgroundColor: AppColors.primaryColor,
  //       appBar: AppBar(
  //         automaticallyImplyLeading: false,
  //         backgroundColor: AppColors.primaryColorBlack,
  //         centerTitle: true,
  //         actions: [
  //           InkWell(
  //             onTap: () {
  //               showPopupInfo(context);
  //             },
  //             child: const Padding(
  //               padding: EdgeInsets.all(8.0),
  //               child: Icon(
  //                 Icons.subject,
  //                 size: 25,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         ],
  //         title: Center(
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(Icons.leaderboard, color: Colors.white,),
  //               SizedBox(width: 10,),
  //               SizedBox(
  //                 width: MediaQuery.of(context).size.width-200 ,
  //                 height:
  //                 50,
  //                 child: Marquee(
  //                   text: "Bảng xếp hạng game ${_selectedGameName}",
  //                   scrollAxis:
  //                   Axis.horizontal,
  //                   crossAxisAlignment:
  //                   CrossAxisAlignment.center,
  //                   blankSpace:
  //                   50.0,
  //                   velocity:
  //                   25.0,
  //                   style:  TextStyle(
  //                       fontSize: 17, color: Colors.white, letterSpacing: 0.53)
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(
  //             bottom: Radius.circular(50),
  //           ),
  //         ),
  //
  //         bottom: PreferredSize(
  //             preferredSize: const Size.fromHeight(100.0),
  //             child: Column(
  //               children: [
  //
  //                 Text(
  //                   "${UserModel.instance.name}",
  //                   style: const TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20),
  //                 ),
  //                 SizedBox(height: 15,),
  //                 Container(
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(
  //                         left: 55, right: 55, bottom: 10),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Column(
  //                           children: [
  //                             Center(
  //                               child: Text(
  //                                 "${userRanking['rank']}", style: TextStyle(
  //                                   fontSize: 16, color: Colors.white),),
  //                             ), Center(
  //                               child: Text("Hạng", style: TextStyle(
  //                                   fontSize: 16, color: Colors.white),),
  //                             )
  //                           ],
  //                         ),
  //                         Spacer(),
  //                         Center(
  //                           child: Row(
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               CircleAvatar(
  //                                 radius: 21,
  //                                 backgroundColor: const Color(0xff37EBBC),
  //                                 child: CircleAvatar(
  //                                   radius: 18,
  //                                   backgroundImage: AssetImage(
  //                                     "assets/avatar.png",
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         Spacer(),
  //                         Column(
  //                           children: [
  //                             Center(
  //                               child: Text(
  //                                 "${userRanking['point']}", style: TextStyle(
  //                                   fontSize: 16, color: Colors.white),),
  //                             ), Center(
  //                               child: Text("Điểm", style: TextStyle(
  //                                   fontSize: 16, color: Colors.white),),
  //                             )
  //                           ],
  //                         )
  //                       ],),
  //                   ),
  //                 ),
  //
  //               ],
  //             )),
  //       ),
  //       body: Container(
  //         width: double.infinity,
  //         height: 900,
  //         color: AppColors.primaryColor,
  //         child:userDataRanking.isNotEmpty
  //             ? Padding(
  //           padding: const EdgeInsets.only(right: 15, left: 15),
  //           child: ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: userDataRanking.length <= 20
  //                   ? userDataRanking.length
  //                   : 20,
  //               itemBuilder: (context, index) {
  //                 UserRanking userRanking = userDataRanking[index];
  //                 return Card(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: ListTile(
  //                       // Rank
  //                         leading: Text(
  //                           "${index + 1}",
  //                           style: TextStyle(
  //                             fontSize: 20.0,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //
  //                         // Country & Username
  //                         title: Row(
  //                           children: [
  //                             // Country
  //                             CircleAvatar(
  //                               radius: 21,
  //                               backgroundColor: const Color(0xff37EBBC),
  //                               child: CircleAvatar(
  //                                 radius: 18,
  //                                 backgroundImage: AssetImage(
  //                                   "assets/avatar.png",
  //                                 ),
  //                               ),
  //                             ),
  //
  //                             Expanded(
  //                               child: Padding(
  //                                 padding: const EdgeInsets.only(left: 5.0),
  //                                 child: Text(
  //                                   "${userRanking.userName}",
  //                                   overflow: TextOverflow.ellipsis,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //
  //                         // Points
  //                         trailing: Container(
  //                           width: 90,
  //                           height: 30,
  //                           decoration: BoxDecoration(
  //                               color: Colors.black,
  //                               border: Border.all(
  //                                   width: 1,
  //                                   color: Colors.black
  //                               ),
  //                               borderRadius: BorderRadius.circular(20)),
  //                           child: Center(
  //                             child: Text(
  //                               "${userRanking.score}",
  //                               style: TextStyle(color: Colors.white),),
  //                           ),
  //                         )
  //                     ),
  //                   ),
  //                 );
  //               }),
  //         ):ErrorsNoti(
  //           text:
  //           "Không có dữ liệu \n trong Game này!",
  //           style: TextStyle(
  //               color: Colors.black54,
  //               fontSize: 20),
  //         )
  //       )
  //       );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   String dropdownValue = listDropdown.first;
  //   return Scaffold(
  //       backgroundColor: AppColors.primaryColor,
  //       appBar: null,
  //       body: Stack(
  //        children: [
  //          CustomScrollView(
  //            controller: _hideBottomNavController,
  //            slivers: <Widget>[
  //              // SliverToBoxAdapter(
  //              //   child: SizedBox(height: 16,),
  //              // ),
  //              SliverAppBar(
  //                automaticallyImplyLeading: false,
  //                backgroundColor: AppColors.primaryColorBlack,
  //                // expandedHeight: 40.0,
  //                // Điều chỉnh chiều cao mở rộng theo nhu cầu của bạn
  //                floating: false,
  //                pinned: false,
  //                snap: false,
  //                stretch: true,
  //                centerTitle: true,
  //                flexibleSpace: Padding(
  //                  padding: const EdgeInsets.only(
  //                    left: 24,
  //                    right: 24,
  //                    top: 8,
  //                  ),
  //                  child: FlexibleSpaceBar(
  //                    background: Container(
  //                      height: 10,
  //                      child: Row(
  //                        crossAxisAlignment: CrossAxisAlignment.center,
  //                        mainAxisAlignment: MainAxisAlignment.center,
  //                        children: [
  //                          Icon(Icons.leaderboard, color: Colors.white),
  //                          Spacer(),
  //                          SizedBox(
  //                            width: MediaQuery
  //                                .of(context)
  //                                .size
  //                                .width - 150,
  //                            height: 50,
  //                            child: Marquee(
  //                              text: "Bảng xếp hạng game ${_selectedGameName}",
  //                              scrollAxis: Axis.horizontal,
  //                              crossAxisAlignment: CrossAxisAlignment.center,
  //                              blankSpace: 50.0,
  //                              velocity: 25.0,
  //                              style: TextStyle(
  //                                fontSize: 17,
  //                                color: Colors.white,
  //                                letterSpacing: 0.53,
  //                              ),
  //                            ),
  //                          ),
  //                          Spacer(),
  //                          InkWell(
  //                            onTap: () {
  //                              showPopupInfo(context);
  //                            },
  //                            child: const Padding(
  //                              padding: EdgeInsets.all(8.0),
  //                              child: Icon(
  //                                Icons.subject,
  //                                size: 25,
  //                                color: Colors.white,
  //                              ),
  //                            ),
  //                          ),
  //                        ],
  //                      ),
  //                    ),
  //                    // centerTitle: false,
  //                    // titlePadding: EdgeInsets.all(0),
  //                    // background: AppBar(),
  //                  ),
  //                ),
  //              ),
  //              SliverAppBar(
  //                automaticallyImplyLeading: false,
  //                backgroundColor: Colors.transparent,
  //                expandedHeight: 550.0,
  //                collapsedHeight: 350,
  //                floating: false,
  //                pinned: true,
  //                snap: false,
  //                stretch: true,
  //                centerTitle: false,
  //                flexibleSpace: ClipRRect(
  //                  borderRadius: BorderRadius.only(
  //                    bottomLeft: Radius.circular(50),
  //                    // Adjust these values for rounded corners
  //                    bottomRight: Radius.circular(50),
  //                  ),
  //                  child: Container(
  //                    color: AppColors.primaryColorBlack,
  //                    child: Padding(
  //                      padding: EdgeInsets.only(
  //                          top: 10.0, right: 16, left: 16, bottom: 16),
  //                      child: Column(
  //                        children: [
  //                          Padding(
  //                              padding: const EdgeInsets.all(8.0),
  //                              child: Column(
  //                                crossAxisAlignment: CrossAxisAlignment.center,
  //                                children: [
  //                                  Center(
  //                                    child: Container(
  //                                      width: 332,
  //                                      height: 35,
  //                                      margin: const EdgeInsets.symmetric(vertical: 5),
  //                                      decoration: BoxDecoration(
  //                                        borderRadius: const BorderRadius.all(
  //                                          Radius.circular(20.0),
  //                                        ),
  //                                        border: Border.all(
  //                                          color: Colors.transparent,
  //                                          width: 1.0,
  //                                        ),
  //                                      ),
  //                                      child: Row(
  //                                        crossAxisAlignment: CrossAxisAlignment.center,
  //                                        children: [
  //                                          Container(
  //                                            decoration: BoxDecoration(
  //                                              borderRadius: const BorderRadius.only(
  //                                                bottomLeft: Radius.circular(10.0),
  //                                                topLeft: Radius.circular(10.0),
  //                                              ),
  //                                              color: indexTab == "Nhiệm vụ"
  //                                                  ? AppColors.primaryColor
  //                                                  : LightColors.kLightYellow,
  //                                            ),
  //                                            width: 110,
  //                                            child: TextButton(
  //                                                onPressed: () {
  //                                                  _pageController.animateToPage(0,
  //                                                      duration:
  //                                                      Duration(milliseconds: 500),
  //                                                      curve: Curves.ease);
  //                                                  indexTab = "Nhiệm vụ";
  //                                                  setState(() {});
  //                                                },
  //                                                child: Text(
  //                                                  "Nhiệm vụ",
  //                                                  style: TextStyle(
  //                                                      color: indexTab == "Nhiệm vụ"
  //                                                          ? Colors.white
  //                                                          : Colors.black,
  //                                                      fontWeight: indexTab == "Nhiệm vụ"
  //                                                          ? FontWeight.w700
  //                                                          : FontWeight.w600),
  //                                                )),
  //                                          ),
  //                                          Container(
  //                                            width: 110,
  //                                            decoration: BoxDecoration(
  //                                              color: indexTab == "Tuần này"
  //                                                  ? AppColors.primaryColor
  //                                                  : LightColors.kLightYellow,
  //                                              border: Border(
  //                                                left: BorderSide(
  //                                                  color: Colors.white,
  //                                                  width: 1.0,
  //                                                ),
  //                                                right: BorderSide(
  //                                                  color: Colors.white,
  //                                                  width: 1.0,
  //                                                ),
  //                                              ),
  //                                            ),
  //                                            child: TextButton(
  //                                                onPressed: () {
  //                                                  print(_pageController);
  //                                                  _pageController.animateToPage(1,
  //                                                      duration:
  //                                                      Duration(milliseconds: 500),
  //                                                      curve: Curves.ease);
  //                                                  indexTab = "Tuần này";
  //                                                  setState(() {});
  //                                                },
  //                                                child: Text(
  //                                                  "Tuần này",
  //                                                  style: TextStyle(
  //                                                      color: indexTab == "Tuần này"
  //                                                          ? Colors.white
  //                                                          : Colors.black,
  //                                                      fontWeight: indexTab == "Tuần này"
  //                                                          ? FontWeight.w700
  //                                                          : FontWeight.w600),
  //                                                )),
  //                                          ),
  //                                          Container(
  //                                            decoration: BoxDecoration(
  //                                              borderRadius: const BorderRadius.only(
  //                                                bottomRight: Radius.circular(10.0),
  //                                                topRight: Radius.circular(10.0),
  //                                              ),
  //                                              color: indexTab == "Tháng này"
  //                                                  ? AppColors.primaryColor
  //                                                  : LightColors.kLightYellow,
  //                                            ),
  //                                            width: 110,
  //                                            child: TextButton(
  //                                                onPressed: () {
  //                                                  indexTab = "Tháng này";
  //                                                  setState(() {});
  //                                                  _pageController.animateToPage(2,
  //                                                      duration:
  //                                                      Duration(milliseconds: 500),
  //                                                      curve: Curves.ease);
  //                                                },
  //                                                child: Text(
  //                                                  "Tháng này",
  //                                                  style: TextStyle(
  //                                                      color: indexTab == "Tháng này"
  //                                                          ? Colors.white
  //                                                          : Colors.black,
  //                                                      fontWeight: indexTab == "Tháng này"
  //                                                          ? FontWeight.w700
  //                                                          : FontWeight.w600),
  //                                                )),
  //                                          )
  //                                        ],
  //                                      ),
  //                                    ),
  //                                  ),
  //                                ],
  //                              )),
  //                          Text(
  //                            "${UserModel.instance.name}",
  //                            style: const TextStyle(
  //                                color: Colors.white,
  //                                fontWeight: FontWeight.bold,
  //                                fontSize: 16),
  //                          ),
  //                          SizedBox(
  //                            height: 15,
  //                          ),
  //                          Container(
  //                            child: Padding(
  //                              padding: const EdgeInsets.only(
  //                                  left: 55, right: 55, bottom: 10),
  //                              child: Row(
  //                                mainAxisAlignment: MainAxisAlignment.center,
  //                                crossAxisAlignment: CrossAxisAlignment.center,
  //                                children: [
  //                                  Column(
  //                                    children: [
  //                                      Center(
  //                                        child: Text(
  //                                          "${userRanking['rank']}",
  //                                          style: TextStyle(
  //                                              fontSize: 16, color: Colors.white),
  //                                        ),
  //                                      ),
  //                                      Center(
  //                                        child: Text(
  //                                          "Hạng",
  //                                          style: TextStyle(
  //                                              fontSize: 16, color: Colors.white),
  //                                        ),
  //                                      )
  //                                    ],
  //                                  ),
  //                                  Spacer(),
  //                                  Center(
  //                                    child: Row(
  //                                      crossAxisAlignment:
  //                                      CrossAxisAlignment.center,
  //                                      mainAxisAlignment: MainAxisAlignment.center,
  //                                      children: [
  //                                        CircleAvatar(
  //                                          radius: 21,
  //                                          backgroundColor:
  //                                          const Color(0xff37EBBC),
  //                                          child: CircleAvatar(
  //                                            radius: 18,
  //                                            backgroundImage: AssetImage(
  //                                              "assets/avatar.png",
  //                                            ),
  //                                          ),
  //                                        ),
  //                                      ],
  //                                    ),
  //                                  ),
  //                                  Spacer(),
  //                                  Column(
  //                                    children: [
  //                                      Center(
  //                                        child: Text(
  //                                          "${userRanking['point']}",
  //                                          style: TextStyle(
  //                                              fontSize: 16, color: Colors.white),
  //                                        ),
  //                                      ),
  //                                      Center(
  //                                        child: Text(
  //                                          "Điểm",
  //                                          style: TextStyle(
  //                                              fontSize: 16, color: Colors.white),
  //                                        ),
  //                                      )
  //                                    ],
  //                                  )
  //                                ],
  //                              ),
  //                            ),
  //                          ),
  //                        ],
  //                      ),
  //                    ),
  //                  ),
  //                ),
  //                shape: RoundedRectangleBorder(
  //                  borderRadius: BorderRadius.vertical(
  //                    bottom: Radius.circular(
  //                        50), // Adjust this value for rounded corners
  //                  ),
  //                ),
  //              ),
  //              userDataRanking.isEmpty ?
  //
  //              SliverList(
  //                  delegate: SliverChildBuilderDelegate(
  //                          (BuildContext context, int index) {
  //                        // UserRanking userRanking = userDataRanking[index];
  //                        // List<String> userRanking = items[index];
  //                        return Padding(
  //                          padding: const EdgeInsets.only(right: 15, left: 15),
  //                          child: Card(
  //                            shape: RoundedRectangleBorder(
  //                              borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
  //                            ),
  //                            child: Padding(
  //                              padding: const EdgeInsets.all(8.0),
  //                              child: ListTile(
  //                                // Rank
  //                                  leading: Text(
  //                                    "${index + 1}",
  //                                    style: TextStyle(
  //                                      fontSize: 20.0,
  //                                      fontWeight: FontWeight.w500,
  //                                    ),
  //                                  ),
  //
  //                                  // Country & Username
  //                                  title: Row(
  //                                    children: [
  //                                      // Country
  //                                      CircleAvatar(
  //                                        radius: 21,
  //                                        backgroundColor: const Color(0xff37EBBC),
  //                                        child: CircleAvatar(
  //                                          radius: 18,
  //                                          backgroundImage: AssetImage(
  //                                            "assets/avatar.png",
  //                                          ),
  //                                        ),
  //                                      ),
  //
  //                                      Expanded(
  //                                        child: Padding(
  //                                          padding: const EdgeInsets.only(
  //                                              left: 5.0),
  //                                          child: SizedBox(
  //                                            height: 50,
  //                                            // width: MediaQuery.of(context).size.width,
  //                                            child: Marquee(
  //                                                text: "${items[index]}",
  //                                                scrollAxis: Axis.horizontal,
  //                                                crossAxisAlignment:
  //                                                CrossAxisAlignment.center,
  //                                                blankSpace: 50.0,
  //                                                velocity: 25.0,
  //                                                style: TextStyle(
  //                                                    fontSize: 17,
  //                                                    color: Colors.black,
  //                                                    letterSpacing: 0.53)),
  //                                          ),
  //                                        ),
  //                                      ),
  //                                    ],
  //                                  ),
  //
  //                                  // Points
  //                                  trailing: Container(
  //                                    width: 90,
  //                                    height: 30,
  //                                    decoration: BoxDecoration(
  //                                        color: Colors.black,
  //                                        border:
  //                                        Border.all(width: 1, color: Colors.black),
  //                                        borderRadius: BorderRadius.circular(20)),
  //                                    child: Center(
  //                                      child: Text(
  //                                        "${items[index]}",
  //                                        style: TextStyle(color: Colors.white),
  //                                      ),
  //                                    ),
  //                                  )),
  //                            ),
  //                          ),
  //                        );
  //                      },
  //                      childCount:
  //                      15
  //                  )):
  //              SliverToBoxAdapter(
  //                  child: Container(
  //                    height: 400,
  //                    child:
  //                    Center(
  //                      child: ErrorsNoti(
  //                        text:
  //                        "Không có dữ liệu \n trong Game này!",
  //                        style: TextStyle(
  //                            color: Colors.black54,
  //                            fontSize: 20),
  //                      ),
  //                    ),
  //
  //                  )
  //
  //              )
  //
  //
  //            ],
  //          ),
  //          Positioned(
  //              bottom: !_isVisible ? 80 : 0,
  //              child: Padding(
  //                padding: const EdgeInsets.all(15.0),
  //                child: AnimatedContainer(
  //                  duration: Duration(milliseconds: 500),
  //                  height: !_isVisible
  //                      ? MediaQuery.of(context).size.height * 0.11
  //                      : MediaQuery.of(context).size.height * 0.00,
  //                  child: Container(
  //
  //                    height: MediaQuery.of(context).size.height * 0.11,
  //                    width: MediaQuery.of(context).size.width -30,
  //                    decoration: BoxDecoration(
  //                      color: AppColors.primaryColorBlack,
  //                      borderRadius:
  //                      const BorderRadius.all(Radius.circular(20)),
  //                      boxShadow: [
  //                        BoxShadow(
  //                          color: Colors.grey, // Color of the shadow
  //                          offset: Offset(0, 4), // Offset of the shadow
  //                          blurRadius: 4, // Radius of the shadow blur
  //                          spreadRadius: 0, // Spread of the shadow
  //                        ),
  //                      ],
  //                    ),
  //                    child: Wrap(
  //                      children: [
  //                        Padding(
  //                          padding: const EdgeInsets.only(
  //                              top: 10, left: 25, right: 25, bottom: 8),
  //                          child: Row(
  //                            children: [
  //                              Expanded(
  //                                flex: 5,
  //                                child: Column(
  //                                  mainAxisAlignment:
  //                                  MainAxisAlignment.spaceEvenly,
  //                                  mainAxisSize: MainAxisSize.min,
  //                                  crossAxisAlignment:
  //                                  CrossAxisAlignment.start,
  //                                  children: [
  //                                    Text(
  //                                      "Hạng của bạn: ",
  //                                      style: TextStyle(
  //                                          color: Colors.white,
  //                                          fontWeight: FontWeight.w400,
  //                                          fontSize: 16),
  //                                    ),
  //
  //                                    ListTile(
  //                                        title: Row(
  //                                          children: [
  //                                            // Country
  //                                            Text(
  //                                              "${userRanking['rank']}",
  //                                              style: TextStyle(
  //                                                fontSize: 20.0,color: Colors.white,
  //                                                fontWeight: FontWeight.w500,
  //                                              ),
  //                                            ),
  //                                            SizedBox(width: 10,),
  //                                            CircleAvatar(
  //                                              radius: 21,
  //                                              backgroundColor: const Color(0xff37EBBC),
  //                                              child: CircleAvatar(
  //                                                radius: 18,
  //                                                backgroundImage: AssetImage(
  //                                                  "assets/avatar.png",
  //                                                ),
  //                                              ),
  //                                            ),
  //
  //                                            Expanded(
  //                                              child: Padding(
  //                                                padding: const EdgeInsets.only(
  //                                                    left: 5.0),
  //                                                child: SizedBox(
  //                                                  height: 50,
  //                                                  // width: MediaQuery.of(context).size.width,
  //                                                  child: Marquee(
  //                                                      text: "${UserModel.instance.name}",
  //                                                      scrollAxis: Axis.horizontal,
  //                                                      crossAxisAlignment:
  //                                                      CrossAxisAlignment.center,
  //                                                      blankSpace: 50.0,
  //                                                      velocity: 25.0,
  //                                                      style: TextStyle(
  //                                                          fontSize: 17,
  //                                                          color: Colors.white,
  //                                                          letterSpacing: 0.53)),
  //                                                ),
  //                                              ),
  //                                            ),
  //                                          ],
  //                                        ),
  //
  //                                        // Points
  //                                        trailing: Container(
  //                                          width: 90,
  //                                          height: 30,
  //                                          decoration: BoxDecoration(
  //                                              color: Colors.black,
  //                                              border:
  //                                              Border.all(width: 1, color: Colors.black),
  //                                              borderRadius: BorderRadius.circular(20)),
  //                                          child: Center(
  //                                            child: Text(
  //                                              "${userRanking['point']}",
  //                                              style: TextStyle(color: Colors.white),
  //                                            ),
  //                                          ),
  //                                        )),
  //                                  ],
  //                                ),
  //                              ),
  //                            ],
  //                          ),
  //                        ),
  //                      ],
  //                    ),
  //                  ),
  //                ),
  //              )),
  //        ],
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = listDropdown.first;

    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: null,
        body: Stack(
          children: [
            NestedScrollView(
              controller: _hideBottomNavController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: AppColors.primaryColorBlack,
                    // expandedHeight: 40.0,
                    // Điều chỉnh chiều cao mở rộng theo nhu cầu của bạn
                    floating: false,
                    pinned: false,
                    snap: false,
                    stretch: true,
                    centerTitle: true,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 8,
                      ),
                      child: FlexibleSpaceBar(
                        background: SizedBox(
                          height: 10,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.leaderboard, color: Colors.white),
                              const Spacer(),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 150,
                                height: 50,
                                child: Marquee(
                                  text:
                                      "Bảng xếp hạng game $_selectedGameName",
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  blankSpace: 50.0,
                                  velocity: 25.0,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    letterSpacing: 0.53,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  showPopupInfo(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.subject,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // centerTitle: false,
                        // titlePadding: EdgeInsets.all(0),
                        // background: AppBar(),
                      ),
                    ),
                  ),
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    expandedHeight: AppColors.sizeUI,
                    collapsedHeight: AppColors.sizeUI,
                    floating: false,
                    pinned: true,
                    snap: false,
                    stretch: true,
                    centerTitle: false,
                    flexibleSpace: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        // Adjust these values for rounded corners
                        bottomRight: Radius.circular(50),
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          color: AppColors.primaryColorBlack,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 14,
                              left: 14,
                            ),
                            child: Column(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(10.0),
                                                topLeft:
                                                    Radius.circular(10.0),
                                              ),
                                              color: indexTab == "Tất cả"
                                                  ? AppColors.primaryColor
                                                  : LightColors
                                                      .kLightYellow,
                                            ),
                        
                                            child: TextButton(
                                                onPressed: () {
                                                  _pageController
                                                      .animateToPage(0,
                                                          duration: const Duration(
                                                              milliseconds:
                                                                  500),
                                                          curve:
                                                              Curves.ease);
                                                  indexTab = "Tất cả";
                                                  setState(() {});
                                                  initData();
                        
                        
                                                },
                                                child: Text(
                                                  "Tất cả",
                                                  style: TextStyle(
                                                      color: indexTab ==
                                                              "Tất cả"
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          indexTab ==
                                                                  "Tất cả"
                                                              ? FontWeight
                                                                  .w700
                                                              : FontWeight
                                                                  .w600),
                                                )),
                                          ),
                                          Container(
                                            height: 35,
                        
                                            decoration: BoxDecoration(
                                              color: indexTab == "Tuần này"
                                                  ? AppColors.primaryColor
                                                  : LightColors
                                                      .kLightYellow,
                                              border:const Border(
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
                        
                                                  _pageController
                                                      .animateToPage(1,
                                                          duration: const Duration(
                                                              milliseconds:
                                                                  500),
                                                          curve:
                                                              Curves.ease);
                                                  indexTab = "Tuần này";
                                                  setState(() {});
                                                  initData();
                        
                                                },
                                                child: Text(
                                                  "Tuần này",
                                                  style: TextStyle(
                                                      color: indexTab ==
                                                              "Tuần này"
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          indexTab ==
                                                                  "Tuần này"
                                                              ? FontWeight
                                                                  .w700
                                                              : FontWeight
                                                                  .w600),
                                                )),
                                          ),
                                          Container(
                                            height: 35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10.0),
                                                topRight:
                                                    Radius.circular(10.0),
                                              ),
                                              color: indexTab == "Tháng này"
                                                  ? AppColors.primaryColor
                                                  : LightColors
                                                      .kLightYellow,
                                            ),
                                  
                                            child: TextButton(
                                                onPressed: () {
                                                  indexTab = "Tháng này";
                                                  setState(() {});
                                                  _pageController
                                                      .animateToPage(2,
                                                          duration: const Duration(
                                                              milliseconds:
                                                                  500),
                                                          curve:
                                                              Curves.ease);
                                                  initData();
                                                },
                                                child: Text(
                                                  "Tháng này",
                                                  style: TextStyle(
                                                      color: indexTab ==
                                                              "Tháng này"
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight: indexTab ==
                                                              "Tháng này"
                                                          ? FontWeight.w700
                                                          : FontWeight
                                                              .w600),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width/3 - 20,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 30),
                                            const Padding(
                                              padding:
                                                    EdgeInsets.all(8.0),
                                              child: Text(
                                                "2",
                                                style:   TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            const Center(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor:
                                                          Color(0xff37EBBC),
                                                    child: CircleAvatar(
                                                      radius: 27,
                                                      backgroundImage:
                                                          AssetImage(
                                                        "assets/avatar.png",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                userDataRanking.isNotEmpty &&
                                                        userDataRanking
                                                                .length >=
                                                            2
                                                    ? "${userDataRanking[1].score}"
                                                    : "Ø",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 19),
                                              ),
                                            ),
                                            Text(
                                              userDataRanking.isNotEmpty &&
                                                      userDataRanking.length >=
                                                          2
                                                  ? userDataRanking[1].userName
                                                  : "", textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white,
                        
                                                  fontSize: 14),
                                              softWrap: true, // Đặt giá trị true để cho phép tự động xuống dòng
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width/3-15,
                                      child: Column(
                                        children: [
                                          Lottie.asset(
                                            'assets/winner.json',
                                            height: 50,
                                            fit: BoxFit.contain,
                                          ),
                                          const Center(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 36,
                                                  backgroundColor:
                                                        Color(0xff37EBBC),
                                                  child: CircleAvatar(
                                                    radius: 33,
                                                    backgroundImage: AssetImage(
                                                      "assets/avatar.png",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              userDataRanking.isNotEmpty &&
                                                      userDataRanking.isNotEmpty
                                                  ? "${userDataRanking[0].score}"
                                                  : "Ø",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 19),
                                            ),
                                          ),
                                          Text(
                                            userDataRanking.isNotEmpty &&
                                                    userDataRanking.isNotEmpty
                                                ? userDataRanking[0].userName
                                                : "",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width/3 - 20,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 18.0),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 30),
                                            const Padding(
                                              padding:
                                                    EdgeInsets.all(8.0),
                                              child: Text(
                                                "3",
                                                style:   TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            const Center(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor:
                                                          Color(0xff37EBBC),
                                                    child: CircleAvatar(
                                                      radius: 27,
                                                      backgroundImage:
                                                          AssetImage(
                                                        "assets/avatar.png",
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                userDataRanking.isNotEmpty &&
                                                        userDataRanking
                                                                .length >=
                                                            3
                                                    ? "${userDataRanking[2].score}"
                                                    : "Ø",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 19),
                                              ),
                                            ),
                                            Text(
                                              userDataRanking.isNotEmpty &&
                                                      userDataRanking.length >=
                                                          3
                                                  ? userDataRanking[2].userName
                                                  : "", textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white,
                        
                                                  fontSize: 14),
                                            ),
                                          ],
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
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(
                            50), // Adjust this value for rounded corners
                      ),
                    ),
                  ),
                ];
              },
              body: PageView(
                controller: _pageController,
                children: [
                  CustomScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: <Widget>[
                      // SliverToBoxAdapter(
                      //   child: SizedBox(height: 16,),
                      // ),

                      userDataRanking.isNotEmpty
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                              UserRanking userRanking =
                                  userDataRanking[index + 3];
                              // List<String> userRanking = items[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 15, left: 15),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0), //<-- SEE HERE
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                        // Rank
                                        leading: Text(
                                          "${index + 4}",
                                          style:const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        // Country & Username
                                        title: Row(
                                          children: [
                                            // Country
                                            const CircleAvatar(
                                              radius: 21,
                                              backgroundColor:
                                                    Color(0xff37EBBC),
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundImage: AssetImage(
                                                  "assets/avatar.png",
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: SizedBox(
                                                  height: 50,
                                                  // width: MediaQuery.of(context).size.width,
                                                  child: Marquee(
                                                      text:
                                                          userRanking.userName,
                                                      scrollAxis:
                                                          Axis.horizontal,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      blankSpace: 50.0,
                                                      velocity: 25.0,
                                                      style:const TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.black,
                                                          letterSpacing: 0.53)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Points
                                        trailing: Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Center(
                                            child: Text(
                                              "${userRanking.score}",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              );
                            },
                                  childCount: userDataRanking.length >= 20
                                      ? 17
                                      : userDataRanking.length - 3))
                          : SliverToBoxAdapter(
                              child: Center(
                              child: ErrorsNoti(
                                text: "Không có dữ liệu \n trong Game này!",
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 20),
                              ),
                            ))
                    ],
                  ),
                  CustomScrollView(
                    physics:const NeverScrollableScrollPhysics(),
                    slivers: <Widget>[
                      // SliverToBoxAdapter(
                      //   child: SizedBox(height: 16,),
                      // ),

                      userDataRanking.isNotEmpty
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                              UserRanking userRanking =
                                  userDataRanking[index + 3];
                              // List<String> userRanking = items[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 15, left: 15),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0), //<-- SEE HERE
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                        // Rank
                                        leading: Text(
                                          "${index + 4}",
                                          style:const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        // Country & Username
                                        title: Row(
                                          children: [
                                            // Country
                                            const CircleAvatar(
                                              radius: 21,
                                              backgroundColor:
                                                    Color(0xff37EBBC),
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundImage: AssetImage(
                                                  "assets/avatar.png",
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: SizedBox(
                                                  height: 50,
                                                  // width: MediaQuery.of(context).size.width,
                                                  child: Marquee(
                                                      text:
                                                          userRanking.userName,
                                                      scrollAxis:
                                                          Axis.horizontal,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      blankSpace: 50.0,
                                                      velocity: 25.0,
                                                      style:const TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.black,
                                                          letterSpacing: 0.53)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Points
                                        trailing: Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Center(
                                            child: Text(
                                              "${userRanking.score}",
                                              style:const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              );
                            },
                                  childCount: userDataRanking.length >= 20
                                      ? 17
                                      : userDataRanking.length - 3))
                          : SliverToBoxAdapter(
                              child: Center(
                              child: ErrorsNoti(
                                text: "Không có dữ liệu \n trong Game này!",
                                style:const TextStyle(
                                    color: Colors.black54, fontSize: 20),
                              ),
                            ))
                    ],
                  ),
                  CustomScrollView(
                    physics:const NeverScrollableScrollPhysics(),
                    slivers: <Widget>[
                      // SliverToBoxAdapter(
                      //   child: SizedBox(height: 16,),
                      // ),

                      userDataRanking.isNotEmpty
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                              UserRanking userRanking =
                                  userDataRanking[index + 3];
                              // List<String> userRanking = items[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.only(right: 15, left: 15),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0), //<-- SEE HERE
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                        // Rank
                                        leading: Text(
                                          "${index + 4}",
                                          style:const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        // Country & Username
                                        title: Row(
                                          children: [
                                            // Country
                                            const CircleAvatar(
                                              radius: 21,
                                              backgroundColor:
                                                    Color(0xff37EBBC),
                                              child: CircleAvatar(
                                                radius: 18,
                                                backgroundImage: AssetImage(
                                                  "assets/avatar.png",
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0),
                                                child: SizedBox(
                                                  height: 50,
                                                  // width: MediaQuery.of(context).size.width,
                                                  child: Marquee(
                                                      text:
                                                          userRanking.userName,
                                                      scrollAxis:
                                                          Axis.horizontal,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      blankSpace: 50.0,
                                                      velocity: 25.0,
                                                      style:const TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.black,
                                                          letterSpacing: 0.53)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Points
                                        trailing: Container(
                                          width: 90,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Center(
                                            child: Text(
                                              "${userRanking.score}",
                                              style:const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              );
                            },
                                  childCount: userDataRanking.length >= 20
                                      ? 17
                                      : userDataRanking.length - 3))
                          : SliverToBoxAdapter(
                              child: Center(
                              child: ErrorsNoti(
                                text: "Không có dữ liệu \n trong Game này!",
                                style:const TextStyle(
                                    color: Colors.black54, fontSize: 20),
                              ),
                            ))
                    ],
                  ),
                  // Other PageView pages
                ],
              ),
            ),
            Positioned(
                bottom: !_isVisible ? 55 : 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: !_isVisible
                        ? MediaQuery.of(context).size.height * 0.11
                        : MediaQuery.of(context).size.height * 0.00,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.11,
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColorBlack,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey, // Color of the shadow
                            offset: Offset(0, 4), // Offset of the shadow
                            blurRadius: 4, // Radius of the shadow blur
                            spreadRadius: 0, // Spread of the shadow
                          ),
                        ],
                      ),
                      child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 25, right: 25, bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                          title: Row(
                                            children: [
                                              // Country
                                              Text(
                                                "${userRanking['rank']}",
                                                style:const TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const CircleAvatar(
                                                radius: 21,
                                                backgroundColor:
                                                      Color(0xff37EBBC),
                                                child: CircleAvatar(
                                                  radius: 18,
                                                  backgroundImage: AssetImage(
                                                    "assets/avatar.png",
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  child: SizedBox(
                                                    height: 50,
                                                    // width: MediaQuery.of(context).size.width,
                                                    child: Marquee(
                                                        text:
                                                            "${UserModel.instance.name}",
                                                        scrollAxis:
                                                            Axis.horizontal,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        blankSpace: 50.0,
                                                        velocity: 25.0,
                                                        style:const TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                            letterSpacing:
                                                                0.53)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Points
                                          trailing: Container(
                                            width: 90,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                              child: Text(
                                                "${userRanking['point']}",
                                                style:const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )),
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
                )),
          ],
        ));
  }

  Future<BuildContext?> showPopupInfo(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        // isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.75,
              expand: false,
              builder: (_, controller) => Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration:  const BoxDecoration(
                  color: Colors.white,
                  borderRadius:   BorderRadius.only(
                    topLeft:   Radius.circular(25.0),
                    topRight:   Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 60, // Độ rộng của hình chữ nhật
                        height: 10, // Chiều cao của hình chữ nhật
                        decoration: BoxDecoration(
                          color: Colors.grey, // Màu nền của hình chữ nhật
                          borderRadius:
                              BorderRadius.circular(20), // Bán kính bo tròn
                        ),
                      ),
                    ),
                    const Wrap(
                      children: [
                        Padding(
                          padding:   EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              "Lọc bảng thành tích",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding:   EdgeInsets.all(15.0),
                        ),
                      ],
                    ),
                    Expanded(
                        child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        // physics: NeverScrollableScrollPhysics(),
                        // shrinkWrap: true,
                        controller: controller,
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration:const BoxDecoration(
                              borderRadius:   BorderRadius.all(
                                Radius.circular(6.0),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                buildGameSectionMain(
                                    "assets/LogoGame/memory-background.png",
                                    "Trí nhớ"),
                                buildGameSection(
                                    "assets/LogoGame/game_memory1.png",
                                    "Ghi nhớ màu", () {
                                  _handleButtonTap(0,
                                      "Ghi nhớ màu"); // Pass the correct title for this section
                                }),
                                buildGameSection(
                                    "assets/LogoGame/game_memory2.png",
                                    "Tìm hình mới", () {
                                  _handleButtonTap(1,
                                      "Tìm hình mới"); // Pass the correct title for this section
                                }),
                                buildGameSection(
                                    "assets/LogoGame/game_memory3.png",
                                    "Đó là hình nào", () {
                                  _handleButtonTap(2,
                                      "Đó là hình nào"); // Pass the correct title for this section
                                }),
// Repeat for the next set of games or activities
                                buildGameSectionMain(
                                    "assets/LogoGame/attention-background.png",
                                    "Tập trung"),
                                buildGameSection(
                                    "assets/LogoGame/game_attention1.png",
                                    "Tìm kiếm", () {
                                  _handleButtonTap(3,
                                      "Tìm kiếm"); // Pass the correct title for this section
                                }),
                                buildGameSection(
                                    "assets/LogoGame/game_attention2.png",
                                    "Bắt cặp", () {
                                  _handleButtonTap(4,
                                      "Bắt cặp"); // Pass the correct title for this section
                                }),
                                buildGameSection(
                                    "assets/LogoGame/game_attention3.png",
                                    "Bắt cá", () {
                                  _handleButtonTap(5,
                                      "Bắt cá"); // Pass the correct title for this section
                                }),
// Language Category
                                buildGameSectionMain(
                                    "assets/LogoGame/language-background.jpg",
                                    "Ngôn ngữ"),
                                buildGameSection(
                                    "assets/LogoGame/game_languages1.png",
                                    "Tìm từ bắt đầu với", () {
                                  _handleButtonTap(6,
                                      "Tìm từ bắt đầu với"); // Pass the correct title for this section
                                }),
                                buildGameSection(
                                    "assets/LogoGame/game_languages2.png",
                                    "Tìm từ tiếp theo", () {
                                  _handleButtonTap(7,
                                      "Tìm từ tiếp theo"); // Pass the correct title for this section
                                }),
                                buildGameSection(
                                    "assets/LogoGame/game_languages3.png",
                                    "Nối từ", () {
                                  _handleButtonTap(8,
                                      "Nối từ"); // Pass the correct title for this section
                                }),
                                buildGameSection(
                                    "assets/LogoGame/game_languages4.png",
                                    "Sắp xếp từ", () {
                                  _handleButtonTap(9,
                                      "Sắp xếp từ"); // Pass the correct title for this section
                                }),
// Math Category
                                buildGameSectionMain(
                                    "assets/LogoGame/math-background.png",
                                    "Toán học"),
                                buildGameSection(
                                    "assets/LogoGame/shoping-math-game.jpg",
                                    "Mua sắm", () {
                                  _handleButtonTap(10,
                                      "Mua sắm"); // Pass the correct title for this section
                                }),
                                buildGameSection(
                                    "assets/LogoGame/plus-math-game-background.png",
                                    "Tìm tổng", () {
                                  _handleButtonTap(11,
                                      "Tìm tổng"); // Pass the correct title for this section
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ));
  }
}
