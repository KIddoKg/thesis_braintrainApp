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
        image: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExZWNiNjNiMzdlMGY0MjljNDI5ZjNlZjI4MDMwN2U4M2QxNWNkNjI4YyZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/mpmaerMNMArM7cE4ON/giphy.gif",
        title: "Hãy nhanh tay tìm kiếm 2 hình giống nhau",
        subTitle: "nếu đúng sẽ có một dấu tích màu xanh hiện lên",
        counterText: "1/2",
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExMTVjOTRmNjgyZmQxN2VhZjJiMmQ2NzRjZGE1YTExOTlkNGRmYjI3ZCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/jopadonYASybcYHZEz/giphy.gif",
        title: "Còn nếu chọn sai thì sẽ game sẽ tự bỏ cái bạn đã chọn ban đầu",
        subTitle: "",
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
