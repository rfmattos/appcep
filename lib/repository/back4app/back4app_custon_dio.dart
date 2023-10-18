import 'package:appcep/repository/back4app/back4app_custon_interception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Back4AppCustonDio {
  final _dio = Dio();

  Dio get dio => _dio;

  Back4AppCustonDio() {
    _dio.options.headers["X-Parse-Application-Id"] =
        dotenv.get("BACK4APPAPPLICATIONID");
    _dio.options.headers["X-Parse-REST-API-Key"] =
        dotenv.get("BACK4APPRESTAPIKEY");
    _dio.options.headers["content-type"] = "application/json";
    _dio.options.baseUrl = dotenv.get("BACK4APPBASEURL");
//    'https://parseapi.back4app.com/classes';

    _dio.interceptors.add(Back4AppInterceptionDio());
  }
}
