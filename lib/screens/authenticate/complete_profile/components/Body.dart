import 'package:flutter/material.dart';

import '../../shared/size_config.dart';
import 'CompleteProfileForm.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.07),
              Text(
                "Hoàn Tất Đăng Ký",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                "Hãy nhập thêm những thông tin dưới đây \nđể tạo tài khoản mới nhé",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(16),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.07),
              const CompleteProfileForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              const Text(
                "Bằng cách tiếp tục sử dụng, bạn đã đồng ý với \nĐiều khoản và Điều kiện sử dụng của \nphần mềm BrainTrain",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
