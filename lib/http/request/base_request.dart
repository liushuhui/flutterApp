import '../dao/login_dao.dart';

enum HttpMethod { GET, POST, DELTELE }

/// 基础请求
abstract class BaseRequest {
  // ignore: prefer_typing_uninitialized_variables
  var pathParams;
  var useHttps = true;

  String authority() {
    return 'api.devio.org';
  }

  HttpMethod httpMethod();
  String path();
  String url() {
    Uri uri;
    var pathStr = path();
    if (pathParams != null) {
      if (path().endsWith('/')) {
        pathStr = '${path()}$pathParams';
      } else {
        pathStr = '${path()}/$pathParams';
      }
    }
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, pathParams);
    } else {
      uri = Uri.http(authority(), pathStr, pathParams);
    }
    if (needLogin()) {
      //给需要登录的接口携带登录令牌
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    return uri.toString();
  }

  bool needLogin();

  Map<String, String> params = {};

  /// 添加参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = {
    'course-flag': 'fa',
    //访问令牌，在课程公告获取
    // "auth-token": "MjAyMC0wNi0yMyAwMzoyNTowMQ==fa",
  };
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
