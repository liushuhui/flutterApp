import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

///模拟数据
class MockRequest {
  // Future<dynamic> get(String action, {required Map params}) async {
  //   return mock(action: getJsonName(action), params: params);
  // }

  // Future<dynamic> post({required String action, required Map params}) async {
  //   return mock(action: action, params: params);
  // }

  Future<dynamic> mock(String action) async {
    var responseStr = await rootBundle.loadString('mock/$action.json');
    var responseJson = json.decode(responseStr);
    return responseJson;
  }

  Future<dynamic> mock2(String action) async {
    var responseStr = await rootBundle.loadString('mock/$action.json');
    var responseJson = json.decode(responseStr);
    return responseJson;
  }
}
