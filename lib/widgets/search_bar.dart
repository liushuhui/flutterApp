import 'package:flutter/material.dart';

enum SearchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {
  final bool enabled;
  final bool hideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final VoidCallback? leftButtonClick;
  final VoidCallback? rightButtonClick;
  final VoidCallback? speakClick;
  final VoidCallback? inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar(
      {super.key,
      this.enabled = true,
      this.hideLeft = false,
      this.searchBarType = SearchBarType.normal,
      this.hint = '',
      required this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputBoxClick,
      required this.onChanged});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // ignore: unnecessary_null_comparison
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _getNormalSearch()
        : _getHomeSearch();
  }

  _getNormalSearch() {
    return Container(
      child: Row(
        children: [
          _warpTap(
              Container(
                padding: const EdgeInsets.fromLTRB(6, 5, 10, 5),
                child: widget.hideLeft
                    ? null
                    : const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                        size: 26,
                      ),
              ),
              widget.leftButtonClick!),
          Expanded(
            child: _inputBox(),
            flex: 1,
          ),
          _warpTap(
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: const Text(
                  '搜索',
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
              ),
              widget.leftButtonClick!)
        ],
      ),
    );
  }

  _getHomeSearch() {
    return Container(
      child: Row(
        children: [
          _warpTap(
              Container(
                  padding: const EdgeInsets.fromLTRB(6, 5, 5, 5),
                  child: Row(
                    children: [
                      Text(
                        '成都',
                        style: TextStyle(color: _homeFontColor(), fontSize: 14),
                      ),
                      Icon(
                        Icons.expand_more,
                        color: _homeFontColor(),
                        size: 22,
                      )
                    ],
                  )),
              widget.leftButtonClick!),
          Expanded(
            child: _inputBox(),
            flex: 1,
          ),
          _warpTap(
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Icon(
                  Icons.comment,
                  color: _homeFontColor(),
                  size: 26,
                ),
              ),
              widget.leftButtonClick!)
        ],
      ),
    );
  }

  _warpTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        // ignore: unnecessary_null_comparison
        if (callback != null) callback();
      },
      child: child,
    );
  }

  _inputBox() {
    Color inputBoxColor;
    widget.searchBarType == SearchBarType.home
        ? inputBoxColor = Colors.white
        : inputBoxColor = Color(int.parse('0xffEDEDED'));
    return Container(
      height: 30.0,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: inputBoxColor,
          borderRadius: BorderRadius.circular(
              widget.searchBarType == SearchBarType.normal ? 5 : 15)),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal
                ? const Color(0xffA9A9A9)
                : Colors.blue,
          ),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal
                ? TextField(
                    controller: _controller,
                    onChanged: _onChanged,
                    autofocus: true,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.w300),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                        border: const OutlineInputBorder(
                            // 设置输入框文字垂直居中
                            borderSide: BorderSide.none),
                        hintText: widget.hint,
                        hintStyle: const TextStyle(fontSize: 15)),
                  )
                : _warpTap(
                    Container(
                      child: Text(
                        widget.defaultText,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                    widget.inputBoxClick!),
          ),
          !showClear
              ? _warpTap(
                  Icon(
                    Icons.mic,
                    size: 22,
                    color: widget.searchBarType == SearchBarType.normal
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  widget.speakClick!)
              : _warpTap(
                  const Icon(
                    Icons.clear,
                    size: 22,
                    color: Colors.grey,
                  ), () {
                  setState(() {
                    _controller.clear();
                  });
                  _onChanged('');
                })
        ],
      ),
    );
  }

  _onChanged(String text) {
    if (text.isNotEmpty) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    widget.onChanged(text);
  }

  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }
}
