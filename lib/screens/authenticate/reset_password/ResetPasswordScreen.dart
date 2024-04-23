import 'package:flutter/material.dart';

import '../shared/size_config.dart';
import 'components/Body.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title:const  Text("Khôi Phục Mật Khẩu"),
        centerTitle: true,

      ),
      body: const Body(),
    );
  }
}
