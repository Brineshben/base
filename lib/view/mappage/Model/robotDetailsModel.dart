class robotDetailsModel {
  List<DebugLogs>? debugLogs;
  int? distanceTraveled;
  bool? emergencyStopActive;
  Goal? goal;
  int? goalDistance;
  bool? goalReached;
  int? goalReachedSeq;
  int? goalResendCount;
  int? lidarPoints;
  bool? mapReady;
  bool? mappingActive;
  int? navElapsed;
  String? navState;
  int? pathPoints;
  RobotPose? robotPose;
  String? robotPoseSource;
  bool? success;
  String? workflowMode;
  String? workflowRunning;
  String? workflowStatus;

  robotDetailsModel(
      {this.debugLogs,
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
        this.success,
        this.workflowMode,
        this.workflowRunning,
        this.workflowStatus});

  robotDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['debug_logs'] != null) {
      debugLogs = <DebugLogs>[];
      json['debug_logs'].forEach((v) {
        debugLogs!.add(new DebugLogs.fromJson(v));
      });
    }
    distanceTraveled = json['distance_traveled'];
    emergencyStopActive = json['emergency_stop_active'];
    goal = json['goal'] != null ? new Goal.fromJson(json['goal']) : null;
    goalDistance = json['goal_distance'];
    goalReached = json['goal_reached'];
    goalReachedSeq = json['goal_reached_seq'];
    goalResendCount = json['goal_resend_count'];
    lidarPoints = json['lidar_points'];
    mapReady = json['map_ready'];
    mappingActive = json['mapping_active'];
    navElapsed = json['nav_elapsed'];
    navState = json['nav_state'];
    pathPoints = json['path_points'];
    robotPose = json['robot_pose'] != null
        ? new RobotPose.fromJson(json['robot_pose'])
        : null;
    robotPoseSource = json['robot_pose_source'];
    success = json['success'];
    workflowMode = json['workflow_mode'];
    workflowRunning = json['workflow_running'];
    workflowStatus = json['workflow_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.debugLogs != null) {
      data['debug_logs'] = this.debugLogs!.map((v) => v.toJson()).toList();
    }
    data['distance_traveled'] = this.distanceTraveled;
    data['emergency_stop_active'] = this.emergencyStopActive;
    if (this.goal != null) {
      data['goal'] = this.goal!.toJson();
    }
    data['goal_distance'] = this.goalDistance;
    data['goal_reached'] = this.goalReached;
    data['goal_reached_seq'] = this.goalReachedSeq;
    data['goal_resend_count'] = this.goalResendCount;
    data['lidar_points'] = this.lidarPoints;
    data['map_ready'] = this.mapReady;
    data['mapping_active'] = this.mappingActive;
    data['nav_elapsed'] = this.navElapsed;
    data['nav_state'] = this.navState;
    data['path_points'] = this.pathPoints;
    if (this.robotPose != null) {
      data['robot_pose'] = this.robotPose!.toJson();
    }
    data['robot_pose_source'] = this.robotPoseSource;
    data['success'] = this.success;
    data['workflow_mode'] = this.workflowMode;
    data['workflow_running'] = this.workflowRunning;
    data['workflow_status'] = this.workflowStatus;
    return data;
  }
}

class DebugLogs {
  String? message;
  String? ts;

  DebugLogs({this.message, this.ts});

  DebugLogs.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    ts = json['ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['ts'] = this.ts;
    return data;
  }
}

class Goal {
  int? x;
  int? y;

  Goal({this.x, this.y});

  Goal.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}

class RobotPose {
  double? x;
  double? y;
  double? yawDeg;

  RobotPose({this.x, this.y, this.yawDeg});

  RobotPose.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
    yawDeg = json['yaw_deg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    data['yaw_deg'] = this.yawDeg;
    return data;
  }
}