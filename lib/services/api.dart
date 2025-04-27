import 'package:dio/dio.dart';

import 'package:brain_train_app/models/user_model.dart';
import 'dio_helper.dart';

class API {
  static String identity = 'https://braintrain-server.aiotlab.io.vn/api';
  static String auth = 'https://braintrain-server.aiotlab.io.vn/api/auth';
  // static String identity = 'http://localhost:8080/api'; //thay đổi nó khi muốn chạy local
  // static String auth = 'http://localhost:8080/api/auth'; //thay đổi nó khi muốn chạy local

//https://braintrain-server.aiotlab.io.vn/api/admin/login

  static Dio dio = Dio();

  //http://45.117.177.103:8080/api/auth/signup
  static NetRequest singnUp(String phone, String pwd) {
    String url = '$auth/signup';
    Map<String, String> data = Map();

    data['phone'] = phone;
    data['password'] = pwd;

    NetRequest req = NetRequest(url, 'post', data: data);

    return req;
  }



  // http://45.117.177.103:8080/api/auth/verify-account/{otp}
  static NetRequest getOTP(String otp) {
    String url = '$auth/verify-account/${otp}';

    NetRequest req = NetRequest(url, 'get');
    return req;
  }

  //http://45.117.177.103:8080/api/auth/resend-otp/0869307217
  static NetRequest resendOTP(String phone) {
    String url = '$auth/resend-otp/${phone}';

    NetRequest req = NetRequest(url, 'post');

    return req;
  }

  //http://45.117.177.103:8080/api/auth/add-information/0869307217?fullName=Bao&dob=2001-03-27&gender=MALE
  static NetRequest addInfoUser(String phone, String name, String dob, String gender) {
    Map<String, dynamic> data = Map();
    var filterQuery = '';
    if (refreshToken != null) {
      filterQuery =
      'fullName=$name&dob=$dob&gender=$gender';
    }
    String url = '$auth/add-information/${phone}?$filterQuery';


    NetRequest req = NetRequest(url, 'put', data: data);

    return req;
  }

  //http://45.117.177.103:8080/api/auth/login
  static NetRequest login(String phone, String pwd) {
    String url = '$auth/login';
    Map<String, String> data = Map();

    data['phone'] = phone;
    data['password'] = pwd;

    NetRequest req = NetRequest(url, 'post', data: data);

    return req;
  }

  //http://45.117.177.103:8080/api/user/1
  static NetRequest infoUser(UserModel user) {
    String url = '$identity/user/${user.accountId}';
    NetRequest req = NetRequest(url, 'get')..withAuthen();

    return req;
  }

  // http://45.117.177.103:8080/api/playing-turn
  static NetRequest sendPointGame(String gameType, String gameName,int score, int playTime) {
    String url = '$identity/playing-turn';
    Map<String, dynamic> data = Map();

    data['gameType'] = gameType;
    data['gameName'] = gameName;
    data['score'] = score;
    data['playTime'] = playTime;

    NetRequest req = NetRequest(url, 'post', data: data)..withAuthen();

    return req;
  }
  // http://45.117.177.103:8080/api/daily-workout
  static NetRequest moodDaily(String sleepHrs, String mood) {



      String filterQuery =
      'sleepHrs=$sleepHrs&mood=$mood';

    String url = '$identity/daily-workout?$filterQuery';

    NetRequest req = NetRequest(url, 'post' )..withAuthen();

    return req;
  }

  // http://localhost:8080/api/playing-turn
  static NetRequest addDataPlayGame({Map<String, dynamic>? filter}) {
    String url = '$identity/playing-turn';
    Map<String, dynamic> data = Map();
    if (filter != null) {
      data['gameType'] = filter['gameType'] ?? null;
      data['gameName'] = filter['gameName'] ?? null;
      data['score'] = filter['score'] ?? null;
      data['playTime'] = filter['playTime'] ?? 0;
      data['level'] = filter['maxLevel'] ?? 1;
      data['newPicOneResult'] = filter['newPicOneResult'] ?? null;
      data['newPicTwoResult'] = filter['newPicTwoResult'] ?? null;
      data['noOfFishCaught'] = filter['noOfFishCaught'] ??null;
      data['boatStatus'] = filter['boatStatus'] ?? false;
      data['wordList'] = filter['wordList'] ?? null;
    }
    NetRequest req = NetRequest(url, 'post', data: data)..withAuthen();

    return req;
  }


