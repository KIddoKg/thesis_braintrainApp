import 'dart:async';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:brain_train_app/helper/formater.dart';
import 'package:brain_train_app/screens/authenticate/login/LoginScreen.dart';
import 'package:brain_train_app/screens/wrapper.dart';
import 'package:brain_train_app/services/AuthStorage.dart';
import 'package:brain_train_app/shared/app_styles.dart';
import 'package:brain_train_app/shared/notification_service.dart';
import 'package:brain_train_app/shared/share_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_framework/responsive_framework.dart';
// import 'package:flutter_background/flutter_background.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'viewModel/firebase_options.dart';
import 'routes/app_route.dart';
import 'screens/home/home_page/leader.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // tạo app co Android thì chaạy cái nà


  // chạy ios thì mở cái này tắt cái trên
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  AppColors.init();
  runApp(ProviderScope(
    child: MyApp(),
  ));
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
        if (isAllowed) {

          StartDaily();
          getData();
          startTimer();
          CancelCheckoutNotify();
        }
      });
    });
    checkFirebaseConnection();
    WidgetsBinding.instance.addObserver(this);
  }

  void checkFirebaseConnection() {
    FirebaseFirestore.instance.collection("brainTrainApp").get().then((_) {
      if (kDebugMode) {
        print('Đã kết nối với Firebase Firestore');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Không kết nối với Firebase Firestore: $error');
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  late int countDaily;
  late int MinutePassed;
  bool TimeCount = true;
  DateTime previousDate = DateTime(2023, 5, 12);

  Future<void> StartDaily() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    countDaily = prefs.getInt("countDaily") ?? 1;
    if (countDaily == 1) {
      await NotificationService.ReminderNotification();

    }

    await prefs.setInt('countDaily', 2);

  }

  Future<void> CancelCheckoutNotify() async {
    await NotificationService.cancelCheckoutNotifications();

  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (state == AppLifecycleState.paused) {
      TimeCount = false;
      prefs.remove("lock");
    } else if (state == AppLifecycleState.resumed) {
      TimeCount = true;
      prefs.remove("lock");
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      TimeCount = false;
      prefs.remove("lock");
      await NotificationService.TwoDayNotification();
      await NotificationService.FiveDayNotification();
      await NotificationService.WeekNotification();

    }
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? dateTimeString = prefs.getString('previousDate');

    if (dateTimeString != null) {
      previousDate = DateTime.parse(dateTimeString);
      // print("aa$previousDate");
    }

    final currentDate = DateTime.now();

    if (currentDate.day != previousDate.day ||
        currentDate.month != previousDate.month ||
        currentDate.year != previousDate.year) {
      await NotificationService.DailyNotification();

      previousDate = currentDate;
      MinutePassed = 0;
      String previousDateString = previousDate.toIso8601String();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('previousDate', previousDateString);
      await prefs.remove("MinutePassed");
      // MinutePassed = prefs.getInt("MinutePassed") ?? 0;
    }
  }

  Future<void> startTimer() async {
    const oneMin =   Duration(minutes: 1);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MinutePassed = prefs.getInt("MinutePassed") ?? 0;
    Timer.periodic(oneMin, (Timer timer) async {
      if (TimeCount == true) {
        MinutePassed++;
      } else {
        MinutePassed += 0;
      }
      ;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('MinutePassed', MinutePassed);

      if (MinutePassed >= 30) {
        timer.cancel();
        await NotificationService.cancelNotifications();

      }


    });
  }

  // to get the access token
  final AuthStorage authStorage = AuthStorage();

  // This widget is the root of your application.
  @override


  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // builder: (context, child) => ResponsiveBreakpoints.builder(
        //   child: child!,
        //
        //   breakpoints: [
        //     const Breakpoint(start: 0, end: 450, name: MOBILE),
        //     const Breakpoint(start: 451, end: 800, name: TABLET),
        //     const Breakpoint(start: 801, end: 1920, name: DESKTOP),
        //     const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        //   ],
        // ),
        home: FutureBuilder(
          future: authStorage.getAccessToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final accessToken = snapshot.data;
              // Decide which page to show based on the presence of the access token
              if (accessToken != null && accessToken != "") {
                return BottomNavBar(index: 1);
              } else {
                return const LoginScreen();
              }
            }
            return const CircularProgressIndicator();
          },
        ),
        routes: RouteGenerator.routes,
        theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: "Nunito",
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Color(0xFF8B8B8B),
              fontSize: 18,
              fontFamily: "Nunito",
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      );
    });
  }

}

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthStorage authStorage = AuthStorage();

    return FutureBuilder(
      future: authStorage.getAccessToken(),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.done) {
          final accessToken = snapshot.data;
          if (accessToken != null && accessToken != "") {
            child = BottomNavBar(index: 1);
          } else {
            child = const LoginScreen();
          }
        } else {
          child = const Center(child: CircularProgressIndicator());
        }

        // Nếu web thì wrap lại
        if (kIsWeb) {
          return Center(
            child: Container(
              width: 430, // iPhone 14 Pro Max chiều rộng
              height: 932, // iPhone 14 Pro Max chiều cao
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: child,
            ),
          );
        } else {
          return child;
        }
      },
    );
  }
}
