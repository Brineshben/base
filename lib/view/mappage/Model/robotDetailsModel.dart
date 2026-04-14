class robotDetailsModel {
  List<DebugLogs>? debugLogs;
  double? distanceTraveled;
  bool? emergencyStopActive;
  dynamic goal; // safer
  double? goalDistance;
  bool? goalReached;
  int? goalReachedSeq;
  int? goalResendCount;
  int? lidarPoints;
  bool? mapReady;
  bool? mappingActive;
  double? navElapsed;
  String? navState;
  int? pathPoints;
  RobotPose? robotPose;
  String? robotPoseSource;
  String? workflowMode;
  String? workflowRunning;   // FIXED
  String? workflowStatus;    // FIXED

  robotDetailsModel({
    this.debugLogs,
    this.distanceTraveled,
    this.emergencyStopActive,
    this.goal,
    this.goalDistance,
    this.goalReached,
    this.goalReachedSeq,
    this.goalResendCount,
    this.lidarPoints,
    this.mapReady,
    this.mappingActive,
    this.navElapsed,
    this.navState,
    this.pathPoints,
    this.robotPose,
    this.robotPoseSource,
    this.workflowMode,
    this.workflowRunning,
    this.workflowStatus,
  });

  factory robotDetailsModel.fromJson(Map<String, dynamic> json) {
    return robotDetailsModel(
      debugLogs: (json['debug_logs'] as List?)
          ?.map((v) => DebugLogs.fromJson(v))
          .toList(),

      distanceTraveled:
      (json['distance_traveled'] as num?)?.toDouble(),
      emergencyStopActive: json['emergency_stop_active'],
      goal: json['goal'], // dynamic
      goalDistance:
      (json['goal_distance'] as num?)?.toDouble(),

      goalReached: json['goal_reached'],

      goalReachedSeq: json['goal_reached_seq'],

      goalResendCount: json['goal_resend_count'],

      lidarPoints: json['lidar_points'],

      mapReady: json['map_ready'],

      mappingActive: json['mapping_active'],

      navElapsed:
      (json['nav_elapsed'] as num?)?.toDouble(),

      navState: json['nav_state'],

      pathPoints: json['path_points'],

      robotPose: json['robot_pose'] != null
          ? RobotPose.fromJson(json['robot_pose'])
          : null,

      robotPoseSource: json['robot_pose_source'],

      workflowMode: json['workflow_mode'],

      workflowRunning: json['workflow_running'], // FIXED

      workflowStatus: json['workflow_status'],   // FIXED
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'debug_logs': debugLogs?.map((v) => v.toJson()).toList(),
      'distance_traveled': distanceTraveled,
      'emergency_stop_active': emergencyStopActive,
      'goal': goal,
      'goal_distance': goalDistance,
      'goal_reached': goalReached,
      'goal_reached_seq': goalReachedSeq,
      'goal_resend_count': goalResendCount,
      'lidar_points': lidarPoints,
      'map_ready': mapReady,
      'mapping_active': mappingActive,
      'nav_elapsed': navElapsed,
      'nav_state': navState,
      'path_points': pathPoints,
      'robot_pose': robotPose?.toJson(),
      'robot_pose_source': robotPoseSource,
      'workflow_mode': workflowMode,
      'workflow_running': workflowRunning,
      'workflow_status': workflowStatus,
    };
  }
}

class DebugLogs {
  String? message;
  String? ts;

  DebugLogs({this.message, this.ts});

  factory DebugLogs.fromJson(Map<String, dynamic> json) {
    return DebugLogs(
      message: json['message'],
      ts: json['ts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'ts': ts,
    };
  }
}

class RobotPose {
  double? x;
  double? y;
  double? yawDeg;

  RobotPose({this.x, this.y, this.yawDeg});

  factory RobotPose.fromJson(Map<String, dynamic> json) {
    return RobotPose(
      x: (json['x'] as num?)?.toDouble(),
      y: (json['y'] as num?)?.toDouble(),
      yawDeg: (json['yaw_deg'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'yaw_deg': yawDeg,
    };
  }
}