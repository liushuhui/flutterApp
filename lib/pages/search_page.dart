import 'package:flutter/material.dart';
import 'package:flutter_app/dao/search_dao.dart';
import 'package:flutter_app/model/search_model.dart';
import 'package:flutter_app/widgets/search_bar.dart';
import 'package:flutter_app/widgets/webview.dart';

const URL =
    'https://m.ctrip.com/restapi/h5api/globalsearch/search?source=mobileweb&action=mobileweb&keyword=';

const TYPES = [
  'channelgroup',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];
class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchLUrl;
  final String keyword;
  final String hint;

  const SearchPage(
      {super.key,
      required this.hideLeft,
      this.keyword = '',
      this.hint = '',
      this.searchLUrl = URL});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String showText = '';
  late SearchModel searchModel = SearchModel(data: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: <Widget>[
          _appBar(),
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Expanded(
              flex: 1,
              child: ListView.builder(
                  itemCount: searchModel?.data?.length ?? 0,
                  itemBuilder: (BuildContext context, int position) {
                    return _item(position);
                  }),
            ),
          ),
          Text(showText)
        ],
      ),
    );
  }

  _onTextChange(text) async {
    try {
      showText = text;
      String url = widget.searchLUrl + text;
      SearchModel result = await SearchDao.fetch(url, text);
      if (result.keyword == showText) {
        setState(() {
          searchModel = result;
        });
      }
    } catch (e) {
      print('searchDao: $e');
    }
  }

  _item(int position) {
    // ignore: unnecessary_null_comparison
    if (searchModel == null || searchModel.data == null) return null;
    SearchItem item = searchModel.data[position];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => WebView(
              url: item.url,
              title: '详情',
              )
            )
          );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(1),
              child: Image(
                height: 26,
                width: 26,
                image: AssetImage(_typeImage(item.type)),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 300,
                  child: _title(item),
                ),
                Container(
                  width: 300,
                  margin: const EdgeInsetsDirectional.only(top: 5),
                  child: _subTitle(item),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  _typeImage(String type) {
    // ignore: unnecessary_null_comparison
    if (type == null) return 'images/type_travelgroup.png';
    String path = 'travelgroup';
    for ( final val in TYPES) {
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'images/type_$path.png';
  }
  _title(SearchItem item) {
    // ignore: unnecessary_null_comparison
    if (item == null) return null;
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word, searchModel.keyword));
    spans.add(TextSpan(
      text: '  ${item.districtname ?? ''}  ${item.zonename ?? ''}',
      style: const TextStyle(fontSize: 16, color: Colors.grey)
      ));

    return RichText(text: TextSpan(children: spans));
  }
  _subTitle(SearchItem item) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: item.price ?? '',
            style: const TextStyle(fontSize: 16, color: Colors.orange)
          ),
          TextSpan(
            text: '  ${item.star ?? ''}',
            style: const TextStyle(fontSize: 12, color: Colors.grey)
          ),
        ]
      )
      );
  }
  _keywordTextSpans(String word, keyword) {
    List<TextSpan> spans = [];
    // ignore: unnecessary_null_comparison
    if (word == null || word.isEmpty) return spans;
    List<String> arr = word.split(keyword);
    TextStyle normalStyle = const TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = const TextStyle(fontSize: 16, color: Colors.orange);
    for (int i = 0; i < arr.length; i++) {
      if ((i+1) % 2 == 0) {
        spans.add((TextSpan(text: keyword, style: keywordStyle)));
      }
      String val = arr[i];
      if (val != null && val.isNotEmpty) {
        spans.add((TextSpan(text: val, style: normalStyle)));
      }
    }
    return spans;
  }
  _appBar() {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Container(
            height: 80,
            decoration: const BoxDecoration(color: Colors.white),
            child: SearchBar(
                hideLeft: widget.hideLeft,
                hint: widget.hint,
                defaultText: widget.keyword,
                leftButtonClick: () {
                  Navigator.pop(context);
                },
                speakClick: () {},
                onChanged: _onTextChange),
          ),
        )
      ],
    );
  }
}
