import 'package:flutter/material.dart';
import 'package:flutter_app/dao/search_dao.dart';
import 'package:flutter_app/model/search_model.dart';
import 'package:flutter_app/widgets/search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String showText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SearchBar(
              hideLeft: true,
              hint: '123',
              defaultText: '哈哈',
              leftButtonClick: () {
                Navigator.pop(context);
              },
              speakClick: () {},
              onChanged: _onTextChange),
          InkWell(
            onTap: () async {
              final SearchModel model = await SearchDao.fetch(
                  'https://m.ctrip.com/restapi/h5api/globalsearch/search?source=mobileweb&action=mobileweb&keyword=长城');
              setState(() {
                showText = model.data[0].url;
              });
            },
            child: const Text('get'),
          ),
          Text(showText)
        ],
      ),
    );
  }

  _onTextChange(text) {}
}
