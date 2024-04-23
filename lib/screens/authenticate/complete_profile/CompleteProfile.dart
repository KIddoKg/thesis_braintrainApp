import 'package:brain_train_app/screens/authenticate/shared/size_config.dart';
import 'package:flutter/material.dart';

import 'components/Body.dart';

class CompleteProfile extends StatelessWidget {
  const CompleteProfile({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Đăng Ký"),
          centerTitle: true,
        ),
        body: const Body(),
      ),
    );
  }
}
