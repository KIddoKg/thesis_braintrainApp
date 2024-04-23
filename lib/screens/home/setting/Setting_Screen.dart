// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// import '../../../routes/app_route.dart';
// import '../../../shared/notification_ui.dart';
// import '../home_page/homepage.dart';
// import 'Divider_Custom.dart';
// import 'Setting_Custom.dart';
//
// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({Key? key}) : super(key: key);
//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//         if (isAllowed) {
//           setState(() {
//             Notifi = "On";
//             SwitchNotify = true;
//           });
//
//
//         }else{
//           setState(() {
//             Notifi = "Off";
//             SwitchNotify = false;
//           });
//
//         }
//       });
//
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//
//   String Notifi = "On";
//   bool SwitchNotify = true;
//   bool Checkbutton = false;
//   Future<void> buttonNotifi()async {
//
//     if(Checkbutton = false);
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Color(0xFF212121),
//         // backgroundColor: Colors.grey,
//         appBar: AppBar(
//           title: Text(
//             "Cài đặt",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(10),
//           child: ListView(
//             children: [
//               // user card
//               BigUserCard(
//                 backgroundColor: Color(0xE6105601),
//                 userName: "Arya Muller",
//                 userProfilePic: AssetImage("assets/avatar.png"),
//                 cardActionWidget: SettingsItem(
//                   icons: Icons.edit,
//                   iconStyle: IconStyle(
//                     withBackground: true,
//                     borderRadius: 50,
//                     backgroundColor: Colors.yellow[600],
//                   ),
//                   title: "Thông tin cá nhân",
//                   subtitle: "Thay đổi thông tin của bạn",
//                   onTap: () {
//                     Fluttertoast.showToast(
//                         msg: "Chức năng này đang được phát triển",
//                         toastLength: Toast.LENGTH_SHORT,
//                         gravity: ToastGravity.CENTER,
//                         timeInSecForIosWeb: 1,
//                         backgroundColor: Colors.red,
//                         textColor: Colors.white,
//                         fontSize: 16.0
//                     );
//                   },
//                 ),
//               ),
//               SettingsGroup(
//                 items: [
//                   SettingsItem(
//                     onTap: () {},
//                     icons: CupertinoIcons.pencil_outline,
//                     iconStyle: IconStyle(),
//                     title: 'Thông tin pháp lí',
//                     subtitle: "Một số thông tin pháp lí",
//                   ),
//                   // SettingsItem(
//                   //   onTap: () {},
//                   //   icons: Icons.fingerprint,
//                   //   iconStyle: IconStyle(
//                   //     iconsColor: Colors.white,
//                   //     withBackground: true,
//                   //     backgroundColor: Colors.red,
//                   //   ),
//                   //   title: 'Privacy',
//                   //   subtitle: "Lock Ziar'App to improve your privacy",
//                   // ),
//                   SettingsItem(
//                     onTap: () {
//                       if(SwitchNotify == false) {
//                         Navigator.of(context).pushNamed(RouteGenerator.notify);
//                       }
//                       },
//                     icons: Icons.dark_mode_rounded,
//                     iconStyle: IconStyle(
//                       iconsColor: Colors.white,
//                       withBackground: true,
//                       backgroundColor: Colors.red,
//                     ),
//                     title: 'Thông báo',
//                     subtitle: Notifi,
//                     trailing: Switch.adaptive(
//                       value: SwitchNotify,
//                       onChanged: (value) {
//
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SettingsGroup(
//                 items: [
//                   SettingsItem(
//                     onTap: () {
//                       Navigator.of(context).pushNamed(RouteGenerator.about_us);
//                     },
//                     icons: Icons.info_rounded,
//                     iconStyle: IconStyle(
//                       backgroundColor: Colors.purple,
//                     ),
//                     title: 'Về chúng tôi',
//                     subtitle: "Một số thông tin cơ bản về dự án Brain Train",
//                   ),
//                 ],
//               ),
//               // You can add a settings title
//               SettingsGroup(
//                 settingsGroupTitle: "Tài khoản",
//                 settingsGroupTitleStyle:
//                 TextStyle(color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 22),
//                 items: [
//                   SettingsItem(
//                     onTap: () {},
//                     icons: Icons.exit_to_app_rounded,
//                     title: "Thoát tài khoản",
//                   ),
//                   // SettingsItem(
//                   //   onTap: () {},
//                   //   icons: CupertinoIcons.repeat,
//                   //   title: "Change email",
//                   // ),
//                   // SettingsItem(
//                   //   onTap: () {},
//                   //   icons: CupertinoIcons.delete_solid,
//                   //   title: "Delete account",
//                   //   titleStyle: TextStyle(
//                   //     color: Colors.red,
//                   //     fontWeight: FontWeight.bold,
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
