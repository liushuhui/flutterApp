import 'package:flutter/material.dart';
import 'package:flutter_app/model/common_model.dart';
import 'package:flutter_app/model/grid_nav_model.dart';
import 'package:flutter_app/widgets/webview.dart';

class GridNav extends StatelessWidget {
  final GridModel gridNavModel;
  final String name;
  const GridNav({
    super.key,
    required this.gridNavModel,
    this.name = 'xxxx',
  });

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }

  _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    // ignore: unnecessary_null_comparison
    if (gridNavModel == null) return items;
    items.add(_gridNavItem(context, gridNavModel.hotel, true));
    items.add(_gridNavItem(context, gridNavModel.flight, false));
    items.add(_gridNavItem(context, gridNavModel.travel, false));
    return items;
  }

  Widget _gridNavItem(
      BuildContext context, GridNavItem gridNavItem, bool isFirst) {
    final items = [
      _mainItem(context, gridNavItem.mainItem),
      _doubleItem(context, gridNavItem.item1, gridNavItem.item2),
      _doubleItem(context, gridNavItem.item3, gridNavItem.item4),
    ];

    final expandItems =
        items.map((item) => Expanded(child: item, flex: 1)).toList();

    final startColor =
        Color(int.parse('0xff${gridNavItem.startColor ?? 'ffffff'}'));
    final endColor =
        Color(int.parse('0xff${gridNavItem.endColor ?? 'ffffff'}'));

    return Container(
      height: 88,
      margin: isFirst ? null : const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [startColor, endColor]),
      ),
      child: Row(children: expandItems),
    );
  }

  _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(
        context,
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Image.network(
              model.icon,
              fit: BoxFit.contain,
              height: 88,
              width: 121,
              alignment: AlignmentDirectional.bottomEnd,
            ),
            Container(
              margin: const EdgeInsets.only(top: 11),
              child: Text(
                model.title,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            )
          ],
        ),
        model);
  }

  _doubleItem(
    BuildContext context,
    CommonModel topItem,
    CommonModel bottomItem,
  ) {
    return Column(
      children: [
        Expanded(child: _item(context, topItem, true)),
        Expanded(child: _item(context, bottomItem, false)),
      ],
    );
  }

  _item(BuildContext context, CommonModel item, bool first) {
    BorderSide borderSide = const BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                left: borderSide,
                bottom: first ? borderSide : BorderSide.none)),
        child: _wrapGesture(
            context,
            Center(
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            item),
      ),
    );
  }

  _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebView(
                      url: model.url,
                      statusBarColor: model.statusBarColor,
                      title: model.title,
                      hideAppBar: model.hideAppBar,
                    )));
      },
      child: widget,
    );
  }
}
