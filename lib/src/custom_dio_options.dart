import 'package:dio/dio.dart';

class CustomDioOptions {
  Map<String, String>? headers;

  bool followRedirects;
  bool isProductionMode;

  final String baseUrl;
  final String? errorPath;

  HttpClientAdapter? adapter;
  late int sendTimeout;
  late List<Interceptor> interceptorsList;

  late int receiveTimeout;

  late int connectTimeout;

  late bool logAllData;

  CustomDioOptions({
    this.headers,
    this.isProductionMode = true,
    this.followRedirects = true,
    this.errorPath,
    required this.baseUrl,
    this.adapter,
    this.interceptorsList = const [],
    this.sendTimeout = 15000,
    this.receiveTimeout = 15000,
    this.connectTimeout = 15000,
    this.logAllData = false,
  });
}
