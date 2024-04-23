import 'package:brain_train_app/models/dataGameGet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../helper/appsetting.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';

import 'package:brain_train_app/models/daily_model.dart';
import 'package:brain_train_app/models/objective_model.dart';
import 'package:brain_train_app/models/ranking_model.dart';
import 'package:brain_train_app/models/user_model.dart';



class NetResponseList {
  int total;
  int page;
  int size;
  int pageCount;
  bool canNext = false;
  bool canPrev = false;

  NetResponseList(this.total, this.page, this.size, this.pageCount,
      this.canNext, this.canPrev);

  NetResponseList.fromJson(Map<String, dynamic> json, Map<String, dynamic> list)
      : total = json['total'],
        page = json['page'],
        size = json['size'],
        pageCount = json['pageCount'],
        canNext = json['canNext'],
        canPrev = json['canPrev'];
}

class NetResponse {
  late Map<String, dynamic>? meta;

  /// Response data Map type or orignal data
  late dynamic orignal;
  late dynamic data;
  late bool isSuccess;
  late Map<String, dynamic>? error;

  // NetResponse(
  //     bool success, dynamic data, dynamic error, Map<String, dynamic>? meta) {
  //   this.data = data;
  //   isSuccess = success;
  //   this.error = error;
  //   this.meta = meta;
  // }

  NetResponse(this.isSuccess, this.data, this.error, this.meta);

  NetResponse.fromJson(Map<String, dynamic> json)
      : meta = json['meta'],
        // isSuccess = json['meta']['success'],
        // isSuccess = json['isSuccess'],
        error = json['error'],
        data = json['data'];
  T cast<T>({Map<String, dynamic>? fromJson}) {
    var json = fromJson ?? data!;

    if (T == UserModel) return UserModel.fromJson(json) as T;

    if (T == AppSetting) return AppSetting.fromJson(json) as T;
    if (T == GameData) return GameData.fromJson(json) as T;
    if (T == DataRanking) return DataRanking.fromJson(json) as T;
    if (T == Objective) return Objective.fromJson(json) as T;
    if (T == Daily) return Daily.fromJson(json) as T;

    return json as T;
  }

  List<T> castList<T>({List? fromList}) {
    var listMap = (data is List) ? (data as List) : fromList!;
    var lst = listMap.map((e) => cast<T>(fromJson: e)).toList();
    return lst;
  }
}

class NetRequest {
  late String url;
  late String method;
  // late Map<String, dynamic>? data;
  late Object? data;
  late Map<String, dynamic>? header;
  CancelToken canceltoken = CancelToken();
  NetRequest(this.url, this.method, {this.header, this.data});

  late BuildContext _context;
  NetRequest setContext(BuildContext ctx) {
    _context = ctx;
    return this;
  }

  void withAuthen() async {
    header = Map<String, dynamic>();
    header!['Authorization'] = "Bearer ${AppSetting.instance.accessToken}";
  }

  // Show log debug console
  void logRequest(Dio dio) {
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));

    dio.interceptors.add(PrettyDioLogger(
      requestHeader: false,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
    ));
  }

  Future<NetResponse> request() async {
    Dio dio = Dio();

    logRequest(dio);
    Options options = Options(
        method: method, headers: header, validateStatus: (status) => true);
    // try {
      var response = await dio.request(url,
          cancelToken: canceltoken,
          // queryParameters: data,
          data: data,
          options: options);

      // lỗi
      if (response.statusCode != 200) {
        if ((response.data is Map) && response.data != null) {
          var res = NetResponse.fromJson(response.data);
          res.isSuccess = false;
          return res;
        } else {
          var error = {
            "code": response.statusCode.toString(),
            'message': response.statusMessage
          };
          return NetResponse(false, null, error, null);
        }
      }

      bool isMap = response.data is Map<String, dynamic>;
      var _data = isMap ? response.data['data'] : response.data as String;
      var error = isMap ? response.data['error'] : null;
      var x = NetResponse(true, _data, error, response.data['metadata']);
      return x;
    // } catch (e) {
    //   throw e;
    // }
  }

  void cancel() {
    canceltoken.cancel();
  }
}
