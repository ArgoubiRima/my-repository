import 'dart:async';

import 'package:dio/dio.dart';
import 'package:untitled10/config/address_config.dart';
import 'package:untitled10/global/notifications.dart';
import 'package:untitled10/service/dio_config.dart';

enum RequestType { get, post, put, delete }

class Api {
  static Future<dynamic> makeRequest(
      {required RequestType requestType,
      required String endpoint,
      dynamic options,
      dynamic data}) async {
    String theUrl = "${AddressConfig.url}$endpoint";
    print(theUrl);
    try {
      switch (requestType) {
        case RequestType.get:
          Response response = await DioConfig.dioClient
              .get(
                theUrl,
                options: Options(validateStatus: (status) => true),
              )
              .timeout(const Duration(seconds: 20));
          return response;
        case RequestType.post:
          Response response = await DioConfig.dioClient
              .post(
                theUrl,
                options: options ?? Options(validateStatus: (status) => true),
                data: data,
              )
              .timeout(const Duration(seconds: 20));
          return response;
        case RequestType.put:
          Response response = await DioConfig.dioClient
              .put(
                theUrl,
                options: Options(validateStatus: (status) => true),
                data: data,
              )
              .timeout(const Duration(seconds: 20));
          return response;
        case RequestType.delete:
          Response response = await DioConfig.dioClient
              .delete(
                theUrl,
                options: Options(validateStatus: (status) => true),
              )
              .timeout(const Duration(seconds: 20));
          return response;
      }
    } on TimeoutException catch (_) {
      showError("Time Out");
      return null;
    }
  }
}
