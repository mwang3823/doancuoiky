import 'package:dio/dio.dart';

class CustomInterceptor extends Interceptor {
  static final String url="http://192.168.1.4:8181";
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      // print("${"Data: " + response.data} - Status Message: ${response.statusMessage}");
    }
    handler.next(response);
  }
}

