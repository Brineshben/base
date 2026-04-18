import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/ApiConstant.dart';

class ApiServices {
  static final ApiServices _instance = ApiServices._internal();

  ApiServices._internal();

  factory ApiServices() {
    return _instance;
  }

  ///mapService
  static Future<Map<String, dynamic>> mapService({
    required String value,
  }) async {
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



  // static Future<Map<String, dynamic>> poiList() async {
  //   print("POI URL 👉 ");
  //
  //   try {
  //     /// ✅ Get saved data
  //         print("POI URL 👉 ");
  //     final prefs = await SharedPreferences.getInstance();
  //     final int? id = prefs.getInt('map_id');
  //     final String? name = prefs.getString('map_name');
  //     //
  //     // if (id == null || name == null) {
  //     //   throw Exception("Map ID or Name not found in SharedPreferences");
  //     // }
  //
  //     /// ✅ Build URL properly
  //     String url =
  //         "${ApiConstants.baseURL}/pois?id=$id&map_name=$name";
  //
  //     print("POI URL 👉 $url");
  //
  //     var request = http.Request('GET', Uri.parse(url));
  //     request.headers.addAll({
  //       'Content-Type': 'application/json'
  //     });
  //
  //     http.StreamedResponse response = await request.send();
  //
  //     var respString = await response.stream.bytesToString();
  //
  //     print("POI RESPONSE 👉 $respString");
  //
  //     return json.decode(respString);
  //   } catch (e) {
  //     throw Exception("POI API Error: $e");
  //   }
  // }
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

  ///currentcONFIG
  static Future<Map<String, dynamic>> currentConfig() async {
    String url = "${ApiConstants.baseURL}${ApiConstants.currentConfig}";
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

  ///MapList
  static Future<Map<String, dynamic>> mapList() async {
    String url = "${ApiConstants.baseURL}${ApiConstants.mapList}";
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

  ///speed post
  static Future<Map<String, dynamic>> speedPost({required String value}) async {
    String url = "${ApiConstants.baseURL}${ApiConstants.speed}";
    print("Url....$url");
    Map apiBody = {"data": value};
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

  ///speed post
  static Future<Map<String, dynamic>> renameMap({
    required String value,
    required int id,
  }) async {
    String url = "${ApiConstants.baseURL}${ApiConstants.rename}";
    print("renameMap....$url");
    Map apiBody = {"id": id, "name": value};
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      request.headers.addAll({'Content-Type': 'application/json'});
      http.StreamedResponse response = await request.send();

      var respString = await response.stream.bytesToString();
      print("renameMap....$respString");
      return json.decode(respString);
    } catch (e) {
      throw Exception("Service Error Login Api");
    }
  }

  // ///speed post
  // static Future<Map<String, dynamic>> deleteMap({required String value,required int id }) async {
  //   String url = "${ApiConstants.baseURL}${ApiConstants.speed}";
  //   print("Url....$url");
  //   Map apiBody = {
  //     "id": id,
  //     "name":value
  //   };
  //   try {
  //     var request = http.Request('DELETE', Uri.parse(url));
  //     request.body = (json.encode(apiBody));
  //     request.headers.addAll({'Content-Type': 'application/json'});
  //     http.StreamedResponse response = await request.send();
  //
  //     var respString = await response.stream.bytesToString();
  //     print("Url.dfwerfer...$respString");
  //     return json.decode(respString);
  //   } catch (e) {
  //     throw Exception("Service Error Login Api");
  //   }
  // }
  static Future<Map<String, dynamic>> deleteMap({
    required String value,
    required int id,
  }) async {
    String url = "${ApiConstants.baseURL}${ApiConstants.delete}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"id": id, "name": value}),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"success": false};
      }
    } catch (e) {
      return {"success": false};
    }
  }

  ///

  ///delete
  static Future<Map<String, dynamic>> delete(int id) async {
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
    Map apiBody = {"active": name};
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
  static Future<Map<String, dynamic>> mode({required int name}) async {
    String url = "${ApiConstants.baseURL}${ApiConstants.mode}";
    print("Url....$url");
    Map apiBody = {"data": name};
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

  ///Save Map Name
  static Future<Map<String, dynamic>> mapName({required String name}) async {
    String url = "${ApiConstants.baseURL}${ApiConstants.mapName}";
    print("mapName....$url");
    Map apiBody = {"name": name};
    try {
      var request = http.Request('POST', Uri.parse(url));
      request.body = (json.encode(apiBody));
      request.headers.addAll({'Content-Type': 'application/json'});
      http.StreamedResponse response = await request.send();

      var respString = await response.stream.bytesToString();
      print("mapName....$respString");
      return json.decode(respString);
    } catch (e) {
      throw Exception("Service Error Login Api");
    }
  }
  ///mapService
  static Future<Map<String, dynamic>> poiList() async {
    try {
      /// 🔹 Step 1: Call robot details API
      final robotData = await robotdetails();

      bool isMapReady =
          robotData["workflow_mode"]?.toString() == "mapping_navigation" ||
              robotData["workflow_mode"]?.toString() == "mapping";
      print("MAP READY 👉 $isMapReady");

      /// 🔹 Step 2: Get saved data
      final prefs = await SharedPreferences.getInstance();
      final int? id = prefs.getInt('map_id');
      final String? name = prefs.getString('map_name');
      if (id == null || name == null) {
        throw Exception("Map ID or Name not found in SharedPreferences");
      }

      /// 🔹 Step 3: Build URL based on condition
      String url;

      if (isMapReady) {
        url = "${ApiConstants.baseURL}/pois?id=0&map_name=pois_temp";

      } else {
        url = "${ApiConstants.baseURL}/pois?id=$id&map_name=$name";
      }

      print("POI URL 👉 $url");

      /// 🔹 Step 4: API Call
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll({'Content-Type': 'application/json'});

      http.StreamedResponse response = await request.send();
      var respString = await response.stream.bytesToString();

      print("POI RESPONSE 👉 $respString");

      return json.decode(respString);
    } catch (e) {
      throw Exception("POI API Error: $e");
    }
  }
  ///add POi
  static Future<Map<String, dynamic>> addPoi({
    required String name,
    required double x,
    required double y,
    required double yaw,
  }) async {
    final robotData = await robotdetails();

    bool isMapReady =
        robotData["workflow_mode"]?.toString() == "mapping_navigation" ||
            robotData["workflow_mode"]?.toString() == "mapping";
    print("MAP READY 👉 $isMapReady");

    /// 🔹 Step 2: Get saved data
    final prefs = await SharedPreferences.getInstance();
    final int? id = prefs.getInt('map_id');
    final String? name = prefs.getString('map_name');
    if (id == null || name == null) {
      throw Exception("Map ID or Name not found in SharedPreferences");
    }

    /// 🔹 Step 3: Build URL based on condition
    String url;

    if (isMapReady) {
      url = "${ApiConstants.baseURL}/pois?id=0&map_name=pois_temp";

    } else {
      url = "${ApiConstants.baseURL}/pois?id=$id&map_name=$name";
    }

    // String url = "${ApiConstants.baseURL}${ApiConstants.poiList}";
    print("Url....$url");
    Map apiBody = {"name": name, "x": x, "y": y, "yaw_deg": yaw};
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
  static Future<Map<String, dynamic>> navigate({required int ids}) async {
    final robotData = await robotdetails();

    // bool isMapReady =
    //     robotData["workflow_mode"]?.toString() == "mapping_navigation" ||
    //         robotData["workflow_mode"]?.toString() == "mapping";
    // print("MAP READY 👉 $isMapReady");

    /// 🔹 Step 2: Get saved data
    final prefs = await SharedPreferences.getInstance();
    final int? id = prefs.getInt('map_id');
    final String? name = prefs.getString('map_name');
    if (id == null || name == null) {
      throw Exception("Map ID or Name not found in SharedPreferences");
    }

    /// 🔹 Step 3: Build URL based on condition

    String url = "${ApiConstants.baseURL}/pois/$ids/navigate?id=$id&map_name=$name";
    print("Urldcgsrf....$url");

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
  static Future<Map<String, dynamic>> editPoi({
    required String name,
    required double x,
    required double y,
    required double yaw,
    required int id,
  }) async {
    String url = "${ApiConstants.baseURL}${ApiConstants.poiList}/$id";
    print("Url....$url");
    Map apiBody = {"name": name, "x": x, "y": y, "yaw_deg": yaw};
    try {
      var request = http.Request('PUT', Uri.parse(url));
      request.body = (json.encode(apiBody));
      request.headers.addAll({'Content-Type': 'application/json'});
      http.StreamedResponse response = await request.send();

      var respString = await response.stream.bytesToString();
      print("Url..dferfe..$respString");
      return json.decode(respString);
    } catch (e) {
      throw Exception("Service Error Login Api");
    }
  }

  static Future<bool> postData({
    required String endpoint,
    required dynamic value,
  }) async {
    try {
      final url = "http://192.168.1.199:5000$endpoint";

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"data": value}),
      );

      final body = jsonDecode(response.body);
      print("API endpointendpoint: $body");

      return body["success"] == true;
    } catch (e) {
      print("API ERROR: $e");
      return false;
    }
  }
}
