import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quickalert/quickalert.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../viewModel/data/data_onborad/data_math_1.dart';
import '../../../../../shared/app_styles.dart';
import '../../../../onboarding/explanation.dart';
import '../../../../onboarding/home.dart';
import '../Math_Screen.dart';
import '../controllers/math1_controller.dart';
import 'components/g1_body.dart';
import 'g1_globals.dart';

class Game1Screen extends StatelessWidget {
  const Game1Screen({super.key});

  @override
  Widget build(BuildContext context) {
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
            IconButton(
              onPressed: () {
                _navigateAndDisplaySelection(context);
                Globals.stopTimer = true;
              },
              icon: const Icon(
                Icons.question_mark_rounded,
              ),
              color: Colors.white,
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/math/universe.png'),
              fit: BoxFit.cover,
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
          context, MaterialPageRoute(builder: (context) => const MathScreen()));
      Navigator.popUntil(context, ModalRoute.withName('/mathScreen'));
      Get.delete<Math1Controller>();
      // to cancel timer to prevent congrat screen from popping up
      Globals.cancelTimer = true;
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
    title: "Trò chơi Mua sắm",
    localImageSrc: "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExZDI5MDdjZjk3ZTlhMGJjNTQ1ZTcwNjkyM2RiMGEyZmJkZGJmNDliZiZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/Fmfg63rfIyP8OqzJvz/giphy.gif",
    backgroundColor: AppColors.primaryColor,
  ),
  ExplanationData(
    description: "Tiếp theo nhập từ với từ đầu tiên cho trước, chú ý không gõ lại từ đầu tiên",
    title: "Trò chơi Mua sắm",
    localImageSrc: "https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExNjBhM2RiMTRlYWJiMGIwNTU1NDhiNmM3YmRlNTY5NzZkMmUxZjMxZSZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/sD1V8yHGMsPkMVSVoT/giphy.gif",
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
