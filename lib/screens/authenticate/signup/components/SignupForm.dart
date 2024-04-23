import 'package:brain_train_app/routes/app_route.dart';
import 'package:brain_train_app/services/AuthService.dart';
import 'package:brain_train_app/services/ResultEnum.dart';
import 'package:brain_train_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/DefaultButton.dart';
import '../../shared/InputFieldDecoration.dart';
import '../../shared/constants.dart';
import '../../shared/size_config.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  String phone = "";
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
          buildPhoneInputField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordInputField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConfirmPasswordInputField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Tiếp tục",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                var res = await Services.instance.setContext(context).signUpUser(phone, password);
                if (res != null) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString("phone", phone);
                  await prefs.setString("otp", res.data);
                  Navigator.pushNamed(context, RouteGenerator.otp);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPhoneInputField() {
    return TextFormField(
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
    );
  }

  TextFormField buildPasswordInputField() {
    return TextFormField(
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
    );
  }

  TextFormField buildConfirmPasswordInputField() {
    return TextFormField(
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
    );
  }

  showFailAlert({required context}) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: "Đăng Ký Thất Bại",
      widget: Text(
        "Xin hãy điền lại thông tin...",
        style: TextStyle(
          fontSize: getProportionateScreenWidth(16),
        ),
      ),
      confirmBtnText: "OK",
      confirmBtnColor: Colors.blue.shade700,
    );
  }
}
