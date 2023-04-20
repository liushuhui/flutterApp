// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_app/dao/travel_dao.dart';
import 'package:flutter_app/model/travel_model.dart';
import 'package:flutter_app/widgets/loading_container.dart';
import 'package:flutter_app/widgets/webview.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const PAGE_SIZE = 10;
const _TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

class TravelTabPage extends StatefulWidget {
  final String travelUrl;
  final String groupChannelCode;
  const TravelTabPage(
      {super.key, required this.travelUrl, required this.groupChannelCode});

  @override
  State<TravelTabPage> createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage>
    with AutomaticKeepAliveClientMixin {
  List<TravelItem> travelItems = [];
  int pageIndex = 1;
  bool _loading = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoadingContainer(
            isLoading: _loading,
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: StaggeredGridView.countBuilder(
                    controller: _scrollController,
                    crossAxisCount: 4,
                    itemCount: travelItems.length ?? 0,
                    itemBuilder: (BuildContext context, int index) =>
                        _TravelItem(index: index, item: travelItems[index]),
                    staggeredTileBuilder: (int index) =>
                        const StaggeredTile.fit(2),
                  )),
            )));
  }

  void _loadData({loadMore = false}) {
    loadMore ? pageIndex++ : pageIndex = 1;
    TravalDao.fetch(widget.travelUrl ?? _TRAVEL_URL, widget.groupChannelCode,
            pageIndex, PAGE_SIZE)
        .then((TravelItemModel model) {
      _loading = false;
      setState(() {
        List<TravelItem> items = _filterItems(model.resultList!);
        if (travelItems != null) {
          travelItems.addAll(items);
        } else {
          travelItems = items;
        }
      });
    }).catchError((e) {
      _loading = false;
      print('loaddata: $e');
    });
  }

  List<TravelItem> _filterItems(List<TravelItem> resultList) {
    if (resultList == null) {
      return [];
    }
    List<TravelItem> filterItems = [];
    for (var element in resultList) {
      if (element.article != null) {
        filterItems.add(element);
      }
    }
    return filterItems;
  }

  @override
  bool get wantKeepAlive => true;

  // ignore: prefer_void_to_null
  Future<Null> _handleRefresh() async {
    _loadData();
    return null;
  }
}

class _TravelItem extends StatelessWidget {
  final TravelItem item;
  final int index;

  const _TravelItem({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.article?.urls != null && item.article!.urls!.isNotEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebView(
                        url: item.article?.urls?[0].h5Url ?? '',
                        title: '详情',
                      )));
        }
      },
      child: Card(
        child: PhysicalModel(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _itemImage(),
            Container(
              padding: const EdgeInsets.all(4),
              child: Text(
                item.article!.articleTitle!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            _infoText(),
          ]),
        ),
      ),
    );
  }

  _itemImage() {
    return Stack(
      children: [
        Image.network(item.article!.images![0].dynamicUrl!),
        Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 3),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  LimitedBox(
                    maxWidth: 130,
                    child: Text(
                      _poiName(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }

  String _poiName() {
    return item.article?.pois == null || item.article!.pois!.isEmpty
        ? '未知'
        : item.article?.pois?[0].poiName ?? '未知';
  }

  _infoText() {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.article!.author!.coverImage!.dynamicUrl!,
                  height: 24,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                width: 90,
                child: Text(
                  item.article!.author!.nickName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.thumb_up,
                size: 14,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Text(
                  item.article!.likeCount.toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
