// // import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:brain_train_app/helper/appsetting.dart';
// import 'package:brain_train_app/shared/light_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter_screen_lock/flutter_screen_lock.dart';
// import '../../../shared/app_styles.dart';
// import '../../../test.dart';
// import '../../wrapper.dart';
// import '../about_us/acount_info.dart';
// import '../daliyWorkout/daily_workout.dart';
// import '../leaderboard_screen/leader_screen.dart';
// import '../setting/Setting_Screen.dart';
// import 'homepage.dart';
//
// class BottomNavBar extends StatefulWidget {
//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//
//   final items = const [
//     Icon(
//       Icons.graphic_eq,
//       size: 30,
//     ),
//     Icon(
//       Icons.home,
//       size: 30,
//     ),
//     Icon(
//       Icons.leaderboard,
//       size: 30,
//     ),
//     Icon(
//       Icons.settings,
//       size: 30,
//     ),
//   ];
//
//   int index = 1;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: getBackgroundColor(index: index),
//       bottomNavigationBar: CurvedNavigationBar(
//         items: items,
//         index: index,
//
//         onTap: (selctedIndex) {
//           setState(() {
//             index = selctedIndex;
//           });
//         },
//         height: 70,
//         // backgroundColor:Color(0xFF212121),
//         backgroundColor: getBackgroundColor(index: index),
//         animationDuration: const Duration(milliseconds: 300),
//         // animationCurve: ,
//       ),
//       body: Container(
//           // color: Color(0xE6FFCD4D),
//           width: double.infinity,
//           height: double.infinity,
//           alignment: Alignment.center,
//           child: getSelectedWidget(index: index)),
//     );
//   }
//
//   Widget getSelectedWidget({required int index}) {
//     Widget widget;
//     switch (index) {
//       case 0:
//         widget = TestWidget();
//         print(0);
//         break;
//       case 2:
//         widget = const LeaderScreen();
//         print(1);
//         break;
//       case 1:
//         widget = const Homepage();
//         print(1);
//         break;
//       default:
//         widget = const AccountScreen();
//         print(4);
//         break;
//     }
//     return widget;
//   }
//
//   Color getBackgroundColor({required int index}) {
//     switch (index) {
//       case 0:
//         return AppColors.primaryColor;// Màu n
//       case 1:
//         return AppColors.primaryColor;// Màu nền cho case 1
//       case 2:
//         return AppColors.primaryColor;// Màu n
//       default:
//         return AppColors.primaryColor;// Màu n
//     }
//   }
// }




import 'package:brain_train_app/shared/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../test.dart';
import '../about_us/acount_info.dart';
import '../leaderboard_screen/leader_screen.dart';
import 'homepage.dart';

class BottomNavBar extends StatefulWidget {
  int index;
  BottomNavBar({super.key, required this.index});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with WidgetsBindingObserver {
  int _tabIndex = 0;

  List<BottomNavigationBarItem> tabs = [
    const BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: 'Trung tâm'),
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trò chơi'),
    const BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Bảng xếp hạng'),
    const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
  ];

  // List<NavigationRailDestination> rails = [
  //   const NavigationRailDestination(icon: Icon(Icons.home), label: Text('')),
  //   const NavigationRailDestination(
  //       icon: FaIcon(FontAwesomeIcons.user), label: Text('')),
  // ];

  var tabViews = [
    TestWidget(),
    const Homepage(),
    const LeaderScreen(),
    const AccountScreen(),
  ];

  GlobalKey qrKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);


  }


  @override

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.red,
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColorBlack ,
        type: BottomNavigationBarType.fixed,
        items: tabs,
        currentIndex: widget.index,
        onTap: (index) => onTapItem(index),
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear
      ),
      body: Row(
        children: [
          Expanded(child: tabViews[widget.index])
        ],
      ),
    );
  }

  onTapItem(index) {
    setState(() {
      widget.index = index;
    });
  }

}
