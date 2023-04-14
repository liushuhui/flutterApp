// import 'dart:convert';

import 'package:flutter_app/db/hi-cache.dart';
import 'package:flutter_app/http/core/dio_adapter.dart';
import 'package:flutter_app/http/core/hi-error.dart';
// import 'package:flutter_app/http/core/mock_adapter.dart';
import 'package:flutter_app/http/core/net_adapater.dart';
import 'package:flutter_app/http/request/base_request.dart';

class HiNest {
  HiNest._();
  static HiNest? _instance;
  static HiNest getInstance() {
    _instance = HiNest._();
    return _instance!;
  }
  Future fire(BaseRequest request) async {
    NetResponse? response;
    test();
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog('BaseRequest -> HiNetError ,${e.data}');
    } catch (e) {
      //其他异常
      error = e;
      printLog(e);
    }
    if (response == null) {
      printLog('error: $error');
    }
    var result = response?.data;
    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);

      default:
        throw HiNetError(status!, result.toString(), data: result);
    }
  }
  Future<dynamic> send<T>(BaseRequest request) async {

    request.addHeader('token', '222');
    /// 使用Dio 发送请求
    NetAdapater adapater = DioAdapter();
    return adapater.send(request);

    /// 使用mock发送请求
    // NetAdapater adapater = MockAdapter();
    // return adapater.send(request);

    ///使用future发送请求
    // return Future.value({
    //   'statusCode': 200,
    //   'data': {'code': 0, 'message': 'success'}
    // });
  }

  void printLog(log) {
    print('hi_log: ${log.toString()}');
  }

  void test() {
    HiCache.getInstance()?.setString('aa', 'sssss');
    var value = HiCache.getInstance()?.get('aa');
    print('value111--$value');
  }
}
