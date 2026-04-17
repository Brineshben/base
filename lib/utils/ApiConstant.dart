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
  static String emergency = "/emergency_stop";
  static String currentConfig = "/current_config";
  static String speed = "/max_rpm";
  static String mode = "/mode";
  static String mapName = "/map_name";
  static String mapList = "/list_maps";
  static String delete = "/delete_map";
  static String rename = "/rename_map";
}