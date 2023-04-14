import 'package:flutter_app/model/search_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
class SearchDao {
  static Future<SearchModel> fetch(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Utf8Decoder utf8Decoder = const Utf8Decoder(); // 修复中文乱码 
      var result = json.decode(utf8Decoder.convert(response.bodyBytes));
      return SearchModel.fromJson(result);
    } else {
      throw Exception('Failed to load json');
    }
    // final response = await MockRequest().mock('home');
    // return HomeModel.fromJson(response);
  }
}