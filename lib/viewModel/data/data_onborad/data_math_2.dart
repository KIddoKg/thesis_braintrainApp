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
        image: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExNDhlMTVkYThjYjdmZWQ1MWVmMDk3NTJhZjUwMDE4NzA3MDMwNGUzOSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/yScgEqIS08uz6AevMt/giphy.gif",
        title: "Đầu tiên nhấn vào ô trống 'Nhập từ ở đây'",
        subTitle: "bàn phím sẽ hiện lên ngày sau đó",
        counterText: "1/2",
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExODJhZjA4NzAwYjQwN2M1M2ZmY2FhMzFlNGRhY2M5NzNkNWE0ZjkyNyZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/jF2QvdUwLIiTOu44G9/giphy.gif",
        title: "Tiếp theo nhập từ với từ đầu tiên cho trước",
        subTitle: "Chú ý không gõ lại từ đầu tiên",
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
