import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'package:get/get.dart';

import 'package:brain_train_app/models/model_onboarding.dart';
import 'package:brain_train_app/models/on_boarding.dart';

class OnBoardingLanguageFour extends GetxController {
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExN2RjZWY5NTlkNTMzZTg3NDkwMWNhMjI3MDY5ZWVmYzhjMGUzOTY5ZiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/cP2hBBRNjtVSEzXBXt/giphy.gif",
        title: "Nhấn vào các ô chữ bên dưới",
        subTitle: "sau đó chữ sẽ hiện lên các ô ở trên",
        counterText: "1/6",
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExODM3ZDNmZjRmMDM2NTEzZWE0OWM3MjU1NmYzMTI0M2ZhNWEzODVlOCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/wiIkCCZr4I2ApJd6ZT/giphy.gif",
        title: "Nếu ấn sai có thể nhấn vào chữ bên trên",
        subTitle: "để chữ có thể trở về vị trí cũ",
        counterText: "2/6",
        bgColor: Color(0xfffddcdf),
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExNjk3OTU2NjA1MmNhZTRhYWJmOTNjOGVjODgwYjg5YWUyMDgyNjA4MyZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/hsKxF3mYkU5WI5B1mQ/giphy.gif",
        title: "Sau khi lấp đầy ô chữ,nếu sai các ô sẽ hiện màu đỏ",
        subTitle: "Có thể bấm vào biểu tượng 2 mũi tên để rest nhanh",
        counterText: "3/6",
        bgColor: Color(0xffffdcbd),
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExMWE3MmZlMjEwZmJiN2QzYzdjN2Q5MjVmMjZmOTkwNTYyOWMwMmI4ZSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/aM4Ry9mjEpqBTAArY3/giphy.gif",
        title: "Nếu quá khó, có thể nhấn vào biểu tượng bóng đèn",
        subTitle: "các chữ cái được gợi ý sẽ có màu xanh",
        counterText: "4/6",
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExYTBkOTU0OTdjNWY0MTE1YWMyZTBhOWIwMDQwMDkxYjAyODkyMmFlMiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/b8HWCPbXJgNOKvzbtk/giphy.gif",
        title: "Sau khi hoàn thành đúng chữ cái",
        subTitle: "các ô sẽ hiện màu xanh và tự sang màn",
        counterText: "5/6",
        bgColor: Color(0xfffddcdf),
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: "https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExOTYzOWQyN2ZlYWFjMWQyMTZhMzc2YTRjOWU0Y2RkOGU2NTZmNDk3ZSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/V4JeDOpRXt6ZKhkYGN/giphy.gif",
        title: "Nếu muốn chơi lại các câu trước",
        subTitle: "có thể bấm vào nút '<' để trở lại câu trước",
        counterText: "6/6",
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
