import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../services/services.dart';
import '../Memory_Screen.dart';
import 'memory_three_screen.dart';

class LevelM3Screen extends StatefulWidget {
  const LevelM3Screen({super.key});

  @override
  State<LevelM3Screen> createState() => _LevelM3ScreenState();
}

class _LevelM3ScreenState extends State<LevelM3Screen> {
  final String _dataLevel1 = "Easy";
  final String _dataLevel2 = "Medium";
  final String _dataLevel3 = "Difficult";

  bool _isButtonEnabledM = false;
  bool _isButtonEnabledD = false;

  // ! Get state of button Medium
  Future<void> _loadButtonStateM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isButtonEnabledM = prefs.getBool("isEnableM") ?? false;
    });
  }

  // ! Get state of button Difficult
  Future<void> _loadButtonStateD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isButtonEnabledD = prefs.getBool("isEnableD") ?? false;
    });
  }

  setLevel() async {
    var res = await Services.instance.setContext(context).getDataPlayGameUser("NEW_PICTURE");
    if (res!.isSuccess) {
      if(res.data['level'] == 2){
        _isButtonEnabledM = true;
      }else if (res.data['level'] == 3) {
        _isButtonEnabledM = true;
        _isButtonEnabledD = true;
     }
    } else {
      _isButtonEnabledM = false;
      _isButtonEnabledD = false;
    }
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadButtonStateM();
    _loadButtonStateD();
    setLevel();
  }

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
                  Color(0xfff2bd05),
                  Color(0xffe6c657),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // *Icon back
                Row(
                  children: [
                    IconButton(
                      onPressed: () {

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
                  "assets/memory1/memory_three.png",
                  height: screen_height / 3,
                  width: screen_width,
                ),
                    
                const Text(
                  'Chọn độ khó',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'Độ khó sẽ được mở khóa khi bạn hoàn thành 10 màn chơi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Center(
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
                              builder: (context) => MemoryThreeScreen(
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
                        onPressed: _isButtonEnabledM
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MemoryThreeScreen(
                                      levelValue: _dataLevel2,
                                    ),
                                  ),
                                );
                              }
                            : null,
                      ),
                      SizedBox(
                        height: screen_height / 30,
                      ),
                      // !Khó
                      CustomButton(
                        title: "Khó",
                        data: _dataLevel3,
                        onPressed: _isButtonEnabledD
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MemoryThreeScreen(
                                      levelValue: _dataLevel3,
                                    ),
                                  ),
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                )
              ],
            ),
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
          backgroundColor: const Color(0xffe6c657).withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: const BorderSide(color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        // minimumSize: MediaQuery.of(context).size,
        minimumSize: const Size(double.infinity, 60),
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
