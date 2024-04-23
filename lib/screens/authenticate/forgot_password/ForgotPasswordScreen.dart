import 'package:flutter/material.dart';

import '../shared/size_config.dart';
import 'components/Body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quên Mật Khẩu"),
        centerTitle: true,

      ),
      body: const Body(),
    );
  }
}
