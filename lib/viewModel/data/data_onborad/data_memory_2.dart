import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:get/get.dart';

import 'package:brain_train_app/models/model_onboarding.dart';
import 'package:brain_train_app/models/on_boarding.dart';

class OnBoardingController extends GetxController {
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExZGE3Y2IyYTNkNDdmMWI2MDU4OTBhNzFhMTY1ZGMyZmU0Zjc5Y2Y4YSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/pgjeGFx0DzMxnJhhT7/giphy.gif",
        title: "Bắt đầu game hãy chọn một hình bất kì và ghi nhớ nó",
        subTitle: "ở những lượt tiếp theo bạn pahir chọn những hình mà bạn đã không chọn trước đó",
        counterText: "1/2",
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExYTlhN2IzYWJkY2MyOGEwMmQ3N2JlZjRmNjZlMzA0OWVkN2U1YjAyZCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/iFAMN8wbUzGt5XmBh2/giphy.gif",
        title: "Nếu chọn sai bạn sẽ kết thúc lượt một",
        subTitle: "Lượt 2 sẽ bắt đầu ngay sau đó",
        counterText: "2/2",
        bgColor: Color(0xfffddcdf),
      ),
    ),

  ];

  skip() => controller.jumpToPage(page: 2);
  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
  }

  onPageChangedCallback(int activePageIndex) =>
      currentPage.value = activePageIndex;
}
