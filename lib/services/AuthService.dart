import 'dart:convert';

import 'package:brain_train_app/services/AuthStorage.dart';
import 'package:brain_train_app/services/ResultEnum.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AuthService {
  final AuthStorage authStorage = new AuthStorage();

  Future<SignupResult> signup(String phone, String password) async {
    var uri = Uri.parse("http://localhost:8080/api/auth/signup");
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map data = {'phone': '$phone', 'password': '$password'};
    var body = jsonEncode(data);

    try {
      var response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        authStorage.setPhone(phone);
        authStorage.setIsActivated(false);

        return SignupResult.success;
      } else {
        print("Request failed with status: ${response.statusCode}");
        return SignupResult.fail;
      }
    } catch (error) {
      print("An error occurred: $error");
      return SignupResult.fail;
    }
  }

  Future<VerifyAccountResult> verifyAccount(String otp) async {
    var uri = Uri.parse("http://localhost:8080/api/auth/verify-account/${otp}");

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        authStorage.setIsActivated(true);
        return VerifyAccountResult.success;
      } else {
        print("Request failed with status: ${response.statusCode}");
        return VerifyAccountResult.wrongOtp;
      }
    } catch (error) {
      print("An error occurred: $error");
      return VerifyAccountResult.fail;
    }
  }

  Future<Result> addInformation(
      String fullName, DateTime dob, String gender) async {
    // convert dob to match LocalDate in java
    String formatDob = DateFormat("yyyy-MM-dd").format(dob);
    String phone = await authStorage.getPhone();

    var uri = Uri.parse(
        "http://localhost:8080/api/auth/add-information/${phone}?fullName=${fullName}&dob=${formatDob}&gender=${gender}");

    try {
      var response = await http.put(uri);
      if (response.statusCode == 200) {
        return Result.success;
      } else {
        print("Request failed with status: ${response.statusCode}");
        return Result.fail;
      }
    } catch (error) {
      print("An error occurred: $error");
      return Result.fail;
    }
  }

  Future<LoginResult> login(String phone, String password) async {
    var uri = Uri.parse("http://localhost:8080/api/auth/login");
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map data = {'phone': '$phone', 'password': '$password'};
    var body = jsonEncode(data);

    try {
      var response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        var accessToken = jsonResponse['access_token'];
        authStorage.setAccessToken(accessToken);

        var userId = jsonResponse['user_id'];
        authStorage.setUserId(userId);

        return LoginResult.success;
      } else {
        print("Request failed with status: ${response.statusCode}");
        return LoginResult.fail;
      }
    } catch (error) {
      print("An error occurred: $error");
      return LoginResult.fail;
    }
  }

  Future<Result> resendOtp(String phone) async {
    var uri = Uri.parse("http://localhost:8080/api/auth/resend-otp/${phone}");

    try {
      var response = await http.post(uri);
      if (response.statusCode == 200) {
        return Result.success;
      } else {
        print("Request failed with status: ${response.statusCode}");
        return Result.fail;
      }
    } catch (error) {
      print("An error occurred: $error");
      return Result.fail;
    }
  }

  Future<Result> resetPassword(String phone, String password) async {
    var uri = Uri.parse(
        "http://localhost:8080/api/auth/reset-password/${phone}?password=${password}");

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        return Result.success;
      } else {
        print("Request failed with status: ${response.statusCode}");
        return Result.fail;
      }
    } catch (error) {
      print("An error occurred: $error");
      return Result.fail;
    }
  }
}
