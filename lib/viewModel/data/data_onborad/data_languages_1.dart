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
        image: "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExYzYzYjcyMzY0YTEzYTg4MGEyMGUwZmNmNmUzYjE2N2U3M2NhNzAyNCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/ry4d0GdvFaHjmdZRHK/giphy.gif",
        title: "Đầu tiên nhấn vào ô trống 'Nhập từ ở đây'",
        subTitle: "bàn phím sẽ hiện lên ngày sau đó",
        counterText: "1/3",
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExZTk3YjBiODEzMjc1NWRlYWM2MGRhY2Q0Nzk5MThlMDZmZDgyZGEyNiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/RXQozJSYhRxnLA50Fp/giphy.gif",
        title: "Tiếp theo nhập từ với từ đầu tiên cho trước",
        subTitle: "Chú ý không gõ lại từ đầu tiên",
        counterText: "2/3",
        bgColor: Color(0xfffddcdf),
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExMmRiNWE2NDE4YmNhMjg0ZjAzYThhOTRmNDBjZTg4ZDNlYjcyN2Y4NCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/rTqOJidmIWxWJXuR7o/giphy.gif",
        title: "Sau khi đã nhập xong nhấn nút Gửi",
        subTitle: "và đợi Thông báo cộng điểm",
        counterText: "3/3",
        bgColor: Color(0xffffdcbd),
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
