import 'dart:convert';

import 'package:flutter_app/http/request/base_request.dart';

/// 统一网络层返回格式
class NetResponse {
  dynamic data;
  BaseRequest request;
  int statusCode;
  String statusMessge;
  dynamic extra;
  
  NetResponse(
    {
      required this.data,
      required this.request,
      required this.statusCode,
      required this.statusMessge,
      this.extra
    }
  );

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    } return data.toString();
  }
}

/// 网络请求抽象类
abstract class NetAdapater {
  Future<NetResponse> send<T>(BaseRequest request);
}