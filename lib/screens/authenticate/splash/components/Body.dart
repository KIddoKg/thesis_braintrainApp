import 'package:brain_train_app/routes/app_route.dart';
import 'package:flutter/material.dart';

import '../../shared/size_config.dart';
import '../../shared/DefaultButton.dart';
import 'SplashContent.dart';
import '../../shared/constants.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Chào mừng bạn đến với ứng dụng \nBrainTrain!",
      "image": "assets/LogoGame/splash-1.png"
    },
    {
      "text":
          "Rèn luyện nhận thức mỗi ngày \nqua các trò chơi \nTrí nhớ, Tập trung, Ngôn ngữ, Toán học",
      "image": "assets/LogoGame/splash-2.png"
    },
    {
      "text":
          "Hãy dành 15 - 30 phút mỗi ngày \nđể cải thiện các chức năng nhận thức \nvà chất lượng cuộc sống hàng ngày nhé!",
      "image": "assets/LogoGame/splash-3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  text: splashData[index]["text"]!,
                  image: splashData[index]["image"]!,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: Column(
                  children: [
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    const  Spacer(flex: 3),
                    DefaultButton(
                      text: "Tiếp tục",
                      press: () {
                        Navigator.pushNamed(context, RouteGenerator.login);
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor :const  Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
