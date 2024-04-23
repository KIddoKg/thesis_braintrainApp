import 'package:flutter/material.dart';

import '../../shared/NoAccountText.dart';
import '../../shared/size_config.dart';
import 'LoginForm.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Text(
                  "Chào Mừng Bạn",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                Text(
                  "Đăng nhập bằng số điện thoại \nvà mật khẩu của bạn",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                const LoginForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.1),
                const NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
