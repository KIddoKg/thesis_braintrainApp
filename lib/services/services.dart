import 'dart:convert';
import 'dart:developer';
import 'package:brain_train_app/models/dataGameGet.dart';
import 'package:brain_train_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helper/appsetting.dart';

import '../../services/api.dart';
import '../../services/dio_helper.dart';
import 'package:flutter/cupertino.dart';

class Services {
  BuildContext? _context;

  Services._internal();

  static final Services _instance = Services._internal();

  static Services get instance => _instance;

  Services setContext(BuildContext context) {
    Services.instance._context = context;
    return _instance;
  }

  Future<void> _showAlert(String title, String message,
      {void Function()? onTap}) async {
    if (_context == null) return;

    await showCupertinoDialog(
        context: _context!,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ));

    if (onTap != null) {
      onTap();
    }
  }

  Future<void> _gotoAuthenScreen() async {
    AppSetting.instance.reset();
    await AppSetting.pref.remove('@profile');
    AppSetting.instance.accessToken = "";
    Navigator.pushNamedAndRemoveUntil(_context!, '/login', (route) => false);
  }

  Future<T> _errorAction<T>(NetResponse res,
      {String? metaData,
        bool withLoadingBefore = true,
        Future<T> Function()? callApi}) async {
    String code = res.error!['code'];
    String message = res.error!['message'];

    if (_context == null) print('Chưa gán context cho mã lỗi "${code}" này');
    log('> context: $_context');

    // if (withLoadingBefore) Navigator.pop(_context!);

    switch (code) {
      case 'token_expired':
        print("case nè");
        var res = await Services.instance.refreshToken();

        if (!res.isSuccess) {
          print("khác nè");
          await _showAlert('Thông báo', 'Hết thời gian đăng nhập. [Mã: $code]',
              onTap: () => _gotoAuthenScreen());
        } else {
          res.cast<AppSetting>(fromJson: res.data);
          var y = json.encode(AppSetting.instance.toJson());
          AppSetting.pref.setString('appsetting', y);

          if (callApi != null) {
            return await callApi();
          }
        }
        break;
      case 'today_tracking_not_found':
        break;
      default:
        _showAlert(metaData != null ? metaData : 'Thông báo',
            '$message. [Nguồn: $code]');
        break;
    }

    return defaultReturnValue<T>();
  }

  T defaultReturnValue<T>() {
    if (T == bool) {
      return false as T;
    } else if (T == int) {
      return 0 as T;
    } else {
      return null as T;
    }
  }

  // Future<T> _errorAction<T>(
  //     NetResponse res,
  //     {String? metaData, bool withLoadingBefore = true, Future<T> Function()? callApi}
  //     ) async {
  //   String code = res.error!['code'];
  //   String message = res.error!['message'];
  //
  //   if (_context == null) print('Chưa gán context cho mã lỗi "${code}" này');
  //   log('> context: $_context');
  //
  //   T? returnValue;
  //
  //   switch (code) {
  //     case 'unauthorized':
  //       print("case nè");
  //       var res = await Services.instance.refreshToken();
  //
  //       if (!res.isSuccess) {
  //         print("khác nè");
  //         await _showAlert('Thông báo', 'Hết thời gian đăng nhập. [Mã: $code]',
  //             onTap: () => _gotoAuthenScreen());
  //       } else {
  //         res.cast<AppSetting>(fromJson: res.data);
  //         var y = json.encode(AppSetting.instance.toJson());
  //         AppSetting.pref.setString('appsetting', y);
  //
  //         if (callApi != null) {
  //           returnValue = await callApi();
  //         }
  //       }
  //       break;
  //     default:
  //       _showAlert(metaData != null ? metaData : 'Thông báo',
  //           '$message. [Nguồn: $code]');
  //       break;
  //   }
  //
  //   return returnValue!;
  // }


  Future<NetResponse?> signUpUser(String phone, String pwd) async {
    var res = await API.singnUp(phone, pwd).request();
    if (res.isSuccess) {
      return res;
    } else {
      _errorAction(res);
    }
    return null;
  }

  Future<bool> getOTPUser(String otp) async {
    var res = await API.getOTP(otp).request();
    if (res.isSuccess) {
      return true;
    } else {
      _errorAction(res);
    }
    return false;
  }

  Future<NetResponse?> resendOTPUser(String phone) async {
    var res = await API.resendOTP(phone).request();
    if (res.isSuccess) {
      return res;
    } else {
      _errorAction(res);
    }
    return null;
  }

  Future<bool> addInfoUser(String phone, String name, String dob, String gender) async {
    var res = await API.addInfoUser(phone,name,dob,gender).request();
    if (res.isSuccess) {
      return true;
    } else {
      _errorAction(res);
    }
    return false;
  }

  Future<NetResponse> loginUser(String phone, String pwd) async {
    var res = await API.login(phone, pwd).request();
    if (res.isSuccess) {
      res.cast<UserModel>(fromJson: res.data['user']);
      res.cast<AppSetting>(fromJson: res.data);
      print("test ${res.data}");
      var x = json.encode(UserModel.instance.toJson());
      AppSetting.pref.setString('profile', x);

      var y = json.encode(AppSetting.instance.toJson());
      AppSetting.pref.setString('appsetting', y);

      return res;
    } else {
      _errorAction(res, withLoadingBefore: false);
    }
    return res;
  }


  // Future<UserModel?> getInfoUser(UserModel user) async {
  //   var res = await API.infoUser(user).request();
  //   if (res.isSuccess) {
  //     return res.cast<UserModel>();
  //   } else {
  //     return await _errorAction(res, callApi: () async {
  //       return getInfoUser(user);
  //     });
  //   }
  // }

  Future<bool?> sendPointGameUser(String gameType, String gameName,int score, int playTime) async {
    var res = await API.sendPointGame(gameType,gameName,score,playTime).request();
    if (res.isSuccess) {
      return true;
    } else {
      return await _errorAction(res, callApi: () async {
        return sendPointGameUser(gameType,gameName,score,playTime);
      });
    }
  }
  Future<bool?> moodDaily(String sleepHrs, String mood) async {
    var res = await API.moodDaily(sleepHrs,mood).request();
    if (res.isSuccess) {
      return true;
    } else {
      return await _errorAction(res, callApi: () async {
        return moodDaily(sleepHrs,mood);
      });
    }
  }
  Future<bool?> addDataPlayGameUser({Map<String, dynamic>? filter}) async {
    var res = await API.addDataPlayGame(filter: filter).request();
    if (res.isSuccess) {
      return true;
    } else {
      return await _errorAction(res, callApi: () async {
        return addDataPlayGameUser(filter: filter);
      });
    }
  }
  Future<NetResponse?> getDataPlayGameUser(String gameName) async {
    var res = await API.getDataPlayGame(gameName).request();
    if (res.isSuccess) {
      return res;
    } else {
      return await _errorAction(res, callApi: () async {
        return getDataPlayGameUser(gameName);
      });
    }
  }
  Future<bool?> postNotifyToken(String notifytoken) async {
    var res = await API.notifyToken(notifytoken).request();
    if (res.isSuccess) {
      return true;
    } else {
      return await _errorAction(res, callApi: () async {
        return postNotifyToken(notifytoken);
      });
    }
  }
 Future<NetResponse?> getDataGameUser({Map<String, dynamic>? filter}) async {
    var res = await API.getDataGame(filter: filter).request();
    if (res.isSuccess) {
      return res;
    } else {
      return await _errorAction(res, callApi: () async {
        return getDataGameUser(filter: filter);
      });
    }
  }

  Future<NetResponse?> getRankingUser(String gameName) async {
    var res = await API.getRanking(gameName).request();
    if (res.isSuccess) {
      return res;
    } else {
      return await _errorAction(res, callApi: () async {
        return getRankingUser(gameName);
      });
    }
  }

  Future<NetResponse?> getRankingUserMon(String gameName) async {
    var res = await API.getRankingMonth(gameName).request();
    if (res.isSuccess) {
      return res;
    } else {
      return await _errorAction(res, callApi: () async {
        return getRankingUserMon(gameName);
      });
    }
  }
  Future<NetResponse?> getRankingUserWeek(String gameName) async {
    var res = await API.getRankingWeek(gameName).request();
    if (res.isSuccess) {
      return res;
    } else {
      return await _errorAction(res, callApi: () async {
        return getRankingUserWeek(gameName);
      });
    }
  }


  Future<bool?> updateUser(String code) async {
    var res = await API.updateUser(code).request();
    if (res.isSuccess) {
      return true;
    } else {
      return await _errorAction(res, callApi: () async {
        return updateUser(code);
      });
    }
  }
  Future<NetResponse?> getOBJ() async {
    var res = await API.getOBJ().request();
    if (res.isSuccess) {
      return res;
    } else {
      return await _errorAction(res, callApi: () async {
        return getOBJ();
      });
    }
  }

  Future<NetResponse?> getDaily() async {
    var res = await API.daily().request();
    if (res.isSuccess) {
      return res;
    } else {
      return await _errorAction(res, callApi: () async {
        return getDaily();
      });
    }
  }

  Future<NetResponse> logout() async {
    var res = API.logout().request();
    return res;
  }

  Future<bool?> lockUser() async {
    var res = await API.addLock().request();
    if (res.isSuccess) {
      return true;
    } else {
      return await _errorAction(res, callApi: () async {
        return lockUser();
      });
    }
  }


  Future<NetResponse> refreshToken() async {
    return await API.refreshToken(AppSetting.instance.refreshToken).request();
  }

  bool checkAuthenToken() {
    print("ee${UserModel.instance.sessionStart}");
    if (UserModel.instance.sessionStart.isEmpty) return false;

    var startDate =
    DateFormat('HH:mm dd/MM/yyyy').parse(UserModel.instance.sessionStart);
    var defaultHours = 24;
    var expired = startDate.add(Duration(hours: defaultHours));

    var now = DateTime.now();
    // log('lastLoginDate $startDate');
    // log('expiredDate $expired');
    // log('now $now');

    var isExpired = now.isAfter(expired);
    return isExpired;
  }
}
