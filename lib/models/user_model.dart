// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';

import 'package:brain_train_app/helper/formater.dart';

import '../../helper/appsetting.dart';

class UserModel {
  String accountId = "";

  String phone = "";
  String? name;
  List<dynamic> dob = [];
  String gender = "";
  int? age;
  String? loginCode;
  String profileUrl = "";
  String passwordCache = '';
  String passwordTwo = '';
  String sessionStart = '';
  String tokenNotify = '';
  bool enablePushNotification = false;

  UserModel._internal();

  static final UserModel _instance = UserModel._internal();

  static UserModel get instance => _instance;

  factory UserModel.fromJson(Map<String, dynamic> json,
      {bool isLocalData = false}) {
    _instance.accountId = json['id'] ?? '';
    _instance.phone = json['phone'] ?? '';
    _instance.name = json['fullName'] ?? '';
      _instance.dob = (json['dob']) ?? "";

    _instance.age = json['age'] ?? 0;
    _instance.loginCode = json['loginCode'] ?? "";
    _instance.gender = json['gender'] ?? '';
    _instance.passwordTwo = json['loginCode'] ?? '';

    _instance.profileUrl = json['avatarLink'] ?? '';
    _instance.passwordCache = json['passwordCache'] ?? '';
    _instance.tokenNotify = json['tokenNotify'] ?? '';
    if (!isLocalData) {
      var time = DateTime.now();
      _instance.sessionStart = time.millisecondsSinceEpoch.toDateString();
    }
    log('user.sessionStart ${_instance.sessionStart}');
    return _instance;
  }



  Map<String, dynamic> toJson() {
    return {
      "accountId": _instance.accountId,
      "name": _instance.name,
      "phone": _instance.phone,
      "dob": _instance.dob,
      "passwordTwo": _instance.passwordTwo,
      "age": _instance.age,
      "gender": _instance.gender,
      "profileUrl": _instance.profileUrl,
      "sessionStart": _instance.sessionStart,
      "passwordCache": _instance.passwordCache,
      "tokenNotify": _instance.tokenNotify,
    };
  }

  void save() {
    var json = jsonEncode(toJson());
    AppSetting.pref.setString('@profile', json);
  }
}
