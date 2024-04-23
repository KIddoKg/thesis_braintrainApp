import 'package:flutter/material.dart';

import '../shared/size_config.dart';
import 'components/Body.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return WillPopScope(
        onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Đăng Ký"),
          centerTitle: true,
          leading: IconButton(
            icon:const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Body(),
      ),
    );
  }
}
