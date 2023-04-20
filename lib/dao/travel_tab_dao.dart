import 'package:flutter_app/model/home_model.dart';
import 'package:flutter_app/model/travel_tab_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
const HOME_URL = 'http://www.devio.org/io/flutter_app/json/travel_page.json';

class TravalTabDao {
  static Future<TravelTabModel> fetch() async {
    final response = await http.get(Uri.parse(HOME_URL));
    if (response.statusCode == 200) {
      Utf8Decoder utf8Decoder = const Utf8Decoder(); // 修复中文乱码 
      var result = json.decode(utf8Decoder.convert(response.bodyBytes));
      return TravelTabModel.fromJson(result);
    } else {
      throw Exception('Failed to load json');
    }
  }
}