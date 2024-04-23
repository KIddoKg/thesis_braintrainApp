import 'package:brain_train_app/screens/authenticate/otp/components/TimerController.dart';
import 'package:brain_train_app/services/AuthService.dart';
import 'package:brain_train_app/services/AuthStorage.dart';
import 'package:brain_train_app/services/ResultEnum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/services.dart';
import '../../shared/constants.dart';
import '../../shared/size_config.dart';
import 'OtpForm.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TimerController timerController = Get.put(TimerController());

  @override
  void dispose() {
    timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    AuthStorage authStorage = AuthStorage();

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.07),
              Text(
                "Xác Nhận OTP",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                "Mã OTP đã được gửi đến điện thoại của bạn",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(16),
                ),
              ),
              //! timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Mã sẽ hết hiệu lực trong ",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(16),
                    ),
                  ),
                  Obx(
                    () => Text(
                      timerController.time.value,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: getProportionateScreenWidth(16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.15),
              const OtpForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? phone = await prefs.getString("phone");
                  var res = await Services.instance.resendOTPUser(phone!);
                  if (!res!.isSuccess) {
                    showFailAlert(context: context);
                  } else {
                    showSuccessAlert(context: context);
                  }
                },
                child: const Text(
                  "Gửi lại mã OTP",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showFailAlert({required context}) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: "Gửi Mã Thất Bại",
      widget: Text(
        "Xin hãy gửi lại mã OTP...",
        style: TextStyle(
          fontSize: getProportionateScreenWidth(16),
        ),
      ),
      confirmBtnText: "OK",
      confirmBtnColor: Colors.blue.shade700,
    );
  }

  showSuccessAlert({required context}) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Gửi Mã Thành Công",
      widget: Text(
        "Xin hãy kiểm tra điện thoại và điền mã OTP mới nhất...",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: getProportionateScreenWidth(16),
        ),
      ),
      confirmBtnText: "OK",
      confirmBtnColor: Colors.blue.shade700,
    );
  }
}
