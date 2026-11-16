import 'dart:typed_data';

import 'package:custom_dio/custom_dio.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
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
              const SizedBox(height: 20),
              TextButton(onPressed: getAll, child: const Text("getAll")),
              const SizedBox(height: 20),
              TextButton(onPressed: post, child: const Text("post")),
              const SizedBox(height: 20),
              TextButton(onPressed: getOne, child: const Text("getOne")),
              const SizedBox(height: 20),
              TextButton(
                onPressed: getByFilter,
                child: const Text("getByFilter"),
              ),
              const SizedBox(height: 20),
              TextButton(onPressed: delete, child: const Text("delete")),
              const SizedBox(height: 20),
              TextButton(onPressed: update, child: const Text("update")),
              const SizedBox(height: 20),
              TextButton(
                onPressed: uploadFile,
                child: const Text("Upload File"),
              ),
              const SizedBox(height: 20),
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
        body: {"content": "post content"},
      );
      dLog(data.data.toString());
    } catch (err) {
      dErrorLog(err.toString());
    }
  }

  Future getOne() async {
    try {
      final data = await CustomDio().send(
        reqMethod: "get",
        path: "dio-test/154",
      );
      dLog(data.data.toString());
    } catch (err) {
      dErrorLog(err.toString());
    }
  }

  Future delete() async {
    try {
      final data = await CustomDio().send(
        reqMethod: "delete",
        path: "dio-test/1",
      );
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
        query: {"query": "query of get by filter"},
      );
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
        body: {"content": "update content"},
      );
      dLog(data.data.toString());
    } catch (err) {
      dErrorLog(err.toString());
    }
  }

  Future uploadFile() async {
    try {
      final picker = ImagePicker();
      final img = await picker.pickImage(source: ImageSource.gallery);
      if (img == null) return;
      final extension = img.name.contains('.')
          ? img.name.split('.').last
          : 'bin';
      final data = await CustomDio().uploadBytes(
        path: 'dio-test/file',
        bytes: await img.readAsBytes(),
        bytesExtension: extension,
        body: [
          {'content': 'data'},
        ],
      );
      if (!mounted) return;
      dLog(data.data.toString());
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
        ],
      );

      return data.data.toString();
    } catch (err) {
      dErrorLog(err.toString());
      rethrow;
    }
  }

  void dLog(String data) {
    if (!mounted) return;
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Info", style: TextStyle(fontSize: 30)),
          content: Text(data, style: const TextStyle(fontSize: 25)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void dErrorLog(String data) {
    if (!mounted) return;
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Error", style: TextStyle(fontSize: 30)),
          content: Text(data, style: const TextStyle(fontSize: 25)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
