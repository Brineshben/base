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
  }

  ///mapService
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


  ///mapService
  static Future<Map<String, dynamic>> poiList() async {
    String url = "${ApiConstants.baseURL}${ApiConstants.poiList}";
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
  ///currentValue
  static Future<Map<String, dynamic>> currentValue() async {
    String url = "${ApiConstants.baseURL}${ApiConstants.currentValue}";
    print("Url.currentValue...$url");
    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll({'Content-Type': 'application/json'});
      http.StreamedResponse response = await request.send();

      var respString = await response.stream.bytesToString();
      print("Url.currentValue..$respString");
      return json.decode(respString);
    } catch (e) {
      throw Exception("Service Error Login Api");
    }
  }
  ///delete
  static Future<Map<String, dynamic>> delete(int id ) async {
    String url = "${ApiConstants.baseURL}${ApiConstants.poiList}/$id";
    print("delete...$url");
    try {
      var request = http.Request('DELETE', Uri.parse(url));
      request.headers.addAll({'Content-Type': 'application/json'});
      http.StreamedResponse response = await request.send();

      var respString = await response.stream.bytesToString();
      print("delete..$respString");
      return json.decode(respString);
    } catch (e) {
      throw Exception("Service Error Login Api");
    }
  }


  ///add POi
  static Future<Map<String, dynamic>> emergency({required bool name}) async {
    String url = "${ApiConstants.baseURL}${ApiConstants.emergency}";
    print("Url....$url");
    Map apiBody = {"value": name,};
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
  }


  ///add POi
  static Future<Map<String, dynamic>> addPoi({required String name,required double x,required double y,required double yaw,}) async {
    String url = "${ApiConstants.baseURL}${ApiConstants.poiList}";
    print("Url....$url");
    Map apiBody = {"name": name,"x": x,"y": y,"yaw_deg": yaw,
    };
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
  }

  ///add POi
  static Future<Map<String, dynamic>> navigate({required int id}) async {
    String url = "${ApiConstants.baseURL}/pois/$id/navigate";
    print("Url....$url");

    try {
      var request = http.Request('POST', Uri.parse(url));
      request.headers.addAll({'Content-Type': 'application/json'});
      http.StreamedResponse response = await request.send();

      var respString = await response.stream.bytesToString();
      print("Url....$respString");
      return json.decode(respString);
    } catch (e) {
      throw Exception("Service Error Login Api");
    }
  }
  ///Edit POi
  static Future<Map<String, dynamic>> editPoi({required String name,required double x,required double y,required double yaw,required int id}) async {
    String url = "${ApiConstants.baseURL}${ApiConstants.poiList}/$id";
    print("Url....$url");
    Map apiBody = {"name": name,"x": x,"y": y,"yaw_deg": yaw,
    };
    try {
      var request = http.Request('PUT', Uri.parse(url));
      request.body = (json.encode(apiBody));
      request.headers.addAll({'Content-Type': 'application/json'});
      http.StreamedResponse response = await request.send();

      var respString = await response.stream.bytesToString();
      print("Url....$respString");
      return json.decode(respString);
    } catch (e) {
      throw Exception("Service Error Login Api");
    }
  }
}