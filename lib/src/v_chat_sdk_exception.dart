
class CustomDioException implements Exception {
  dynamic data;
  int code;

  CustomDioException(this.data, this.code);

  @override
  String toString() {
    return data;
  }
}
