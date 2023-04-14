// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:flutter_app/http/core/hi-error.dart';
import 'package:flutter_app/http/core/net_adapater.dart';
import 'package:flutter_app/http/request/base_request.dart';

class DioAdapter extends NetAdapater {
  @override
  Future<NetResponse> send<T>(BaseRequest request) async {
    var response, options = Options(headers: request.header);
    var error;
    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), queryParameters: request.params,  options: options);
        print('request.url: ${request.url()} -- ${request.params} --$response --$options');
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio()
            .post(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.DELTELE) {
        response = await Dio()
            .delete(request.url(), data: request.params, options: options);
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }
    if (error != null) {
      throw HiNetError(response.statusCode, error.toString(),
          data: buildRes(response, request));
    }
    return buildRes(response, request);
  }

  NetResponse buildRes(Response response, BaseRequest request) {
    return NetResponse(
        data: response.data,
        request: request,
        statusCode: response.statusCode,
        statusMessge: response.statusMessage,
        extra: response);
  }
}
