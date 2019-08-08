import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'endpoints.dart';

enum RequestType { get, post, put, patch, delete }
enum ResponseStatus {
  success_200,
  success_201,
  error_400,
  error_404,
  error_503,
  error_300
}
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
      {params: dynamic,
        url: String,
        requestType: RequestType,
        beginCallback: Function,
        contentType: ContentType,
        headers  : dynamic}) async {
    var dio = new Dio(
      new BaseOptions(
          baseUrl: BASE_URL,
          connectTimeout: 50000,
          receiveTimeout: 100000,
          followRedirects: false,
          validateStatus: (status) {
            return status < 503;
          },
          headers: headers ?? {"Content-Type": "application/json",},
      ),

    );
    dio.interceptors.add(LogInterceptor(responseBody: true));

    switch (requestType) {
      case RequestType.get:

        return await dio.get(url, queryParameters: params).then(
              (response) {
            if (response.statusCode == 400) {
              return ResponseModel(null, ResponseStatus.error_400);
            } else if (response.statusCode >= 404) {
              return ResponseModel(null, ResponseStatus.error_404);
            } else if (response.statusCode >= 503) {
              return ResponseModel(null, ResponseStatus.error_503);

            } else if (response.statusCode >= 200 ||
                response.statusCode >= 201) {

              return ResponseModel(response.data, ResponseStatus.success_200);
            }else{
              return ResponseModel(null,ResponseStatus.error_300);
            }
          },
        );
        break;

      case RequestType.post:

        return await dio
            .post(url,
            data: json.encode(params),
            options: new Options(
              contentType: ContentType.json,
              responseType: ResponseType.json,
            ))
            .then(
              (response) {
            if (response.statusCode == 400) {
              return ResponseModel(null, ResponseStatus.error_400);
            } else if (response.statusCode == 404) {
              return ResponseModel(null, ResponseStatus.error_404);
            } else if (response.statusCode >= 500) {
              return ResponseModel(null, ResponseStatus.error_503);
            } else if (response.statusCode == 300) {
              return ResponseModel(null, ResponseStatus.error_300);

            } else {
              return ResponseModel(response.data, ResponseStatus.success_200);
            }
          },
        );
    }

    return null;
  }
}
