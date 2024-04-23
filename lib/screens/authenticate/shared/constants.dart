import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

// form error
const String kPhoneNullError = "Số điện thoại không được để trống";
const String kInvalidPhoneError =
    "Số điện thoại phải bắt đầu bằng 0 \nvà có 10 chữ số";
const String kPassNullError = "Mật khẩu không được để trống";
const String kShortPassError = "Mật khẩu nên có ít nhất 4 kí tự";
const String kMatchPassError = "Mật khẩu không giống nhau";
const String kNameNullError = "Họ tên không được để trống";
const String kDobNullError = "Ngày sinh không được để trống";
