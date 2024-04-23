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
        image: "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExNzAxYTk5ZGY1ZGU5NjM1ODQ3YzhmNmFlOTM4MmJkNDgwZmM0YzEyOCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/PMxwjeqrY45NJZlWZY/giphy.gif",
        title: "Chứ ý ghi nhớ những tấm hình vì sau vài giây ",
        subTitle: "bạn phải chọn hình đã biến mất trong những hình đó",
        counterText: "1/2",
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExYTU0M2VmNGM0NWQwMjc5ODVjZDNkODRmMTc1ZmQxZTEzMmYzZGI4NSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/W7VH11q5OrLnE8QSUG/giphy.gif",
        title: "Chọn đáp án xong bạn nhấn kiểm tra để xem kết quả",
        subTitle: "Bạn có 10 lượt chơi ở đây",
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
