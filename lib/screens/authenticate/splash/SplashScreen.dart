import 'package:flutter/material.dart';

import 'components/Body.dart';
import '../shared/size_config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return const Scaffold(
      body: Body(),
    );
  }
}
