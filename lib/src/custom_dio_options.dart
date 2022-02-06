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

  CustomDioOptions copyWith({
    Map<String, String>? headers,
    bool? followRedirects,
    bool? isProductionMode,
    String? baseUrl,
    String? errorPath,
    HttpClientAdapter? adapter,
    int? sendTimeout,
    List<Interceptor>? interceptorsList,
    int? receiveTimeout,
    int? connectTimeout,
    bool? logAllData,
  }) {
    return CustomDioOptions(
      headers: headers ?? this.headers,
      followRedirects: followRedirects ?? this.followRedirects,
      isProductionMode: isProductionMode ?? this.isProductionMode,
      baseUrl: baseUrl ?? this.baseUrl,
      errorPath: errorPath ?? this.errorPath,
      adapter: adapter ?? this.adapter,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      interceptorsList: interceptorsList ?? this.interceptorsList,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      logAllData: logAllData ?? this.logAllData,
    );
  }
}
