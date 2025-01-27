import "dart:convert";

import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smees/api/end_points.dart";


class DioClien {
  static Dio dio = Dio();
  static const baseUrl = "http://localhost:8000/";
  static const loginEndPoint = "/auth/login";
}

class TokenManager extends Interceptor {
  static final TokenManager _instance = TokenManager._internal();
  static TokenManager get instance => _instance;

  TokenManager._internal();
  String? _token;
  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.statusCode == 200) {
      var data = Map<String, dynamic>.from(response.data);
      if (data['set-token'] != null) {
        saveToken(data['token']);
      }
    } else if (response.statusCode == 401) {
      // clearToken();
    }
    super.onResponse(response, handler);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers['Token'] = _token;
    return super.onRequest(options, handler);
  }

  Future<void> initToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("access_token");
  }

  void saveToken(String newToken) async {
    debugPrint('new token $newToken');
    if (_token != newToken) {
      _token = newToken;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", _token!);
    }
  }
}
