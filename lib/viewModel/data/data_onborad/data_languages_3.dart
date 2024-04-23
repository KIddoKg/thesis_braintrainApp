import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:get/get.dart';

import 'package:brain_train_app/models/model_onboarding.dart';
import 'package:brain_train_app/models/on_boarding.dart';

class OnBoardingLanguageThree extends GetxController {
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExZTYzNzE5MjgxZjU3NjAzNTA5MjU1MDBkNGY1Mjg0YmM2OTk2ZDdkYiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/8tY2befV4Ma2Umcx93/giphy.gif",
        title: "Đầu tiên nhấn vào ô trống 'Nhập từ",
        subTitle: "bàn phím sẽ hiện lên ngày sau đó",
        counterText: "1/3",
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExOWJjZmUxMmZjNDE3ZTljNWQwMGVjNWMxMWRkMTI2ODBhN2ZjMDE2YSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/NO9oE4daNRPTLsoUYj/giphy.gif",
        title: "Tiếp theo nhập từ vào ô trống",
        subTitle: "để tạo thành từ có nghĩa",
        counterText: "2/3",
        bgColor: Color(0xfffddcdf),
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExZjFmZDc2NDA5ODg2MzY4NmY5ZWFhOTZiMmEyZjRkMjg0MGFmMTdhNSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/Smb5rajNBR6CHuqGJ8/giphy.gif",
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
