import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:get/get.dart';

import 'package:brain_train_app/models/model_onboarding.dart';
import 'package:brain_train_app/models/on_boarding.dart';

class OnBoardingLanguageTwo extends GetxController {
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExNWYzMzhkOTlmMGEwYWY1NjZjOWQxNTliZjYyNDFjNzNhNzE2ZGFhMyZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/fnGOUWBhwx3FwFnib8/giphy.gif",
        title: "Đầu tiên nhấn vào ô trống 'Nhập từ ở đây'",
        subTitle: "bàn phím sẽ hiện lên ngày sau đó",
        counterText: "1/3",
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExMDQ4ZjNiZWNjMzYxZTU5YzNlOWZjOGFlZTc5YjcwNzAzNWZlNDY1MiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/AJO9MtXviec8ZpmeEi/giphy.gif",
        title: "Tiếp theo nhập từ vào ô",
        subTitle: "để tạo thành từ có nghĩa",
        counterText: "2/3",
        bgColor: Color(0xfffddcdf),
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExODg0ZmRiMzA5OTQ2OTg2M2RiNzMxZGJjYmUzNmY2YjAyNmJiZjQ0MyZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/4OQPcK6w7Q5e2bODPy/giphy.gif",
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
