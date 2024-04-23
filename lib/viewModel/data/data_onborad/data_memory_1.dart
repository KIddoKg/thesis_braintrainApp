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
        image: "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExZTMwOGU5NzRmZWQ1NzVmZTcyNzRkNmY1ZWViY2M0YzlhZGE1YTg2NiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/tDNxp8il9rT2ip5Cg5/giphy.gif",
        title: "Sau khi xong đếm ngược 3s, sẽ có một ô khsc màu hiện lên nhiệm vụ của bạn",
        subTitle: "là nhanh chóng ghi nhớ lại và chọn lại đúng vị trí đó",
        counterText: "1/2",
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExMDVjY2MyYjMxZWRhM2Q4N2VhODU5YTc0NzMxZDUxNzllMTNiYjUzNCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/zOuqNA1XQU2ekAL6Aq/giphy.gif",
        title: "Nếu đúng sẽ có dấu tích xanh hiện lên",
        subTitle: "Tùy vào từng cấp dồ bạn chỉ có thể sai tối đa bao nhiêu lần",
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
