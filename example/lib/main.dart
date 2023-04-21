import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<File> _files = [];
  String error = "";

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> init() async {
    /// uri can be of android scheme content or file
    /// for iOS PHAsset identifier is supported as well

    List<Asset> assets = await selectImagesFromGallery();
    List<File> files = [];
    for (Asset asset in assets) {
      if (asset.identifier != null) {
        final filePath =
            await FlutterAbsolutePath.getAbsolutePath(asset.identifier!);
        files.add(File(filePath));
      }
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _files = files;
    });
  }

  Future<List<Asset>> selectImagesFromGallery() async {
    await [Permission.camera, Permission.photos, Permission.storage].request();

    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: resultList,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: const MaterialOptions(),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  await init();
                },
                child: const Text('Select Images')),
            Center(
              child: Text('$error Running on: $_files\n'),
            ),
          ],
        ),
      ),
    );
  }
}
