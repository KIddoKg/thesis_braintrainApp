import 'package:brain_train_app/routes/app_route.dart';
import 'package:brain_train_app/services/AuthService.dart';
import 'package:brain_train_app/services/AuthStorage.dart';
import 'package:brain_train_app/services/ResultEnum.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import '../../shared/DefaultButton.dart';
import '../../shared/InputFieldDecoration.dart';
import '../../shared/NoAccountText.dart';
import '../../shared/constants.dart';
import '../../shared/size_config.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              Text(
                "Quên Mật Khẩu",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                "Hãy nhập số điện thoại của bạn \nvà chúng tôi sẽ gửi một mã OTP cho bạn",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(16),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              const PassForgotForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              const NoAccountText(),
            ],
          ),
        ),
      ),
    );
  }
}

class PassForgotForm extends StatefulWidget {
  const PassForgotForm({super.key});

  @override
  State<PassForgotForm> createState() => _PassForgotFormState();
}

class _PassForgotFormState extends State<PassForgotForm> {
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  AuthStorage authStorage = AuthStorage();

  String phone = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => phone = newValue!,
            validator: (value) {
              if (value!.isEmpty) {
                return kPhoneNullError;
              } else if (!(value.startsWith("0") && value.length == 10)) {
                return kInvalidPhoneError;
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: buildInputFieldDecoration(
              "Số điện thoại",
              "Nhập số điện thoại",
              Icons.phone,
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.12),
          DefaultButton(
            text: "Tiếp tục",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                var response = await authService.resendOtp(phone);

                // if phone exists, save phone number -> navigate to OTP screen
                if (response == Result.success) {
                  authStorage.setPhone(phone);
                  Navigator.pushNamed(context, RouteGenerator.otp);
                } else {
                  showFailAlert(context: context);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  showFailAlert({required context}) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: "Xảy Ra Lỗi",
      widget: Text(
        "Xin hãy nhập lại số điện thoại...",
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
