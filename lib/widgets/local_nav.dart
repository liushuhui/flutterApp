import 'package:flutter/material.dart';
import 'package:flutter_app/model/common_model.dart';
import 'package:flutter_app/widgets/webview.dart';

class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavList;
  const LocalNav({super.key, required this.localNavList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: _items(context),
        ),
    );
  }
  _items(BuildContext context) {
    List<Widget> items = [];
    for (var model in localNavList) {
      items.add(_item(context, model));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items,
    );
  }
  Widget _item(BuildContext context, CommonModel model) {
      return GestureDetector(
        onTap: () {
          Navigator.push(context, 
            MaterialPageRoute(builder: (context) => 
              WebView(
                url: model.url, 
                statusBarColor: model.statusBarColor, 
                title: model.title, 
                hideAppBar: model.hideAppBar, 
               )
            )
          );
        },
        child: Column(
          children: <Widget>[
            Image.network(
              model.icon,
              width: 32,
              height: 32,
            ),
            Text(
              model.title,
              style: const TextStyle(fontSize: 12),
            )
          ]
          ),
      );
  }
}