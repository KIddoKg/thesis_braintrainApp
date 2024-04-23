import 'package:brain_train_app/services/AuthService.dart';
import 'package:brain_train_app/services/AuthStorage.dart';
import 'package:brain_train_app/services/ResultEnum.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/services.dart';
import '../../shared/DefaultButton.dart';
import '../../shared/constants.dart';
import '../../shared/size_config.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  AuthStorage authStorage = AuthStorage();

  late String pin1;
  late String pin2;
  late String pin3;
  late String pin4;

  String otpNe ="";

  late FocusNode pin2FocusNode;
  late FocusNode pin3FocusNode;
  late FocusNode pin4FocusNode;

  @override
  void initState() {
    super.initState();
    getPin();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    super.dispose();
  }

  Future<void> getPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    otpNe = await prefs.getString("otp") ?? "";
    if (otpNe.length == 4) {
       pin1 = otpNe[0];
       pin2 = otpNe[1];
       pin3 = otpNe[2];
       pin4 = otpNe[3];
       print("Input string must be exactly 4 characters long.$pin3");
    } else {
      print("Input string must be exactly 4 characters long.");
    }
    setState(() {

    });
  }

  void nextField({required String value, required FocusNode focusNode}) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //! pin 1
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  autofocus: true,
                  initialValue: pin1,
                  onSaved: (newValue) => pin1 = newValue!,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenWidth(15),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: kTextColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: kPrimaryColor),
                    ),
                  ),
                  onChanged: (value) {
                    nextField(value: value, focusNode: pin2FocusNode);
                  },
                ),
              ),
              //! pin 2
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  initialValue: pin2,
                  focusNode: pin2FocusNode,
                  onSaved: (newValue) => pin2 = newValue!,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenWidth(15),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: kTextColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: kPrimaryColor),
                    ),
                  ),
                  onChanged: (value) {
                    nextField(value: value, focusNode: pin3FocusNode);
                  },
                ),
              ),
              //! pin 3
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  initialValue: pin3,
                  focusNode: pin3FocusNode,
                  onSaved: (newValue) => pin3 = newValue!,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenWidth(15),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: kTextColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: kPrimaryColor),
                    ),
                  ),
                  onChanged: (value) {
                    nextField(value: value, focusNode: pin4FocusNode);
                  },
                ),
              ),
              //! pin 4
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  initialValue: pin4,
                  focusNode: pin4FocusNode,
                  onSaved: (newValue) => pin4 = newValue!,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenWidth(15),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: kTextColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: kPrimaryColor),
                    ),
                  ),
                  onChanged: (value) {
                    pin4FocusNode.unfocus();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          DefaultButton(
            text: "Tiếp tục",
            press: () async {
              _formKey.currentState!.save();


              String otp = pin1 + pin2 + pin3 + pin4;
              // String otp = otpNe;
              var res = await Services.instance.setContext(context).getOTPUser(otp);

              if (res != false) {
                  // activate account for new user
                  Navigator.pushReplacementNamed(context, '/completeProfile');
              }
            },
          ),
        ],
      ),
    );
  }

  showFailAlert({required context, required String message}) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: message,
      widget: Text(
        "Xin hãy điền lại mã OTP...",
        style: TextStyle(
          fontSize: getProportionateScreenWidth(16),
        ),
      ),
      confirmBtnText: "OK",
      confirmBtnColor: Colors.blue.shade700,
    );
  }
}
