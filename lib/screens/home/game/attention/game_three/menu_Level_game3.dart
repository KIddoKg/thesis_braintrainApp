

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../routes/app_route.dart';
import '../../../../../services/services.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({Key? key}) : super(key: key);

  @override
  _LevelsScreenState createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  late int unlocklevelpass;
  late double scrHeight;
  int unlocklevel =1;

  @override
  void initState() {
    super.initState();
    unlockLevel();
    setLevel();
  }
  unlockLevel() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    unlocklevel = pref.getInt('AttePass')!;
    setState(() {

    });
  }
  setLevel() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    int unlocklevelCheck = pref.getInt('AttePass')??1;
    var res = await Services.instance.setContext(context).getDataPlayGameUser("FISHING");
    if (res!.isSuccess) {
      unlocklevel =  res.data['level'] ?? 1;
    } else {
      unlocklevel = 1;
    }
    if(unlocklevel<= unlocklevelCheck){
      unlocklevel = unlocklevelCheck;
    }
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    scrHeight = MediaQuery.of(context).size.height;

    // return FutureBuilder<SharedPreferences>(
    //   future: SharedPreferences.getInstance(),
    //   builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
    //     if (snapshot.hasData) {
    //       int? unlocklevel = snapshot.data!.getInt('AttePass');
    //       if(unlocklevel ==null){
    //         unlocklevel = 1;
    //       }
    //
    //
    //
    //     }
    //     return const Center(child: CircularProgressIndicator());
    //   },
    // );
    return WillPopScope(
      onWillPop: () async {
        // Get.offAll(() => const MathScreen());
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RouteGenerator.attentionScreen);
            },
            child: Image.asset(
              'assets/math/go-back.png',
              scale: 2.5,
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: scrHeight / 30),
              Lottie.asset(
                'assets/shark-island-404.json',
                height: scrHeight*0.4,
                fit: BoxFit.contain,
              ),
              SizedBox(height: scrHeight / 30),
              const Text(
                'Cấp độ',
                style: TextStyle(
                  fontSize: 34,
                  fontFamily: 'RobotoSlab',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: scrHeight / 60),
              const Text(
                'Hãy chọn cấp độ bạn muốn chơi:',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'RobotoSlab',
                ),
              ),
              SizedBox(height: scrHeight / 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      //! level 1
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 46, 46, 46)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 25)),
                          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          // glbLevel.value = 1;
                          Navigator.of(context)
                              .pushNamed(RouteGenerator.game3atte1);
                        },
                        child: const Text(
                          'Cấp độ 1',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: scrHeight / 60),

                      //! level 2
                      ElevatedButton(
                        style: (unlocklevel == 2) ||
                            (unlocklevel >= 3)
                            ? ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 46, 46, 46)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                            : ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 174, 174, 174)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if( (unlocklevel == 2) ||
                              (unlocklevel! >= 3)){
                            Navigator.of(context)
                                .pushNamed(RouteGenerator.game3atte2);}
                        },
                        child: const Text(
                          'Cấp độ 2',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: scrHeight / 60),

                      //! level 3
                      ElevatedButton(
                        style: (unlocklevel == 3) ||
                            (unlocklevel >= 4)
                            ? ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 46, 46, 46)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                            : ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 174, 174, 174)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if((unlocklevel == 3) ||
                              (unlocklevel! >= 4)){
                            Navigator.of(context)
                                .pushNamed(RouteGenerator.game3atte3);}
                        },
                        child: const Text(
                          'Cấp độ 3',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: scrHeight / 60),
                      //! level 4
                      ElevatedButton(
                        style: (unlocklevel == 4) ||
                            (unlocklevel >= 5)
                            ? ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 46, 46, 46)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                            : ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 174, 174, 174)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if((unlocklevel == 4) ||
                              (unlocklevel! >= 5)) {
                            Navigator.of(context)
                                .pushNamed(RouteGenerator.game3atte4);
                          }
                        },
                        child: const Text(
                          'Cấp độ 4',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: scrHeight / 60),
                      //! level 5
                      ElevatedButton(
                        style: (unlocklevel == 5) ||
                            (unlocklevel >= 6)
                            ? ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 46, 46, 46)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                            : ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 174, 174, 174)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if((unlocklevel == 5) ||
                              (unlocklevel! >= 6)){
                            Navigator.of(context)
                                .pushNamed(RouteGenerator.game3atte5);
                          }

                        },
                        child: const Text(
                          'Cấp độ 5',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: scrHeight / 60),
                      //! level 6
                      ElevatedButton(
                        style: (unlocklevel ==6) ||
                            (unlocklevel >= 7)
                            ? ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 46, 46, 46)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                            : ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 174, 174, 174)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if( (unlocklevel ==6) ||
                              (unlocklevel! >= 7)){
                            Navigator.of(context)
                                .pushNamed(RouteGenerator.game3atte6);
                          }

                        },
                        child: const Text(
                          'Cấp độ 6',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: scrHeight / 60),
                      //! level 7
                      ElevatedButton(
                        style: (unlocklevel == 7) ||
                            (unlocklevel >= 8)
                            ? ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 46, 46, 46)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                            : ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 174, 174, 174)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if((unlocklevel == 7) ||
                              (unlocklevel! >= 8)){
                            Navigator.of(context)
                                .pushNamed(RouteGenerator.game3atte7);
                          }

                        },
                        child: const Text(
                          'Cấp độ 7',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: scrHeight / 60),
                      //! level 8
                      ElevatedButton(
                        style: (unlocklevel == 8) ||
                            (unlocklevel >= 9)
                            ? ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 46, 46, 46)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                            : ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 174, 174, 174)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if((unlocklevel == 8) ||
                              (unlocklevel! >= 9)){
                            Navigator.of(context)
                                .pushNamed(RouteGenerator.game3atte8);
                          }

                        },
                        child: const Text(
                          'Cấp độ 8',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: scrHeight / 60),
                      //! level 9
                      ElevatedButton(
                        style: (unlocklevel == 9) ||
                            (unlocklevel >= 9)
                            ? ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 46, 46, 46)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                            : ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 174, 174, 174)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if((unlocklevel == 9) ||
                              (unlocklevel! >= 9)){
                            Navigator.of(context)
                                .pushNamed(RouteGenerator.game3atte9);
                          }

                        },
                        child: const Text(
                          'Cấp độ 9',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: scrHeight / 60),
                      //! level 10
                      ElevatedButton(
                        style: (unlocklevel == 10)
                            ? ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 46, 46, 46)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                            : ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 174, 174, 174)),
                          elevation: MaterialStateProperty.all(1),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 25)),
                          shape:
                          MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if(unlocklevel == 10){
                            Navigator.of(context)
                                .pushNamed(RouteGenerator.game3atte10);
                          }

                        },
                        child: const Text(
                          'Cấp độ 10',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: scrHeight / 60),
                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
