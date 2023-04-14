import 'package:flutter_app/http/mock_request.dart';
import 'package:flutter_app/model/home_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
const HOME_URL = 'https://www.devio.org/io/flutter_app/json/home_page.json';
class HomeDao {
  static Future<HomeModel> fetch() async {
    final response = await http.get(Uri.parse(HOME_URL));
    if (response.statusCode == 200) {
      Utf8Decoder utf8Decoder = const Utf8Decoder(); // 修复中文乱码 
      var result = json.decode(utf8Decoder.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    } else {
      throw Exception('Failed to load json');
    }
    // final response = await MockRequest().mock('home');
    // return HomeModel.fromJson(response);
  }
}