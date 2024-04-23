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
        image: 'https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExMTQ3ZTY5MTFmOWMxYmQ5OTE3MTBmMzNiNjVlZmE2MTZiMTY3ZGNjZCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/eDHuSjwO6a0sqaqu5A/giphy.gif',
        title:
            "Game sẽ cho bạn một bức ảnh bạn phải\n tìm đồ vật theo yêu cầu của game",
        subTitle: "hãy tinh mặt và tìm kiếm bạn chỉ có 60s cho 1 bức ảnh",
        counterText: "1/2",
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExMmMwNDJhMTQzOWFmMzNjZGU0OTMwY2ZiODNmNmRkNjkwZmY4YjEyZCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/Rhn1uVvix3MaCSr9jG/giphy.gif",
        title: "Nếu bạn trả lời đúng liên tiếp trên 3 bức ảnh",
        subTitle: "Nó sẽ được lưu trong biểu tượng hình thẻ khóa",
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
