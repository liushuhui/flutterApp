import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoAppPage extends StatefulWidget {
  const PhotoAppPage({super.key});

  @override
  State<PhotoAppPage> createState() => _PhotoAppPageState();
}

class _PhotoAppPageState extends State<PhotoAppPage> {
  File? _image;
  final picker = ImagePicker();
  Future getImage(bool isTakePhoto) async {
    final pickedFile = await picker.getImage(source: isTakePhoto ? ImageSource.camera : ImageSource.gallery);
    print('pickedFile: $pickedFile');

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _getImage() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 160,
              child: Column(
                children: <Widget>[
                  _item('拍照', true),
                  _item('从相册中选择', false),
                ],
              ),
            ));
  }

  _item(String title, bool isTakePhoto) {
    return GestureDetector(
      child: ListTile(
        leading: Icon(isTakePhoto ? Icons.camera_alt : Icons.photo_library),
        title: Text(title),
        onTap: () => getImage(isTakePhoto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null
            ? const Text('No image selected.')
            : Image.file(_image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        tooltip: '选择图片',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
