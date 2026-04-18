import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/customWidget.dart';

class MotorConfigPage extends StatelessWidget {
  const MotorConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Motor Config",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 25,right: 25),
        child: Column(
          children: [

            /// ===== MOTOR =====
            configCard(title: "Decel RPM", endpoint: "/decel_rpm_per_sec", isBool: false, context: context),
            configCard(title: "Accel RPM", endpoint: "/accel_rpm_per_sec", isBool: false, context: context),
            configCard(title: "Accel RPM", endpoint: "/accel_rpm_per_sec", isBool: false, context: context),
            configCard(title: "Timeout Sec", endpoint: "/timeout_sec", isBool: false, context: context),
            configCard(title: "Safe Balance Ratio", endpoint: "/safe_balance_ratio", isBool: false, context: context),
            configCard(title: "Max Correction RPM", endpoint: "/max_correction_rpm", isBool: false, context: context),
            configCard(title: "Balance KP", endpoint: "/balance_kp", isBool: false, context: context),
            configCard(title: "Motor Command Timeout", endpoint: "/motor_command_timeout", isBool: false, context: context),
            configCard(title: "Publish Rate", endpoint: "/publish_rate", isBool: false, context: context),

            configCard(title: "Ramp Enabled", endpoint: "/ramp_enabled", isBool: true, context: context),
            configCard(title: "Balance Enabled", endpoint: "/balance_enabled", isBool: true, context: context),

            configCard(title: "Max Angular Velocity", endpoint: "/max_angular_velocity", isBool: false, context: context),
            configCard(title: "Max Linear Velocity", endpoint: "/max_linear_velocity", isBool: false, context: context),

            const SizedBox(height: 20),

            /// ===== IMU =====
            configCard(title: "Use IMU Yaw", endpoint: "/use_imu_yaw", isBool: true, context: context),
            configCard(title: "IMU Yaw Offset", endpoint: "/imu_yaw_offset", isBool: false, context: context),
          ],
        ),
      ),
    );
  }
}