import 'dart:io';
import 'dart:typed_data';
import 'package:custom_dio/custom_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              TextButton(onPressed: getAll, child: Text("getAll")),
              const  SizedBox(
                height: 20,
              ),
              TextButton(onPressed: post, child: Text("post")),
              const   SizedBox(
                height: 20,
              ),
              TextButton(onPressed: getOne, child: Text("getOne")),
              const   SizedBox(
                height: 20,
              ),
              TextButton(onPressed: getByFilter, child: Text("getByFilter")),
              const  SizedBox(
                height: 20,
              ),
              TextButton(onPressed: delete, child: Text("delete")),
              const  SizedBox(
                height: 20,
              ),
              TextButton(onPressed: update, child: Text("update")),
              const  SizedBox(
                height: 20,
              ),
              TextButton(onPressed: uploadFile, child: Text("Upload File")),
              const  SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getAll() async {
    try {
      final data = await CustomDio().send(reqMethod: "get", path: "dio-test");
      dLog(data.data.toString());
    } catch (err) {
      dErrorLog(err.toString());
    }
  }

  Future post() async {
    try {
      final data = await CustomDio().send(
          reqMethod: "post",
          path: "dio-test",
          body: {"content": "post content"});
      dLog(data.data.toString());
    } catch (err) {
      dErrorLog(err.toString());
    }
  }

  Future getOne() async {
    try {
      final data =
      await CustomDio().send(reqMethod: "get", path: "dio-test/154");
      dLog(data.data.toString());
    } catch (err) {
      dErrorLog(err.toString());
    }
  }

  Future delete() async {
    try {
      final data =
      await CustomDio().send(reqMethod: "delete", path: "dio-test/1");
      dLog(data.data.toString());
    } catch (err) {
      dErrorLog(err.toString());
    }
  }

  Future getByFilter() async {
    try {
      final data = await CustomDio().send(
          reqMethod: "get",
          path: "dio-test/filter",
          query: {"query": "query of get by filter"});
      dLog(data.data.toString());
    } catch (err) {
      dErrorLog(err.toString());
    }
  }

  Future update() async {
    try {
      final data = await CustomDio().send(
          reqMethod: "patch",
          path: "dio-test",
          body: {"content": "update content"});
      dLog(data.data.toString());
    } catch (err) {
      dErrorLog(err.toString());
    }
  }

  Future uploadFile() async {
    try {
      final picker = ImagePicker();
      final img = await picker.getImage(source: ImageSource.gallery);
      if (img != null) {
        final data = await CustomDio()
            .uploadFiles(path: "dio-test/file", filesModel: [
          DioUploadFileModel(filePath: img.path, fileFiledName: "file"),
          DioUploadFileModel(filePath: img.path, fileFiledName: "file"),
        ], body: [
          {"content": "data"}
        ]);
        dLog(data.data.toString());

        ///upload using file bytes
        //final data = await uploadBytes(File(img.path).readAsBytesSync());
        ///upload files using file path
        // final data = await CustomDio()
        //     .uploadFiles(apiEndPoint: "dio-test/file", filesModel: [
        //   DioUploadFileModel(filePath: img.path, fileFiledName: "file"),
        //   DioUploadFileModel(filePath: img.path, fileFiledName: "file"),
        // ], body: [
        //   {"content": "sd"},
        //   {"attachments": "attachments"},
        // ]);

        // dLog(data.data.toString());
      }
    } catch (err) {
      dErrorLog(err.toString());
    }
  }

  Future<String> uploadBytes(Uint8List bytes) async {
    try {
      final data = await CustomDio().uploadBytes(
          path: "dio-test/file",
          bytesExtension: "png",
          bytes: bytes,
          body: [
            {"content": "sd"},
            {"attachments": "attachments"},
          ]);

      return data.data.toString();
    } catch (err) {
      dErrorLog(err.toString());
      rethrow;
    }
  }

  void dLog(String data) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Info",
            style: TextStyle(fontSize: 30),
          ),
          content: Text(
            data,
            style: TextStyle(fontSize: 25),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("OK"))
          ],
        );
      },
    );
  }

  void dErrorLog(String data) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Error",
            style: TextStyle(fontSize: 30),
          ),
          content: Text(
            data,
            style: TextStyle(fontSize: 25),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("OK"))
          ],
        );
      },
    );
  }
}