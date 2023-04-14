import 'package:flutter/material.dart';

const city = [
  "北京市",
  "天津市",
  "上海市",
  "重庆市",
  "石家庄市",
  "张家口市",
  "承德市",
  "秦皇岛市",
  "唐山市",
  "廊坊市",
  "保定市",
  "衡水市",
  "沧州市",
  "邢台市",
  "邯郸市",
  "太原市",
  "朔州市",
  "大同市",
  "阳泉市",
  "长治市",
  "晋城市",
  "忻州市",
  "晋中市",
  "临汾市",
  "吕梁市",
  "运城市",
  "呼和浩特市",
  "包头市",
  "乌海市",
  "赤峰市",
  "通辽市",
  "呼伦贝尔市",
  "鄂尔多斯市",
  "乌兰察布市",
  "巴彦淖尔市",
  "兴安盟",
  "锡林郭勒盟",
  "阿拉善盟",
  "沈阳市",
  "朝阳市",
  "阜新市",
  "铁岭市",
  "抚顺市",
  "本溪市",
  "辽阳市",
  "鞍山市",
  "丹东市",
  "大连市",
  "营口市",
  "盘锦市",
  "锦州市",
  "葫芦岛市",
  "长春市",
  "白城市",
  "松原市",
  "吉林市",
  "四平市",
  "辽源市",
  "通化市",
  "白山市",
  "延边州",
  "哈尔滨市",
  "齐齐哈尔市",
  "七台河市",
  "黑河市",
  "大庆市",
  "鹤岗市",
  "伊春市",
  "佳木斯市",
  "双鸭山市",
  "鸡西市",
  "牡丹江市",
  "绥化市",
  "大兴安岭地区",
  "南京市",
  "徐州市",
  "连云港市",
  "宿迁市",
  "淮安市",
  "盐城市",
  "扬州市",
  "泰州市",
  "南通市",
  "镇江市",
  "常州市",
  "无锡市",
  "苏州市",
  "杭州市",
  "湖州市",
  "嘉兴市",
  "舟山市",
  "宁波市",
  "绍兴市",
  "衢州市",
  "金华市",
  "台州市",
  "温州市",
  "丽水市"
];
const cities = {
  '河北省': [
    '石家庄市',
    '唐山市',
    '秦皇岛市',
    '邯郸市',
    '邢台市',
    '保定市',
    '张家口市',
    '承德市',
    '沧州市',
    '廊坊市',
    '衡水市'
  ],
  '山西省': [
    '太原市',
    '大同市',
    '阳泉市',
    '长治市',
    '晋城市',
    '朔州市',
    '晋中市',
    '运城市',
    '忻州市',
    '临汾市',
    '吕梁市'
  ],
  '内蒙古自治区': [
    '呼和浩特市',
    '包头市',
    '乌海市',
    '赤峰市',
    '通辽市',
    '鄂尔多斯市',
    '呼伦贝尔市',
    '巴彦淖尔市',
    '乌兰察布市',
    '兴安盟',
    '锡林郭勒盟',
    '阿拉善盟'
  ],
  '辽宁省': [
    '沈阳市',
    '大连市',
    '鞍山市',
    '抚顺市',
    '本溪市',
    '丹东市',
    '锦州市',
    '营口市',
    '阜新市',
    '辽阳市',
    '盘锦市',
    '盘锦市',
    '朝阳市',
    '葫芦岛市'
  ]
};

class ListViewDemo extends StatefulWidget {
  const ListViewDemo({super.key});

  @override
  State<ListViewDemo> createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('list'),
      ),
      body: ListView(
        children: _buildList(),
      ),
    );
  }

  List<Widget> _buildList() {
    List<Widget> widgets = [];
    cities.keys.forEach((element) {
      widgets.add(_item(element, cities[element]!));
    });
    print('widgets: $widgets');

    return widgets;
  }

  Widget _item(String city, List<String> sub) {
    return ExpansionTile(
      title: Text(city, style: const TextStyle(color: Colors.black54, fontSize: 20),),
      children: sub.map((item) => _buildSub(item)).toList(),
    );
  }
  Widget _buildSub(String subCity) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        height: 50,
        alignment: AlignmentDirectional.center,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: const BoxDecoration(color: Colors.lightBlueAccent),
        child: Text(subCity),
      ),
    );
  }
}
