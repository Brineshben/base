class CurrentConfigModel {
  final double? ageS;
  final Config? config;
  final String? raw;
  final bool? success;

  CurrentConfigModel({
    this.ageS,
    this.config,
    this.raw,
    this.success,
  });

  factory CurrentConfigModel.fromJson(Map<String, dynamic> json) {
    return CurrentConfigModel(
      ageS: (json['age_s'] as num?)?.toDouble(),
      config: json['config'] != null
          ? Config.fromJson(json['config'])
          : null,
      raw: json['raw'],
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age_s': ageS,
      'config': config?.toJson(),
      'raw': raw,
      'success': success,
    };
  }
}
class Config {
  final double? accelRpmPerSec;
  final bool? balanceEnabled;
  final double? balanceKp;
  final double? decelRpmPerSec;
  final bool? emergencyStopActive;
  final double? imuYawOffset;
  final double? maxAngularVelocity;
  final int? maxCorrectionRpm;
  final double? maxLinearVelocity;
  final int? maxRpm;
  final int? mode;
  final double? motorCommandTimeout;
  final double? publishRate;
  final bool? rampEnabled;
  final double? safeBalanceRatio;
  final double? timeoutSec;
  final bool? useImuYaw;

  Config({
    this.accelRpmPerSec,
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
    this.useImuYaw,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      accelRpmPerSec: (json['accel_rpm_per_sec'] as num?)?.toDouble(),
      balanceEnabled: json['balance_enabled'],
      balanceKp: (json['balance_kp'] as num?)?.toDouble(),
      decelRpmPerSec: (json['decel_rpm_per_sec'] as num?)?.toDouble(),
      emergencyStopActive: json['emergency_stop_active'],
      imuYawOffset: (json['imu_yaw_offset'] as num?)?.toDouble(),
      maxAngularVelocity: (json['max_angular_velocity'] as num?)?.toDouble(),
      maxCorrectionRpm: json['max_correction_rpm'],
      maxLinearVelocity: (json['max_linear_velocity'] as num?)?.toDouble(),
      maxRpm: json['max_rpm'],
      mode: json['mode'],
      motorCommandTimeout:
      (json['motor_command_timeout'] as num?)?.toDouble(),
      publishRate: (json['publish_rate'] as num?)?.toDouble(),
      rampEnabled: json['ramp_enabled'],
      safeBalanceRatio:
      (json['safe_balance_ratio'] as num?)?.toDouble(),
      timeoutSec: (json['timeout_sec'] as num?)?.toDouble(),
      useImuYaw: json['use_imu_yaw'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accel_rpm_per_sec': accelRpmPerSec,
      'balance_enabled': balanceEnabled,
      'balance_kp': balanceKp,
      'decel_rpm_per_sec': decelRpmPerSec,
      'emergency_stop_active': emergencyStopActive,
      'imu_yaw_offset': imuYawOffset,
      'max_angular_velocity': maxAngularVelocity,
      'max_correction_rpm': maxCorrectionRpm,
      'max_linear_velocity': maxLinearVelocity,
      'max_rpm': maxRpm,
      'mode': mode,
      'motor_command_timeout': motorCommandTimeout,
      'publish_rate': publishRate,
      'ramp_enabled': rampEnabled,
      'safe_balance_ratio': safeBalanceRatio,
      'timeout_sec': timeoutSec,
      'use_imu_yaw': useImuYaw,
    };
  }
}