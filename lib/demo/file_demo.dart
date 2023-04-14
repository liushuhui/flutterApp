import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileDemo extends StatefulWidget {
  const FileDemo({super.key});

  @override
  State<FileDemo> createState() => _FileDemoState();
}

class _FileDemoState extends State<FileDemo> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    //从文件读取点击次数
    _readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });

  }

  Future<File> _getLocalFile() async {
    // 获取应用文件目录
    String dir = (await getApplicationDocumentsDirectory()).path;
    print('dir: $dir');
    return File('$dir/counter.txt');
  }

  Future<int> _readCounter() async {
    try {
      File file = await _getLocalFile();
      //读取点击文件次数
      String contents = await file.readAsString();
      print('contents: $contents');
      return int.parse(contents);
    } on FileSystemException {
      return 0;
    }
  }
  _incrementCounter() async {
    setState(() {
      _counter++;
    });
    // 将点击次数以字符串类型写到文件中
    await (await _getLocalFile()).writeAsString('$_counter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('文件操作')),
      body: Center(
        child: Text('点击了 $_counter 次'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}