import 'dart:io';

import 'package:brain_train_app/helper/formater.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'size_configs.dart';

const Color kPrimaryColor = Color(0xffFC9D45);
const Color kSecondaryColor = Color(0xff573353);
const Color kScaffoldBackground = Color(0xffFFF3E9);

class AppColors {
  AppColors._();

  static const Color background = Color(0XFFF1F4FA);
  static const Color primary = Color(0XFF3A36DB);
  static const Color secondary = Color(0XFFFF69B4);
  static const Color accent = Color(0XFF03A89E);
  static const Color text = Color(0XFF06152B);
  static const Color textLight = Color(0XFF99B2C6);
  static const Color neutral = Color(0XFFFFFFFF);
  static Color primaryColor = '#B5CB99'.toColor();
  static Color primaryColorWord = '#B5CB99'.toColor();
  static Color primaryColorPink = '#B2533E'.toColor();
  static Color primaryColorYellowW= '#F5EEC8'.toColor();
  static Color primaryColorBlack= '#555843'.toColor();
  static Color primaryColorGreen = '#186F65'.toColor();
  static Color primaryColorYellow = '#FCE09B'.toColor();
  static Color primaryColorGreenPer = '#A7D397'.toColor();
  static Color primaryColorGrey = '#D0D4CA'.toColor();
  // static Color primaryColor = '#025ca6'.toColor();
  static const Color bgButton = Color.fromRGBO(	209, 209, 209, 1.0);


  static double? sizeUI;
  static double? bottomNav;
  static double? bottomArea;

  static void init() {
    if (Platform.isIOS) {
      sizeUI = 255;
      bottomArea = 40;
      bottomNav = 0;
    } else if (Platform.isAndroid) {
      sizeUI = 260;
      bottomNav = 18;
      bottomArea = 0;
    }
  }
// static const Color bgButton = Color.fromRGBO(	204, 204, 204, 1.0);
}
Future<String> getDeviceType() async {
  String deviceType = "Unknown";
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isIOS) {
    try {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      if (iosInfo.model.contains('iPad')) {
        deviceType = "iPad";
      } else if (iosInfo.model.contains('iPhone')) {
        deviceType = "iPhone";
      }
    } catch (e) {
      print("Error getting iOS device information: $e");
    }
  }

  return deviceType;
}
final kTitle = TextStyle(
  fontSize: SizeConfig.blockSizeH! * 7,
  color: kSecondaryColor,
);

final kTitle2 = TextStyle(
  fontSize: SizeConfig.blockSizeH! * 6,
  color: kSecondaryColor,
);

final kBodyText1 = TextStyle(
  color: kSecondaryColor,
  fontSize: SizeConfig.blockSizeH! * 4.5,
  fontWeight: FontWeight.bold,
);

final kBodyText2 = TextStyle(
  color: kSecondaryColor,
  fontSize: SizeConfig.blockSizeH! * 4,
  fontWeight: FontWeight.bold,
);

final kBodyText3 = TextStyle(
    color: kSecondaryColor,
    fontSize: SizeConfig.blockSizeH! * 3.8,
    fontWeight: FontWeight.normal);

final kInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: BorderSide.none,
);

final kInputHintStyle = kBodyText2.copyWith(
  fontWeight: FontWeight.normal,
  color: kSecondaryColor.withOpacity(0.5),
);
