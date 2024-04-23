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
        image: "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExOTU5OWVlMDljNWQzODE2YjViZGY4YjMwOWQ1MzZmNDZmNzk2MjcxYSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/UPF0adMulZIJUxZK8w/giphy.gif",
        title: "Nhấn vào ô sẵn sàng để bắt đầu game nhiệm vụ của bạn là\nbắt những chú cá mập lại ",
        subTitle: "bắng cách nhập vào những con tuyền nếu trong phạm vi thuyền sẽ phóng ra lưới",
        counterText: "1/2",
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExNjc4ZGUxZjNiNGE2NmMwOGIxYmIwYTQ2YmM3ODJkY2UzNjhjZmNlZSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/HK2oPQC7Da0JYSSMkj/giphy.gif",
        title: "Nếu bạn để cá mập chạm vào thuyền thanh máu của thuyền sẽ bị giảm ",
        subTitle: "đi giảm đến một lượng nhất định bạn sẽ không thể vượt qua màn mới",
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
