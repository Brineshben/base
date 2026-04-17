class CurrentConfigModel {
  double? ageS;
  Config? config;
  String? raw;
  bool? success;

  CurrentConfigModel({this.ageS, this.config, this.raw, this.success});

  CurrentConfigModel.fromJson(Map<String, dynamic> json) {
    ageS = json['age_s'];
    config =
    json['config'] != null ? new Config.fromJson(json['config']) : null;
    raw = json['raw'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age_s'] = this.ageS;
    if (this.config != null) {
      data['config'] = this.config!.toJson();
    }
    data['raw'] = this.raw;
    data['success'] = this.success;
    return data;
  }
}

class Config {
  int? accelRpmPerSec;
  bool? balanceEnabled;
  double? balanceKp;
  int? decelRpmPerSec;
  bool? emergencyStopActive;
  int? imuYawOffset;
  int? maxAngularVelocity;
  int? maxCorrectionRpm;
  int? maxLinearVelocity;
  int? maxRpm;
  int? mode;
  double? motorCommandTimeout;
  int? publishRate;
  bool? rampEnabled;
  double? safeBalanceRatio;
  double? timeoutSec;
  bool? useImuYaw;

  Config(
      {this.accelRpmPerSec,
        this.balanceEnabled,
        this.balanceKp,
        this.decelRpmPerSec,
        this.emergencyStopActive,
        this.imuYawOffset,
        this.maxAngularVelocity,
        this.maxCorrectionRpm,
        this.maxLinearVelocity,
        this.maxRpm,
        this.mode,
        this.motorCommandTimeout,
        this.publishRate,
        this.rampEnabled,
        this.safeBalanceRatio,
        this.timeoutSec,
        this.useImuYaw});

  Config.fromJson(Map<String, dynamic> json) {
    accelRpmPerSec = json['accel_rpm_per_sec'];
    balanceEnabled = json['balance_enabled'];
    balanceKp = json['balance_kp'];
    decelRpmPerSec = json['decel_rpm_per_sec'];
    emergencyStopActive = json['emergency_stop_active'];
    imuYawOffset = json['imu_yaw_offset'];
    maxAngularVelocity = json['max_angular_velocity'];
    maxCorrectionRpm = json['max_correction_rpm'];
    maxLinearVelocity = json['max_linear_velocity'];
    maxRpm = json['max_rpm'];
    mode = json['mode'];
    motorCommandTimeout = json['motor_command_timeout'];
    publishRate = json['publish_rate'];
    rampEnabled = json['ramp_enabled'];
    safeBalanceRatio = json['safe_balance_ratio'];
    timeoutSec = json['timeout_sec'];
    useImuYaw = json['use_imu_yaw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accel_rpm_per_sec'] = this.accelRpmPerSec;
    data['balance_enabled'] = this.balanceEnabled;
    data['balance_kp'] = this.balanceKp;
    data['decel_rpm_per_sec'] = this.decelRpmPerSec;
    data['emergency_stop_active'] = this.emergencyStopActive;
    data['imu_yaw_offset'] = this.imuYawOffset;
    data['max_angular_velocity'] = this.maxAngularVelocity;
    data['max_correction_rpm'] = this.maxCorrectionRpm;
    data['max_linear_velocity'] = this.maxLinearVelocity;
    data['max_rpm'] = this.maxRpm;
    data['mode'] = this.mode;
    data['motor_command_timeout'] = this.motorCommandTimeout;
    data['publish_rate'] = this.publishRate;
    data['ramp_enabled'] = this.rampEnabled;
    data['safe_balance_ratio'] = this.safeBalanceRatio;
    data['timeout_sec'] = this.timeoutSec;
    data['use_imu_yaw'] = this.useImuYaw;
    return data;
  }
}