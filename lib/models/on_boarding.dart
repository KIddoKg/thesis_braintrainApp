import 'package:flutter/material.dart';
import 'model_onboarding.dart';

class OnBoardingPageWidget extends StatelessWidget {
  const OnBoardingPageWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(10),
      color: model.bgColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: NetworkImage(model.image),
              height: size.height * 0.60,
              width: size.width,
            ),
            Column(
              children: [
                Text(
                  model.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  model.subTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            Text(
              model.counterText,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 80.0,
            )
          ],
        ),
      ),
    );
  }
}
