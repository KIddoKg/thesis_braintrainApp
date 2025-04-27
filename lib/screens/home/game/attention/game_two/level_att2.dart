import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../services/services.dart';
import '../Attention_Screen.dart';
import 'attention_two_new.dart';

class LevelA2Screen extends StatefulWidget {
  const LevelA2Screen({super.key});

  @override
  State<LevelA2Screen> createState() => _LevelA2ScreenState();
}

class _LevelA2ScreenState extends State<LevelA2Screen> {
  final String _dataLevel1 = "Easy";
  final String _dataLevel2 = "Medium";
  final String _dataLevel3 = "Difficult";

  bool _isButtonEnabledM = false;
  bool _isButtonEnabledD = false;

  setLevel() async {
    var res = await Services.instance.setContext(context).getDataPlayGameUser("PAIRING");
    if(res!.data == null){
      return;
    }
    if (res.isSuccess) {
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

  // ! Get state of button Medium
  Future<void> _loadButtonStateM() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isButtonEnabledM = prefs.getBool("isEnableM_att") ?? false;
    });
  }

  // ! Get state of button Difficult
  Future<void> _loadButtonStateD() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isButtonEnabledD = prefs.getBool("isEnableD_att") ?? false;
    });
  }

  @override
  void initState() {
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
        backgroundColor:const Color(0x00000000),
        body: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xff1c0659),
                Color(0xff3c2a70),
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
                                builder: (context) =>const AttentionScreen()));
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
                  "assets/memory1/history.png",
                  height: screen_height / 3,
                  width: screen_width,
                ),
                // SizedBox(
                //   height: screen_height / 30,
                // ),
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
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //! Dễ
                      CustomButton(
                        title: "Dễ",
                        data: _dataLevel1,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AttentionTwoScreen(
                                levelValue: _dataLevel1,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: screen_height / 30,
                      ),
                      //! Trung Bình
                      CustomButton(
                        title: "Trung Bình",
                        data: _dataLevel2,
                        onPressed: _isButtonEnabledM
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AttentionTwoScreen(
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
                      //! Khó
                      CustomButton(
                        title: "Khó",
                        data: _dataLevel3,
                        onPressed: _isButtonEnabledD
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AttentionTwoScreen(
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
        backgroundColor: const Color(0xff3c2a70).withOpacity(0.4),
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
