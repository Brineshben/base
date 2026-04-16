class robotDetailsModel {
  final List<DebugLog> debugLogs;
  final double distanceTraveled;
  final bool emergencyStopActive;
  final Goal goal;
  final double goalDistance;
  final bool goalReached;
  final int goalReachedSeq;
  final int goalResendCount;
  final int lidarPoints;
  final bool mapReady;
  final bool mappingActive;
  final double navElapsed;
  final String navState;
  final int pathPoints;
  final RobotPose robotPose;
  final String robotPoseSource;
  final bool success;
  final String workflowMode;
  final String workflowRunning;
  final String workflowStatus;

  robotDetailsModel({
    required this.debugLogs,
    required this.distanceTraveled,
    required this.emergencyStopActive,
    required this.goal,
    required this.goalDistance,
    required this.goalReached,
    required this.goalReachedSeq,
    required this.goalResendCount,
    required this.lidarPoints,
    required this.mapReady,
    required this.mappingActive,
    required this.navElapsed,
    required this.navState,
    required this.pathPoints,
    required this.robotPose,
    required this.robotPoseSource,
    required this.success,
    required this.workflowMode,
    required this.workflowRunning,
    required this.workflowStatus,
  });

  factory robotDetailsModel.fromJson(Map<String, dynamic> json) {
    return robotDetailsModel(
      debugLogs: (json['debug_logs'] as List)
          .map((e) => DebugLog.fromJson(e))
          .toList(),
      distanceTraveled: (json['distance_traveled'] as num).toDouble(),
      emergencyStopActive: json['emergency_stop_active'] as bool,
      goal: Goal.fromJson(json['goal']),
      goalDistance: (json['goal_distance'] as num).toDouble(),
      goalReached: json['goal_reached'] as bool,
      goalReachedSeq: (json['goal_reached_seq'] as num).toInt(),
      goalResendCount: (json['goal_resend_count'] as num).toInt(),
      lidarPoints: (json['lidar_points'] as num).toInt(),
      mapReady: json['map_ready'] as bool,
      mappingActive: json['mapping_active'] as bool,
      navElapsed: (json['nav_elapsed'] as num).toDouble(),
      navState: json['nav_state'] as String,
      pathPoints: (json['path_points'] as num).toInt(),
      robotPose: RobotPose.fromJson(json['robot_pose']),
      robotPoseSource: json['robot_pose_source'] as String,
      success: json['success'] as bool,
      workflowMode: json['workflow_mode'] as String,
      workflowRunning: json['workflow_running'] as String,
      workflowStatus: json['workflow_status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'debug_logs': debugLogs.map((e) => e.toJson()).toList(),
    'distance_traveled': distanceTraveled,
    'emergency_stop_active': emergencyStopActive,
    'goal': goal.toJson(),
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
    'robot_pose': robotPose.toJson(),
    'robot_pose_source': robotPoseSource,
    'success': success,
    'workflow_mode': workflowMode,
    'workflow_running': workflowRunning,
    'workflow_status': workflowStatus,
  };
}

class DebugLog {
  final String message;
  final String ts;

  DebugLog({required this.message, required this.ts});

  factory DebugLog.fromJson(Map<String, dynamic> json) {
    return DebugLog(
      message: json['message'] as String,
      ts: json['ts'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'ts': ts,
  };
}

class Goal {
  final double x;
  final double y;

  Goal({required this.x, required this.y});

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
}

class RobotPose {
  final double x;
  final double y;
  final double yawDeg;

  RobotPose({required this.x, required this.y, required this.yawDeg});

  factory RobotPose.fromJson(Map<String, dynamic> json) {
    return RobotPose(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      yawDeg: (json['yaw_deg'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
    'yaw_deg': yawDeg,
  };
}