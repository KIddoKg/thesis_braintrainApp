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
        image: "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExZDI5MDdjZjk3ZTlhMGJjNTQ1ZTcwNjkyM2RiMGEyZmJkZGJmNDliZiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/Fmfg63rfIyP8OqzJvz/giphy.gif",
        title: "Đầu tiên nhấn vào ô trống 'Nhập từ ở đây'",
        subTitle: "bàn phím sẽ hiện lên ngày sau đó",
        counterText: "1/2",
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExNjBhM2RiMTRlYWJiMGIwNTU1NDhiNmM3YmRlNTY5NzZkMmUxZjMxZSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/sD1V8yHGMsPkMVSVoT/giphy.gif",
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
