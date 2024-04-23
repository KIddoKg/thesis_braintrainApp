import 'package:flutter/material.dart';

import 'constants.dart';
import 'size_config.dart';

InputDecoration buildInputFieldDecoration(
    String labelText, String hintText, IconData icon) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 42,
      vertical: 20,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: kTextColor),
      gapPadding: 10,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: kPrimaryColor),
      gapPadding: 10,
    ),
    suffixIcon: Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(18),
        getProportionateScreenWidth(18),
        getProportionateScreenWidth(18),
      ),
      child: Icon(
        icon,
        color: kTextColor,
        opticalSize: getProportionateScreenWidth(20),
      ),
    ),
  );
}

InputDecoration passwordFieldDecoration(String labelText, String hintText,
    bool isPasswordVissible, VoidCallback togglePasswordVisibility) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 42,
      vertical: 20,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: kTextColor),
      gapPadding: 10,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: kPrimaryColor),
      gapPadding: 10,
    ),
    suffixIcon: Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(18),
        getProportionateScreenWidth(18),
        getProportionateScreenWidth(18),
      ),
      child: GestureDetector(
        onTap: togglePasswordVisibility,
        child: Icon(
          isPasswordVissible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: kTextColor,
          opticalSize: getProportionateScreenWidth(20),
        ),
      ),
    ),
  );
}
