import 'package:flutter/material.dart';
import 'package:flutter_app/dao/home_dao.dart';
import 'package:flutter_app/model/common_model.dart';
import 'package:flutter_app/model/grid_nav_model.dart';
import 'package:flutter_app/model/home_model.dart';
import 'package:flutter_app/model/sales_box_model.dart';
import 'package:flutter_app/widgets/grid_nav.dart';
import 'package:flutter_app/widgets/loading_container.dart';
import 'package:flutter_app/widgets/local_nav.dart';
import 'package:flutter_app/widgets/sales_box.dart';
import 'package:flutter_app/widgets/search_bar.dart';
import 'package:flutter_app/widgets/sub_nav.dart';
import 'package:flutter_app/widgets/webview.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';

// ignore: constant_identifier_names
const APPBAR_SCROLL_OFFSET = 100;
// ignore: constant_identifier_names
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 没事';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double appBarAlpha = 0;
  String resultString = '';
  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
  List<CommonModel> bannerList = [];
  late GridModel gridNavList;
  late SalesBoxModel salesBox;
  bool _isLoading = true;

  _onScroll(double offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    // alpha < 0 ? alpha = 0 : alpha = 1;
    setState(() {
      appBarAlpha = alpha;
    });
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  // ignore: prefer_void_to_null
  Future<Null> _onRefresh() async {
    try {
      final HomeModel model = await HomeDao.fetch();
      setState(() {
        resultString = json.encode(model.config);
        localNavList = model.localNavList;
        subNavList = model.subNavList;
        gridNavList = model.gridNav;
        salesBox = model.salesBox;
        bannerList = model.bannerList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        resultString = e.toString();
        _isLoading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfff2f2f2),
        body: LoadingContainer(
            isLoading: _isLoading,
            child: Stack(
              children: [
                MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification.depth == 0) {
                          _onScroll(scrollNotification.metrics.pixels);
                        }
                        return false;
                      },
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 160,
                            child: Swiper(
                              itemCount: bannerList.length,
                              autoplay: true,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      CommonModel model = bannerList[index];
                                      return WebView(
                                        url: model.url,
                                        statusBarColor: model.statusBarColor,
                                        title: model.title,
                                        hideAppBar: model.hideAppBar,
                                      );
                                    }));
                                  },
                                  child: Image.network(
                                    bannerList[index].icon,
                                    fit: BoxFit.fill,
                                  ),
                                );
                              },
                              pagination: const SwiperPagination(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
                            child: LocalNav(localNavList: localNavList),
                          ),
                          // ignore: unnecessary_null_comparison
                          Padding(
                            padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
                            child: GridNav(gridNavModel: gridNavList),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
                            child: SubNav(subNavList: subNavList),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
                            child: SalesBox(salesBox: salesBox),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                _appBar,
              ],
            )));
  }

  Widget get _appBar {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  // AppBar渐变遮罩背景
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 80.0,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: SearchBar(
                searchBarType: appBarAlpha > 1.2
                    ? SearchBarType.homeLight
                    : SearchBarType.home,
                inputBoxClick: _jumpToSearch,
                speakClick: _jumpToSpeak,
                defaultText: SEARCH_BAR_DEFAULT_TEXT,
                leftButtonClick: () {},
                onChanged: (text) {}),
          ),
        ),
        Container(
          height: appBarAlpha > 1.2 ? 0.5 : 0,
          decoration: const BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
        )
      ],
    );
  }

  _jumpToSearch() {}
  _jumpToSpeak() {}
}
