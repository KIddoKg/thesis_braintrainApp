import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../routes/app_route.dart';
import '../../../../../services/services.dart';
import '../Math_Screen.dart';
import 'g2_globals.dart';

class Math2LevelScreen extends StatefulWidget {
  @override
  State<Math2LevelScreen> createState() => _LevelsScreenMathState();
}

class _LevelsScreenMathState extends State<Math2LevelScreen> {
  int curMaxLevel = 1;

  @override
  void initState() {
    super.initState();
    //! set max level = 1 for the first time
    isFirstTime();
    getMaxLevel();
    setLevel();
  }


  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const MathScreen());
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
              Navigator.of(context).pushNamed(RouteGenerator.mathScreen);
            },
            child: Image.asset(
              'assets/math/go-back.png',
              scale: 2.5,
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/math/level1.png',
                  height: 300,
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
                    Globals.glbLevel.value = 1;
                    Navigator.of(context).pushNamed(RouteGenerator.game2Math);
                  },
                  child: const Text(
                    'Cấp độ 1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'RobotoSlab',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: scrHeight / 60),
            
                //! level 2
                ElevatedButton(
                  style: curMaxLevel >= 2
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
                    curMaxLevel >= 2
                        ? {
                            Globals.glbLevel.value = 2,
                            Navigator.of(context)
                                .pushNamed(RouteGenerator.game2Math),
                          }
                        : null;
                  },
                  child: const Text(
                    'Cấp độ 2',
                    style: TextStyle(
                      fontSize: 20,        color: Colors.white,
                      fontFamily: 'RobotoSlab',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: scrHeight / 60),
            
                //! level 3
                ElevatedButton(
                  style: curMaxLevel == 3
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
                    curMaxLevel == 3
                        ? {
                            Globals.glbLevel.value = 3,
                            Navigator.of(context)
                                .pushNamed(RouteGenerator.game2Math),
                          }
                        : null;
                  },
                  child: const Text(
                    'Cấp độ 3',
                    style: TextStyle(
                      fontSize: 20,        color: Colors.white,
                      fontFamily: 'RobotoSlab',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getMaxLevel() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      curMaxLevel = pref.getInt('maxLevel')!;
      Globals.maxUnlockedLevel = pref.getInt('maxLevel')!;
    });
  }
  setLevel() async {
    var res = await Services.instance.setContext(context).getDataPlayGameUser(
        "SUM");
    if (res!.isSuccess) {
      curMaxLevel = res.data['level'] ?? 1;
    } else {
      curMaxLevel = 1;
      setState(() {

      });
    }
  }

  void isFirstTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('maxLevel')) {
      pref.setInt('maxLevel', 1);
    }
  }
}
