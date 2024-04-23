

import 'package:brain_train_app/shared/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../test.dart';
import '../about_us/acount_info.dart';
import '../game/attention/Attention_Screen.dart';
import '../leaderboard_screen/leader_screen.dart';
import 'homepage.dart';

class BottomNavBarPage extends StatefulWidget {
  int index;
  String page;
  BottomNavBarPage({super.key, required this.index, required this.page});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage>
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

  late List<Widget> tabViews;

  List<Widget> initData() {
    if (widget.page == "") {
      return [
        TestWidget(),
        const LeaderScreen(),
        const Homepage(),
        const AccountScreen(),
      ];
    } else {
      return [
        TestWidget(),
        const AttentionScreen(),
        const Homepage(),
        const AccountScreen(),
      ];
    }
  }
  GlobalKey qrKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    tabViews = initData();
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
    var isTabAccount = widget.index == 1;
    var isKeyboardShow =
    MediaQuery.of(context).viewInsets.bottom != 0 ? true : false;

    return Scaffold(
        extendBody: true,
        bottomNavigationBar:
             SizedBox(
               height: 80,
               child: BottomNavigationBar(
                 backgroundColor: Colors.white,
                 type: BottomNavigationBarType.fixed,
                 items: tabs,
                 currentIndex: widget.index,
                 onTap: (index) => onTapItem(index),
                 selectedItemColor: AppColors.primaryColor,
                 unselectedItemColor: Colors.grey,
                 showUnselectedLabels: true,
               ),
             )
            ,
        body: Row(
          children: [
            // if (MediaQuery.of(context).size.width >= 640)
            //   SafeArea(
            //     child: NavigationRail(
            //         onDestinationSelected: (int index) {
            //           onTapItem(index);
            //         },
            //         labelType: NavigationRailLabelType.all,
            //         destinations: rails,
            //         minWidth: 55.0,
            //         selectedIndex: widget.index),
            //   ),
            Expanded(child: tabViews[widget.index])
          ],
        ),
        // floatingActionButtonLocation: isTabAccount
        //     ? FloatingActionButtonLocation.endFloat
        //     : FloatingActionButtonLocation.centerDocked,
        );
  }

  onTapItem(index) {
    setState(() {
      widget.index = index;
    });
  }

}
