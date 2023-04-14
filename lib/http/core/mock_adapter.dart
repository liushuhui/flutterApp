import 'package:flutter_app/http/core/net_adapater.dart';
import 'package:flutter_app/http/request/base_request.dart';

class MockAdapter extends NetAdapater {
  @override
  Future<NetResponse> send<T>(BaseRequest request) {
    return Future.delayed(const Duration(milliseconds: 1000), () {
      return NetResponse(
        data: {'code': 0, 'message': 'success11'} , statusCode: 200, request: request, statusMessge: 'test'
        );
    });
  }

}