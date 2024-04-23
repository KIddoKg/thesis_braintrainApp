import 'dart:convert';
import 'dart:developer';

import 'package:brain_train_app/models/user_model.dart';
import 'package:brain_train_app/routes/app_route.dart';
import 'package:brain_train_app/screens/wrapper.dart';
// import 'package:brain_train_app/services/AuthService.dart';
// import 'package:brain_train_app/services/ResultEnum.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/appsetting.dart';
import '../../../../helper/logging.dart';
import '../../../../services/services.dart';
import '../../../../shared/share_widgets.dart';
import '../../shared/DefaultButton.dart';
import '../../shared/InputFieldDecoration.dart';
import '../../shared/constants.dart';
import '../../shared/size_config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isTokenExpired = false;
  String phone = "";
  String password = "";
  bool rememberMe = false;
  bool disable = false;
  DateTime previousDate = DateTime(2023, 5, 12);
  // AuthService authService = AuthService();

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }
  @override
  void initState() {
    super.initState();
    getData();
    onInit();
  }
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    String? dateTimeString = prefs.getString('previousDate');

    if (dateTimeString != null) {
      previousDate = DateTime.parse(dateTimeString);
      // print("aa$previousDate");
    }

    final currentDate = DateTime.now();
    print("${currentDate} ${previousDate}");
    if (currentDate.day != previousDate.day ||
        currentDate.month != previousDate.month ||
        currentDate.year != previousDate.year) {
      await prefs.setBool('emoj', true);
    }else{
      await prefs.setBool('emoj', false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildPhoneInputField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordInputField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          // Row(
          //   children: [
          //     Checkbox(
          //       value: rememberMe,
          //       onChanged: (value) {
          //         setState(() {
          //           rememberMe = value!;
          //         });
          //       },
          //     ),
          //     Text(
          //       "Remember me",
          //       style: TextStyle(
          //         fontSize: getProportionateScreenWidth(15),
          //       ),
          //     ),
          //     Spacer(),
          //     GestureDetector(
          //       onTap: () =>
          //           Navigator.pushNamed(context, RouteGenerator.forgotPassword),
          //       child: Text(
          //         "Quên Mật Khẩu",
          //         style: TextStyle(
          //           decoration: TextDecoration.underline,
          //           fontSize: getProportionateScreenWidth(15),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            disable: disable,
            text: "Đăng nhập",
            press: () async {

              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                disable = true;
                setState(() {

                });
               onLogin(password);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPhoneInputField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phone = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return kPhoneNullError;
        } else if (!(value.startsWith("0") && value.length == 10)) {
          return kInvalidPhoneError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: buildInputFieldDecoration(
        "Số điện thoại",
        "Nhập số điện thoại",
        Icons.phone,
      ),
    );
  }

  TextFormField buildPasswordInputField() {
    return TextFormField(
      obscureText: !isPasswordVisible,
      onSaved: (newValue) => password = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return kPassNullError;
        } else if (value.length < 4) {
          return kShortPassError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: passwordFieldDecoration(
        "Mật khẩu",
        "Nhập mật khẩu",
        isPasswordVisible,
        togglePasswordVisibility,
      ),
    );
  }

  showFailAlert({required context}) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: "Đăng Nhập Thất Bại",
      widget: Text(
        "Xin hãy đăng nhập lại...",
        style: TextStyle(
          fontSize: getProportionateScreenWidth(16),
        ),
      ),
      confirmBtnText: "OK",
      confirmBtnColor: Colors.blue.shade700,
    );
  }

  onLogin(String password) async {
    await Future.delayed(Duration(seconds: 5));
    var res;
    if(mounted) {
      res =
      await Services.instance.setContext(context).loginUser(phone, password);
    }else{
      res =
      await Services.instance.loginUser(phone, password);
    }
    if (res.isSuccess) {
      UserModel.instance.passwordCache = password;
      UserModel.instance.save();
      AppSetting.instance.save();
      FocusManager.instance.primaryFocus?.unfocus();
      if(mounted)
            Navigator.pushNamed(context, RouteGenerator.leader);
    } else {
      // showFailAlert(context: context);
      disable = false;
      setState(() {

      });
    }
    // toggleLoading();

  }
  onInit() async {
    await AppSetting.init();

    // // bool isExits = AppSetting.instance.accessToken == "";
    // bool isExitsPro = AppSetting.pref.containsKey('@profile');
    // print("rreo${isExitsPro}");
    // if (isExitsPro) {
    //   var user = AppSetting.pref.getString('profile')!;
    //   log('> Profile: ' + user);
    //   var userJson = json.decode(user);
    //   UserModel.fromJson(userJson);
    //   var appsetting = json.decode(AppSetting.pref.getString('appsetting')!);
    //   AppSetting.fromJson(appsetting);
    //
    //
    //   log('> SharedPreferences: $user');
    //
    //   phone = UserModel.instance.phone;
    //   // DMCLSocket.instance.setContext(context);
    //   // DMCLSocket.instance.userConnect(AdminModel.instance);
    //   Navigator.pushNamed(context, RouteGenerator.leader);
    // }
    bool isExits = AppSetting.pref.containsKey('@profile');
    if (!isExits) {
      // AppLog.instance
      //     .add('login.checkAuthen', description: StackTrace.current.toString());
      return;
    }

    if (isExits) {
      var user = AppSetting.pref.getString('@profile')!;
      log('> appsetting.profile: $user');
      // AppLog.instance.add('appsetting.profile', description: user);
      var userJson = json.decode(user);
      UserModel.fromJson(userJson, isLocalData: true);
      print("appsetting}");
      var appsetting = json.decode(AppSetting.pref.getString('@appSetting')!);
      AppSetting.fromJson(appsetting);

      phone = UserModel.instance.phone;
    }
    print("aAA");
    // TODO: kiểm tra authen quá 24 tiếng
    isTokenExpired = Services.instance.checkAuthenToken();
    if (isTokenExpired) {
      Fluttertoast.showToast(msg: 'Phiên đăng nhập đã hết hiệu lực.');

      if (AppSetting.instance.enableAuthenLocal! &&
          UserModel.instance.passwordCache.isNotEmpty) {
        return;
      }
    } else {
      // case auto-login, connect socket and register user

      Fluttertoast.showToast(msg: 'Đăng nhập tự động');

      disable = true;
      setState(() {});
      print("ssss");
      if (UserModel.instance.passwordCache.isNotEmpty) {
        onLogin(UserModel.instance.passwordCache);
      }
      // else {
      //     Future.delayed(const Duration(milliseconds: 525), () {
      //       Navigator.pushNamed(context, RouteGenerator.leader);
      //     });
      // }
    }
  }

}
