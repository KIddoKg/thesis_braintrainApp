import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

import '../../shared/size_config.dart';

class TimerController extends GetxController {
  Timer? _timer;
  int remainingSeconds = 1;
  final time = '05:00'.obs;

  @override
  void onReady() {
    _startTimer(299);
    super.onReady();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  void dispose() {
    super.dispose();
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainingSeconds = seconds;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
        _showEndingAlert();
      } else {
        int minutes = remainingSeconds ~/ 60;
        int seconds = (remainingSeconds % 60);
        time.value = minutes.toString().padLeft(2, "0") +
            ":" +
            seconds.toString().padLeft(2, "0");
        remainingSeconds--;
      }
    });
  }

  _showEndingAlert() {
    final context = Get.context;

    return QuickAlert.show(
      context: context!,
      type: QuickAlertType.info,
      title: "Đã Hết Thời Gian",
      widget: Text(
        "Bấm 'Gửi lại mã OTP' để nhận mã OTP mới...",
        style: TextStyle(
          fontSize: getProportionateScreenWidth(16),
        ),
      ),
      confirmBtnText: "OK",
      confirmBtnColor: Colors.blue.shade700,
      cancelBtnText: "Hủy",
      showCancelBtn: true,
      onCancelBtnTap: () {
        Navigator.popUntil(context, ModalRoute.withName('/signup'));
      },
    );
  }
}
