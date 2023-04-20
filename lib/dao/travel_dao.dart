import 'package:flutter_app/model/travel_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
const HOME_URL = 'http://www.devio.org/io/flutter_app/json/travel_page.json';
Map<String, dynamic> Params = {
  "districtId": -1,
  "groupChannelCode": "RX-OMF",
  "type": null,
  "lat": -180,
  "lon": -180,
  "locatedDistrictId": 0,
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirection": 0
  },
  "imageCutType": 1,
  "head": {'cid': "09031014111431397988"},
  "contentType": "json"
};

class TravalDao {
  static Future<TravelItemModel> fetch(
      String url, String groupChannelCode, int pageIndex, int pageSize) async {
    Map<String, dynamic> paramsMap = Params['pagePara'];
    paramsMap['pageIndex'] = pageIndex;
    paramsMap['pageSize'] = pageSize;
    Params['groupChannelCode'] = groupChannelCode;
    final response = await http.post(Uri.parse(url), body: jsonEncode(Params));
    if (response.statusCode == 200) {
      Utf8Decoder utf8Decoder = const Utf8Decoder(); // 修复中文乱码
      var result = json.decode(utf8Decoder.convert(response.bodyBytes));
      return TravelItemModel.fromJson(result);
    } else {
      throw Exception('Failed to load json');
    }
  }
}
