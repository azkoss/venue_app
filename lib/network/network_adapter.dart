import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'endpoints.dart';

enum RequestType { get, post, put, patch, delete }
enum ResponseStatus { success_200, success_201, error_400, error_404, error_503 }
enum LoadingStatus { loading, error, success }

class ResponseModel {
  final data;
  final ResponseStatus status;
  ResponseModel(this.data, this.status);
}

//APIManager
class APIManager {
  static beginRequest() {}

  static Future<ResponseModel> request(
      {params: dynamic, url: String, requestType: RequestType, beginCallback: Function}) async {
//    String token = await UserManager.getToken();
    var dio = new Dio(
      new BaseOptions(
        baseUrl: baseURL,
        connectTimeout: 50000,
        receiveTimeout: 100000,
        followRedirects: false,
        validateStatus: (status) {
          return status < 503;
        },
        headers: {
          //   "Authorization": "Bearer $token",
        },
        queryParameters: params,
        contentType: ContentType.html,
        responseType: ResponseType.json,
      ),
    );

    switch (requestType) {
      case RequestType.get:
        return await dio.get(url).then((response) {
          if (response.statusCode == 400) {
            return ResponseModel(null, ResponseStatus.error_400);
          } else if (response.statusCode >= 404) {
            return ResponseModel(null, ResponseStatus.error_404);
          } else if (response.statusCode >= 503) {
            return ResponseModel(null, ResponseStatus.error_503);
          } else if (response.statusCode >= 200 || response.statusCode >= 201) {
            return ResponseModel(response.data, ResponseStatus.success_200);
          }
        });
        break;

      case RequestType.post:
        return await dio.post(url, data: params, options: new Options(contentType: ContentType.json)).then((res) {
          if (res.statusCode == 400) {
            return ResponseModel(null, ResponseStatus.error_400);
          } else if (res.statusCode >= 500) {
            return ResponseModel(null, ResponseStatus.error_503);
          } else {
            return ResponseModel(res.data, ResponseStatus.success_200);
          }
        });
    }

    return null;
  }
}
