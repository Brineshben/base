class ApiConstants {
  static final ApiConstants _instance = ApiConstants._internal();

  ApiConstants._internal();

  factory ApiConstants() {
    return _instance;
  }
  static String baseURL = "http://192.168.1.199:5000";
  static String buttons = "/workflow_cmd";
  static String robotDetails = "/telemetry";
  static String poiList = "/pois";
  static String currentValue = "/current_pose";
}