import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'custom_dio_options.dart';
import 'v_chat_sdk_exception.dart';
import 'package:path/path.dart';

CustomDioOptions? options;

class CustomDio {
  late Dio _dio;

  CustomDio({bool enableLog = false}) {
    if (options == null) {
      throw "Make sure to call CustomDio.setInitData() before you submit request";
    }
    _dio = Dio();
    _dio.options.baseUrl = options!.baseUrl;
    _dio.options.validateStatus = (_) => true;
    _dio.options.followRedirects = options!.followRedirects;
    _dio.options.headers = options!.headers;
    _dio.options.sendTimeout = options!.sendTimeout;
    _dio.options.receiveTimeout = options!.receiveTimeout;
    _dio.options.connectTimeout = options!.connectTimeout;
    _dio.interceptors.addAll(options!.interceptorsList);
    if (!options!.isProductionMode) {
      if (options!.logAllData || enableLog) {
        _dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          maxWidth: 100,
        ));
      }
    }
  }

  /// init the package
  static void setInitData(CustomDioOptions dioOptions) {
    options = dioOptions;
  }

  ///upload file
  Future<Response> uploadFile({
    required String path,
    required String filePath,
    bool isPost = true,
    void Function(int received, int total)? sendProgress,
    List<Map<String, String>>? body,
    CancelToken? cancelToken,
  }) async {
    final File file = File(filePath);
    final fileName = basename(file.path);
    final FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    if (body != null) {
      final x = body.map((e) => MapEntry(e.keys.first, e.values.first));
      data.fields.addAll(x);
    }
    late Response response;
    if (isPost) {
      response = await _dio.post(path,
          data: data, onSendProgress: sendProgress, cancelToken: cancelToken);
    } else {
      response = await _dio.patch(path,
          data: data, onSendProgress: sendProgress, cancelToken: cancelToken);
    }

    _throwIfNoSuccess(response);
    return response;
  }

  ///upload file bytes
  Future<Response> uploadBytes(
      {required String path,
      required Uint8List bytes,
      void Function(int received, int total)? sendProgress,
      List<Map<String, String>>? body,
      bool isPost = true,
      required String bytesExtension,
      bool loading = false,
      CancelToken? cancelToken}) async {
    try {
      final FormData data = FormData.fromMap({
        "file": MultipartFile.fromBytes(bytes,
            filename:
                "${DateTime.now().microsecondsSinceEpoch}.$bytesExtension"),
      });

      if (body != null) {
        final x = body.map((e) => MapEntry(e.keys.first, e.values.first));
        data.fields.addAll(x);
      }
      late Response response;
      if (isPost) {
        response = await _dio.post(path,
            data: data, onSendProgress: sendProgress, cancelToken: cancelToken);
      } else {
        response = await _dio.patch(path,
            data: data, onSendProgress: sendProgress, cancelToken: cancelToken);
      }

      _throwIfNoSuccess(response);
      return response;
    } catch (err) {
      rethrow;
    }
  }

  Future<Response> uploadFiles(
      {required String path,
      required List<DioUploadFileModel> filesModel,
      void Function(int received, int total)? sendProgress,
      List<Map<String, String>>? body,
      CancelToken? cancelToken}) async {
    final mapOfData = <String, dynamic>{};
    for (final file in filesModel) {
      final _file = File(file.filePath);
      final fileName = basename(_file.path);
      mapOfData.addAll({
        file.fileFiledName: await MultipartFile.fromFile(
          _file.path,
          filename: fileName,
        ),
      });
    }
    final formData = FormData.fromMap(mapOfData);

    if (body != null) {
      final x = body.map((e) => MapEntry(e.keys.first, e.values.first));
      formData.fields.addAll(x);
    }
    final Response response = await _dio.post(path,
        data: formData, onSendProgress: sendProgress, cancelToken: cancelToken);
   _throwIfNoSuccess(response);
    return response;
  }

  /// send any type of request GET POST PUT PATCH DELETE DOWNLOAD
  Future<Response> send(
      {required String reqMethod,
      required String path,
      Function(int count, int total)? onSendProgress,
      Function(int count, int total)? onReceiveProgress,
      CancelToken? cancelToken,
      Map<String, dynamic> body = const <String, dynamic>{},
      Map<String, dynamic> query = const <String, dynamic>{},
      String? saveDirPath}) async {
    late Response res;

    final _body = {}..addAll(body);
    final _query = {}..addAll(query);

    try {
      switch (reqMethod.toUpperCase()) {
        case 'GET':
          res = await _dio.get(
            path,
            cancelToken: cancelToken,
            queryParameters: _query.cast(),
          );
          break;
        case 'POST':
          res = await _dio.post(
            path,
            data: _body.cast(),
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
            cancelToken: cancelToken,
            queryParameters: _query.cast(),
          );
          break;
        case 'PUT':
          res = await _dio.put(
            path,
            data: _body.cast(),
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            cancelToken: cancelToken,
            queryParameters: _query.cast(),
          );
          break;
        case 'PATCH':
          res = await _dio.patch(
            path,
            data: _body.cast(),
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            cancelToken: cancelToken,
            queryParameters: _query.cast(),
          );
          break;
        case 'DELETE':
          res = await _dio.delete(
            path,
            data: _body.cast(),
            cancelToken: cancelToken,
            queryParameters: _query.cast(),
          );
          break;

        case 'DOWNLOAD':
          res = await _dio.download(
            path,
            saveDirPath,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
            queryParameters: _query.cast(),
          );

          break;
        default:
          throw ("reqMethod Not available ! ");
      }

      _throwIfNoSuccess(res);

      return res;
    } on DioError catch (err) {
      if (err.type == DioErrorType.other ||
          err.type == DioErrorType.connectTimeout ||
          err.type == DioErrorType.receiveTimeout ||
          err.type == DioErrorType.sendTimeout) {
        throw CustomDioException(
            "Bad Network Or Server Not available now", 500);
      }
      rethrow;
    } finally {
      _dio.close();
    }
  }

  void _throwIfNoSuccess(Response response) {
    if (response.statusCode! > 300) {
      if (options!.errorPath == null) {}
      if (options!.errorPath != null) {
        final errorMsg = response.data[options!.errorPath].toString();
        throw CustomDioException(errorMsg, response.statusCode ?? 500);
      }
      final errorMsg = response.data;
      throw CustomDioException(errorMsg, response.statusCode ?? 500);
    }
  }
}

class DioUploadFileModel {
  final String filePath;
  final String fileFiledName;

  const DioUploadFileModel(
      {required this.filePath, required this.fileFiledName});
}
