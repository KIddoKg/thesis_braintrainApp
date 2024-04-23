import 'package:brain_train_app/screens/authenticate/shared/NoAccountText.dart';
import 'package:brain_train_app/screens/authenticate/shared/size_config.dart';
import 'package:brain_train_app/services/AuthService.dart';
import 'package:brain_train_app/services/AuthStorage.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../routes/app_route.dart';
import '../../../../services/ResultEnum.dart';
import '../../shared/DefaultButton.dart';
import '../../shared/InputFieldDecoration.dart';
import '../../shared/constants.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.08),
            Text(
              "Khôi Phục Mật Khẩu",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Text(
              "Hãy nhập mật khẩu mới của bạn dưới đây \n và đăng nhập bằng mật khẩu mới nhé",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.1),
            const PasswordResetForm(),
            SizedBox(height: SizeConfig.screenHeight * 0.1),
            const NoAccountText(),
          ],
        ),
      ),
    );
  }
}

class PasswordResetForm extends StatefulWidget {
  const PasswordResetForm({super.key});

  @override
  State<PasswordResetForm> createState() => _PasswordResetFormState();
}

class _PasswordResetFormState extends State<PasswordResetForm> {
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  AuthStorage authStorage = AuthStorage();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  String password = "";
  String confirmPassword = "";

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void toggleConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //! new password
          TextFormField(
            obscureText: !isPasswordVisible,
            onSaved: (newValue) => password = newValue!,
            onChanged: (value) => password = value,
            validator: (value) {
              if (value!.isEmpty) {
                return kPassNullError;
              } else if (value.length < 4) {
                return kShortPassError;
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: passwordFieldDecoration(
              "Mật khẩu",
              "Nhập mật khẩu",
              isPasswordVisible,
              togglePasswordVisibility,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          //! confirm new password
          TextFormField(
            obscureText: !isConfirmPasswordVisible,
            onSaved: (newValue) => confirmPassword = newValue!,
            onChanged: (value) => confirmPassword = value,
            validator: (value) {
              if (value!.isEmpty) {
                return kPassNullError;
              } else if (password != value) {
                return kMatchPassError;
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: passwordFieldDecoration(
              "Xác nhận mật khẩu",
              "Nhập lại mật khẩu",
              isConfirmPasswordVisible,
              toggleConfirmPasswordVisibility,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Tiếp tục",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                String phone = await authStorage.getPhone();

                var response = await authService.resetPassword(phone, password);
                if (response == Result.success) {
                  Navigator.pushNamed(context, RouteGenerator.login);
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
      title: "Khôi Phục Thất Bại",
      widget: Text(
        "Xin hãy điền lại mật khẩu...",
        style: TextStyle(
          fontSize: getProportionateScreenWidth(16),
        ),
      ),
      confirmBtnText: "OK",
      confirmBtnColor: Colors.blue.shade700,
    );
  }
}
