import 'package:flutter/material.dart';

import '../../../shared/share_widgets.dart';
import 'constants.dart';
import 'size_config.dart';

class DefaultButton extends StatelessWidget {
   DefaultButton({
    super.key,
    required this.text,
    required this.press,
     this.disable = false,
  });

  final String text;
  final Function() press;
  bool disable = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(67),
      child: TextButton(
        onPressed: disable ? null: press,
        style: ButtonStyle(
          backgroundColor: !disable ? MaterialStateProperty.all(kPrimaryColor): MaterialStateProperty.all(Colors.grey),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
            (_) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child:!disable? Text(
          text,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(20),
            color: Colors.white,
          ),
        ): LoadingFragment(noText: true,),
      ),
    );
  }
}
