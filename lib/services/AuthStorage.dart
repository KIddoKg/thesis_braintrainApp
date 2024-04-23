import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  //! access token
  void setAccessToken(String accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
  }

  Future<String> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('accessToken') ?? "";
    return accessToken;
  }

  //! refresh token
  void setRefreshToken(String refreshToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('refreshToken', refreshToken);
  }

  Future<String> getRefreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String refreshToken = prefs.getString('refreshToken') ?? "";
    return refreshToken;
  }

  //! user id
  void setUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? "";
    return userId;
  }

  //! phone number
  void setPhone(String phone) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phone);
  }

  Future<String> getPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString('phone') ?? "";
    return phone;
  }

  //! activation status
  void setIsActivated(bool isActivated) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isActivated', isActivated);
  }

  Future<bool> getIsActivated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isActivated = prefs.getBool('isActivated') ?? false;
    return isActivated;
  }
}
