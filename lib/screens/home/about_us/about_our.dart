// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../../routes/app_route.dart';
//
//
// class AboutScreen extends StatelessWidget {
//   const AboutScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Color(0xFF212121),
//         appBar: AppBar(
//           title: Text(
//             "Về chúng tôi",
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
//               SettingsGroup(
//                 items: [
//                   SettingsItem(
//                     onTap: () {
//                       Navigator.of(context).pushNamed(RouteGenerator.intro);
//                     },
//                     icons: Icons.fingerprint,
//                     iconStyle: IconStyle(
//                       iconsColor: Colors.white,
//                       withBackground: true,
//                       backgroundColor: Color(0xE6105601),
//                     ),
//                     title: 'Giới thiệu về BrainTrain',
//                     // subtitle: "Lock Ziar'App to improve your privacy",
//                   ),
//                 ],
//               ),
//               SettingsGroup(
//                 items: [
//                   SettingsItem(
//                     onTap: () {      Navigator.of(context).pushNamed(RouteGenerator.func);},
//                     icons: Icons.gamepad_outlined,
//                     iconStyle: IconStyle(iconsColor: Colors.black,
//                       withBackground: true,
//                       backgroundColor: Color(0xE6D6FD44),
//                     ),
//                     title: 'Chức năng nhận thức',
//
//                   ),
//                 ],
//               ),
//               // You can add a settings title
//               SettingsGroup(
//                 items: [
//                   SettingsItem(
//                     onTap: () { Navigator.of(context).pushNamed(RouteGenerator.group);},
//                     icons: Icons.group,
//                     iconStyle: IconStyle(
//                       backgroundColor: Color(0xE6C50126),
//                     ),
//                     title: 'Nhóm nghiên cứu',
//                     // subtitle: "Learn more about Ziar'App",
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//
//     );
//   }
// }