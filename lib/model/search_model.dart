///搜索模型
class SearchModel {
  String? keyword;
  final List<SearchItem> data;
 SearchModel( { required this.data});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    var dataJson = json['data'] as List;
    List<SearchItem> data =
        dataJson.map((i) => SearchItem.fromJson(i)).toList();
    return SearchModel(data: data);
  }
}

class SearchItem {
  final String word; //xx酒店
  final String type; //hotel
  final String price; //实时计价
  final String star; //豪华型
  final String zonename; //虹桥
  final String districtname; //上海
  final String url;

  SearchItem(
      {
      required this.word,
      required this.type,
      required this.price,
      required this.star,
      required this.zonename,
      required this.districtname,
      required this.url});

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      word: json['word'],
      type: json['type'],
      price: json['price'],
      star: json['star'],
      zonename: json['zonename'],
      districtname: json['districtname'],
      url: json['url'],
    );
  }
}
