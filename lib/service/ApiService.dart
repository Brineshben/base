import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/ApiConstant.dart';

class ApiServices {
  static final ApiServices _instance = ApiServices._internal();

  ApiServices._internal();

  factory ApiServices() {
    return _instance;
  }
  ///mapService
  static Future<Map<String, dynamic>> mapService({required String value}) async {
    String url = "${ApiConstants.baseURL}${ApiConstants.buttons}";
    print("Url....$url");
    Map apiBody = {"command": value};
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      request.headers.addAll({'Content-Type': 'application/json'});
      http.StreamedResponse response = await request.send();

      var respString = await response.stream.bytesToString();
      print("Url....$respString");
      return json.decode(respString);
    } catch (e) {
      throw Exception("Service Error Login Api");
    }
  }///mapService
  static Future<Map<String, dynamic>> robotdetails() async {
    String url = "${ApiConstants.baseURL}${ApiConstants.robotDetails}";
    print("Url.dwsfgergf...$url");
    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll({'Content-Type': 'application/json'});
      http.StreamedResponse response = await request.send();

      var respString = await response.stream.bytesToString();
      print("Url.dwsfgergf..$respString");
      return json.decode(respString);
    } catch (e) {
      throw Exception("Service Error Login Api");
    }
  }
}