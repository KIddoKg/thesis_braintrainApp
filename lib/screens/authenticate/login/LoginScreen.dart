import 'package:flutter/material.dart';

import '../shared/size_config.dart';
import 'components/Body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Đăng Nhập"),
          centerTitle: true,

        ),
        body: const Body(),
      ),
    );
  }
}
