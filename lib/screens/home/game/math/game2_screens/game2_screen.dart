import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quickalert/quickalert.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../viewModel/data/data_onborad/data_math_2.dart';
import '../../../../../shared/app_styles.dart';
import '../../../../onboarding/explanation.dart';
import '../../../../onboarding/home.dart';
import '../controllers/math2_controller.dart';
import 'components/g2_body.dart';
import 'g2_globals.dart';
import 'g2_levels_screen.dart';

class Game2Screen extends StatelessWidget {
  const Game2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    Math2Controller _controller = Get.put(Math2Controller());
    return WillPopScope(
      onWillPop: () async {
        showExitDialog(context);
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: TextButton(
            onPressed: () {
              showExitDialog(context);
            },
            child: Image.asset(
              'assets/math/go-back.png',
              scale: 2.5,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  _navigateAndDisplaySelection(context);
                  Globals.stopTimer = true;
                  _controller.pauseProgressBar();
                },
                icon: const Icon(
                  Icons.question_mark_rounded,
                ),
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/math/g2_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: const Body(),
        ),
      ),
    );
  }
}

void showExitDialog(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.warning,
    title: 'Cảnh báo',
    text: 'Bạn có muốn thoát khỏi trò chơi?',
    textColor: const Color.fromARGB(255, 60, 60, 60),
    confirmBtnText: 'Có',
    confirmBtnColor: const Color.fromARGB(255, 4, 114, 117),
    onConfirmBtnTap: () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Math2LevelScreen()));
      Navigator.pushNamed(context, '/game2MathLevel');
      Get.delete<Math2Controller>();
    },
    confirmBtnTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
    showCancelBtn: true,
    cancelBtnText: 'Không',
    onCancelBtnTap: () {
      Navigator.pop(context);
    },
    cancelBtnTextStyle: const TextStyle(
      color: Colors.grey,
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
  );
}

final List<ExplanationData> data = [
  ExplanationData(
    description: "Đầu tiên nhấn vào ô trống 'Nhập từ ở đây', bàn phím sẽ hiện lên ngay sau đó",
    title: "Trò chơi Tìm tổng",
    localImageSrc: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExNDhlMTVkYThjYjdmZWQ1MWVmMDk3NTJhZjUwMDE4NzA3MDMwNGUzOSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/yScgEqIS08uz6AevMt/giphy.gif",
    backgroundColor: AppColors.primaryColor,
  ),
  ExplanationData(
    description: "Tiếp theo nhập từ với từ đầu tiên cho trước, chú ý không gõ lại từ đầu tiên",
    title: "Trò chơi Tìm tổng",
    localImageSrc: "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExODJhZjA4NzAwYjQwN2M1M2ZmY2FhMzFlNGRhY2M5NzNkNWE0ZjkyNyZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/jF2QvdUwLIiTOu44G9/giphy.gif",
    backgroundColor: AppColors.primaryColor,
  ),
];

Future<void> _navigateAndDisplaySelection(BuildContext context) async {
  // Navigator.push returns a Future that completes after calling
  // Navigator.pop on the Selection Screen.
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => OnBoarding(data: data,)),
  );

  // When a BuildContext is used from a StatefulWidget, the mounted property
  // must be checked after an asynchronous gap.


  if (result != null) {
    bool isTrue = result == "true";

    Globals.stopTimer = isTrue;
    // Now you can use the `isTrue` boolean value
  }
  // After the Selection Screen returns a result, hide any previous snackbars
  // and show the new result.

}
