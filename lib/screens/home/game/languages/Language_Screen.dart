import 'package:flutter/material.dart';
// import 'package:animator/animator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brain_train_app/models/user_model.dart';
import '../../../../routes/app_route.dart';
import '../../../../shared/app_styles.dart';
import '../../home_page/stack_custom.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    int cout = 0;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          const back = true;
          return back;
        },
        child: Container(
          width: double.infinity,
          height: 900,
          color: AppColors.primaryColor,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
               Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primaryColorYellow,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {

                            },
                            child:const CircleAvatar(
                              radius: 21,
                              backgroundColor:   Color(0xff37EBBC),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(
                                  "assets/avatar.png",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${UserModel.instance.name}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     Navigator.of(context).pushNamed(RouteGenerator.setting);
                    //   },
                    //   icon: const Icon(Icons.settings),
                    //   color: Colors.black,
                    // )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'CHỌN TRÒ CHƠI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black, fontSize: 25, letterSpacing: 1),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // SizedBox(
              //   width: double.infinity,
              //   height: size.height * 0.03,
              //   child: Animator<double>(
              //     duration: const Duration(milliseconds: 500),
              //     cycles: 0,
              //     curve: Curves.easeInOut,
              //     tween: Tween<double>(begin: 15.0, end: 20.0),
              //     builder: (context, animatorState, child) => Icon(
              //       Icons.keyboard_arrow_down,
              //       size: animatorState.value * 3.5,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
              CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 8),
                    height: size.height * 0.6,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    padEnds: true,
                    viewportFraction: .7,
                  ),
                  items: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RouteGenerator.gameLetter);
                          cout = 1;
                        },
                        child: const CustomStack(
                          image: 'assets/LogoGame/game_languages1.png',
                          icon: 'assets/LogoGame/game_languages1.png',
                          text1: 'Tìm từ bắt đầu với',
                          text2: 'Hoàn thành từ với chữ đã cho',
                          padding_left: 5,
                          padding_top: 45,
                          padding: 0,
                          color: Color(0xff2D2D2D),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteGenerator.gameWord);
                      },
                      child: const CustomStack(
                        image: 'assets/LogoGame/game_languages2.png',
                        icon: 'assets/LogoGame/game_languages2.png',
                        text1: 'Tìm từ tiếp theo',
                        text2: 'Hoàn thành một cụm từ với từ đã cho',
                        padding_left: 5,
                        padding_top: 45,
                        padding: 0,
                        color: Color(0xff444444),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RouteGenerator.gameConj);
                      },
                      child: const CustomStack(
                        image: 'assets/LogoGame/game_languages3.png',
                        icon: 'assets/LogoGame/game_languages3.png',
                        text1: 'Nối Từ',
                        text2: 'Từ sau nối từ trước',
                        padding_left: 5,
                        padding_top: 45,
                        padding: 0,
                        color: Color(0xff444444),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.of(context)
                            .pushNamed(RouteGenerator.gameSort);
                      },
                      child: const CustomStack(
                        image: 'assets/LogoGame/game_languages4.png',
                        icon: 'assets/LogoGame/game_languages4.png',
                        text1: 'Sắp xếp từ',
                        text2: 'Sắp xếp những chữ cái thành từ có nghĩa',
                        padding_left: 7,
                        padding_top: 80,
                        padding: 28,
                        color: Color(0xff444444),
                      ),
                    ),
                  ]),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () async {
                    const back = true;
                    if (back == true) {
                      Navigator.pop(context, back);
                    }
                  },
                  icon: const Icon(
                    Icons.home_rounded,
                    size: 40,
                  ),
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