  //http://45.117.177.103:8080/api/playing-turn/best-game/SUM
  static NetRequest getDataPlayGame(String gameName) {
    String url = '$identity/playing-turn/best-game/$gameName';
    NetRequest req = NetRequest(url, 'get')..withAuthen();

    return req;
  }


  //http://45.117.177.103:8080/api/user/notify-token?notifyToken=1234
  static NetRequest notifyToken(notifytoken) {
    var filterQuery = '';
    if (refreshToken != null) {
      filterQuery =
      'notifyToken=$notifytoken';
    }

    String url = '$identity/user/notify-token?$filterQuery';
    NetRequest req = NetRequest(url, 'post')..withAuthen();
    return req;
  }

  // http://45.117.177.103:8080/api/playing-turn/by-game-type?gameType=MATH&fromDate=1696700000000&toDate=1697313876927&gameName=SUM
  static NetRequest getDataGame({Map<String, dynamic>? filter}) {

    var filterQuery = '';

    if (filter != null) {
      var gameType = filter['gameType'];
      var fromDate = filter['fromDate'];
      var toDate = filter['toDate'];
      filterQuery =
      'gameType=$gameType&fromDate=$fromDate&toDate=$toDate';
    }
    String url = '$identity/playing-turn/by-game-type?$filterQuery';
    NetRequest req = NetRequest(url, 'get')..withAuthen();

    return req;
  }
  //http://45.117.177.103:8080/api/user/update-information

  static NetRequest updateUser(String code) {
    String url = '$identity/user/update-information';
    Map<String, dynamic> data = Map();
    data['loginCode'] = code;

    NetRequest req = NetRequest(url, 'put',data: data)..withAuthen();

    return req;
  }
  //http://45.117.177.103:8080/api/ranking/weekly/SUM
  static NetRequest getRankingWeek(String gameName) {
    String url = '$identity/ranking/weekly/$gameName';
    NetRequest req = NetRequest(url, 'get')..withAuthen();

    return req;
  }

  //http://45.117.177.103:8080/api/ranking/monthly/SUM
  static NetRequest getRankingMonth(String gameName) {
    String url = '$identity/ranking/monthly/$gameName';
    NetRequest req = NetRequest(url, 'get')..withAuthen();

    return req;
  }

  //http://45.117.177.103:8080/api/ranking/all/SUM
  static NetRequest getRanking(String gameName) {
    String url = '$identity/ranking/all/$gameName';
    NetRequest req = NetRequest(url, 'get')..withAuthen();

    return req;
  }
 //http://45.117.177.103:8080/api/objective
  static NetRequest getOBJ() {
    String url = '$identity/objective';
    NetRequest req = NetRequest(url, 'get')..withAuthen();

    return req;
  }


  //http://45.117.177.103:8080/api/daily-workout
  static NetRequest daily() {
    String url = '$identity/daily-workout';
    NetRequest req = NetRequest(url, 'get')..withAuthen();

    return req;
  }

  //http://45.117.177.103:8080/api/user/lock
  static NetRequest addLock() {
    String url = '$identity/user/lock';
    NetRequest req = NetRequest(url, 'put')..withAuthen();

    return req;
  }

  static NetRequest refreshToken(refreshToken) {
    Map<String, dynamic> data = Map();
    var filterQuery = '';
    if (refreshToken != null) {
      filterQuery =
      'refreshToken=$refreshToken';
    }

    String url = '$auth/refresh-token?$filterQuery';
    NetRequest req = NetRequest(url, 'post', data: data);
    return req;
  }

  //http://localhost:8080/api/auth/logout
  static NetRequest logout() {
    String url = '$auth/logout';

    NetRequest req = NetRequest(url, 'get')..withAuthen();
    return req;
  }

}