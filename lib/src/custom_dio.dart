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

  static void setInitData(CustomDioOptions dioOptions) {
    options = dioOptions;
  }

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

    throwIfNoSuccess(response);
    return response;
  }

  Future<Response> uploadBytes(
      {required String path,
      required Uint8List bytes,
      void Function(int received, int total)? sendProgress,
        List<Map<String, String>>? body,
        bool isPost = true,
      bool loading = false,
      CancelToken? cancelToken}) async {
    try {
      final FormData data = FormData.fromMap({
        "file": MultipartFile.fromBytes(bytes, filename: "xxx.png"),
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

      throwIfNoSuccess(response);
      return response;
    } catch (err) {
      rethrow;
    }
  }

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

      throwIfNoSuccess(res);

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
    }  finally {
      _dio.close();
    }
  }

  void throwIfNoSuccess(Response response) {
    if (response.statusCode! > 300) {
      if(options!.errorPath == null){

      }
      if(options!.errorPath!=null){
        final errorMsg = response.data[options!.errorPath].toString();
        throw CustomDioException(errorMsg, response.statusCode ?? 500);
      }
      final errorMsg = response.data;
      throw CustomDioException(errorMsg, response.statusCode ?? 500);
    }
  }
}
