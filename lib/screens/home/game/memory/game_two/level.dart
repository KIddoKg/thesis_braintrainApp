import 'package:flutter/material.dart';

import '../Memory_Screen.dart';
import 'memory_two_screen.dart';

// ! Level Screen Memory 2
class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  String _dataLevel1 = "Easy";
  String _dataLevel2 = "Medium";
  String _dataLevel3 = "Difficult";

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0x00000000),
        body: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                  Color(0xff0846a3),
                  Color(0xff387ee8),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon back
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      //print("Back Here");
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>const MemoryScreen()));
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    iconSize: 30,
                  ),
                ],
              ),
              const Text(
                "CẤP ĐỘ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 35,
                ),
              ),
              Image.asset(
                "assets/memory1/memory_two.png",
                height: screen_height / 3,
                width: screen_width,
              ),
              SizedBox(
                height: screen_height / 30,
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // !Dễ
                      CustomButton(
                        title: "Dễ",
                        data: _dataLevel1,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MemoryTwoScreen(
                                levelValue: _dataLevel1,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: screen_height / 30,
                      ),
                      // !Trung Bình
                      CustomButton(
                        title: "Trung Bình",
                        data: _dataLevel2,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MemoryTwoScreen(
                                levelValue: _dataLevel2,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: screen_height / 30,
                      ),
                      // !Khó
                      CustomButton(
                        title: "Khó",
                        data: _dataLevel3,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MemoryTwoScreen(
                                levelValue: _dataLevel3,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final String data;
  final VoidCallback? onPressed;

  const CustomButton({
    Key? key,
    required this.title,
    required this.data,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:const Color(0xff387ee8).withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: const BorderSide(color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        // minimumSize: MediaQuery.of(context).size,
        minimumSize:const Size(double.infinity, 50),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
    );
  }
}
