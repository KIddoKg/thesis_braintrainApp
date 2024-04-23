// import 'package:flutter/material.dart';
// import 'package:quickalert/quickalert.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../routes/app_route.dart';

// class DailyScreen extends StatefulWidget {
//   const DailyScreen({super.key});

//   @override
//   State<DailyScreen> createState() => _DailyScreenState();
// }

// class _DailyScreenState extends State<DailyScreen> {
//   bool unClock1 = false;
//   bool unClock2 = false;
//   bool unClock3 = false;
//   bool unClock4 = false;
//   String done = "Đã hoàn thành!";
//   String notDone = "Chưa hoàn thành";

//   Future<void> _loadSavedState() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     DateTime savedDate =
//         DateTime.fromMillisecondsSinceEpoch(prefs.getInt('date') ?? 0);
//     DateTime now = DateTime.now();

//     if (savedDate.year != now.year ||
//         savedDate.month != now.month ||
//         savedDate.day != now.day) {
//       setState(() {
//         print("FALSE");
//         unClock1 = false;
//         unClock2 = false;
//         unClock3 = false;
//         unClock4 = false;
//       });
//       await prefs.setBool('DailyMemory', false);
//       await prefs.setBool("DailyAtt", false);
//       await prefs.setBool("DailyLangue", false);
//       await prefs.setBool("DailyMath", false);
//       await prefs.setInt("date", now.millisecondsSinceEpoch);
//     } else {
//       print("TRUE");
//       setState(() {
//         unClock1 = prefs.getBool('DailyMemory') ?? false;
//         unClock2 = prefs.getBool("DailyAtt") ?? false;
//         unClock3 = prefs.getBool("DailyLangue") ?? false;
//         unClock4 = prefs.getBool("DailyMath") ?? false;
//       });
//     }
//   }

//   void showExitDialog(BuildContext context) {
//     QuickAlert.show(
//       context: context,
//       type: QuickAlertType.warning,
//       title: 'Cảnh báo',
//       text: 'Bạn có muốn thoát game?',
//       textColor: const Color.fromARGB(255, 60, 60, 60),
//       confirmBtnText: 'Có',
//       confirmBtnColor: const Color.fromARGB(255, 4, 114, 117),
//       onConfirmBtnTap: () async {
//         Navigator.pop(context);
//         Navigator.pushReplacementNamed(context, RouteGenerator.signin);
//         // await auth.logout();
//       },
//       confirmBtnTextStyle: const TextStyle(
//         color: Colors.white,
//         fontSize: 18,
//         fontWeight: FontWeight.normal,
//       ),
//       showCancelBtn: true,
//       cancelBtnText: 'Không',
//       onCancelBtnTap: () {
//         Navigator.pop(context);
//       },
//       cancelBtnTextStyle: const TextStyle(
//         color: Colors.grey,
//         fontSize: 18,
//         fontWeight: FontWeight.normal,
//       ),
//     );
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _loadSavedState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screen_height = MediaQuery.of(context).size.height;
//     double screen_width = MediaQuery.of(context).size.width;
//     return WillPopScope(
//       onWillPop: () async {
//         showExitDialog(context);
//         return true;
//       },
//       child: Scaffold(
//         body: SafeArea(
//           child: Container(
//             width: double.infinity,
//             height: 900,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.white,
//                     Color(0xE6FFCD4D),
//                   ]),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 //! Memory
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Row(
//                     children: [
//                       Container(
//                         height: screen_height / 10,
//                         width: 100,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                             image: AssetImage("assets/daily/1.png"),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Container(
//                         height: screen_height / 10,
//                         width: screen_width / 1.8,
//                         decoration: BoxDecoration(
//                           color: Colors.white54,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.only(left: 20),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment
//                                 .center, // Căn trục chính theo phía trên bên trái
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Ghi nhớ",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 23,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 unClock1 ? done : notDone,
//                                 style: TextStyle(
//                                   fontSize: 17,
//                                   color: Colors.black,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),

//                 SizedBox(
//                   height: screen_height / 35,
//                 ),

//                 // ! Attention
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Row(
//                     children: [
//                       Container(
//                         height: screen_height / 10,
//                         width: 100,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                             image: AssetImage("assets/daily/2.png"),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Container(
//                         height: screen_height / 10,
//                         width: screen_width / 1.8,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.only(left: 20),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment
//                                 .center, // Căn trục chính theo phía trên bên trái
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Tập Trung",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 23,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 unClock2 ? done : notDone,
//                                 style: TextStyle(
//                                   fontSize: 17,
//                                   color: Colors.black,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),

//                 // ! Langues
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Row(
//                     children: [
//                       Container(
//                         height: screen_height / 10,
//                         width: 100,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                             image: AssetImage("assets/daily/3.png"),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Container(
//                         height: screen_height / 10,
//                         width: screen_width / 1.8,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.only(left: 20),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment
//                                 .center, // Căn trục chính theo phía trên bên trái
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Ngôn Ngữ",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 23,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 unClock3 ? done : notDone,
//                                 style: TextStyle(
//                                   fontSize: 17,
//                                   color: Colors.black,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),

//                 //! Math
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Row(
//                     children: [
//                       Container(
//                         height: screen_height / 10,
//                         width: 100,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           image: DecorationImage(
//                             image: AssetImage("assets/daily/4.png"),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Container(
//                         height: screen_height / 10,
//                         width: screen_width / 1.8,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.only(left: 20),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment
//                                 .center, // Căn trục chính theo phía trên bên trái
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Toán học",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 23,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 unClock4 ? done : notDone,
//                                 style: TextStyle(
//                                   fontSize: 17,
//                                   color: Colors.black,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
