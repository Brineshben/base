import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controller/CurrentConfigController.dart';
import 'MotorConfigurations.dart';
import 'otpPage.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final CurrentConfigController controller =
  Get.put(CurrentConfigController());

  @override
  Widget build(BuildContext context) {
    controller.currentConfigDataz();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Robot Settings",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isError.value) {
          return const Center(
            child: Text("Error loading data",
                style: TextStyle(color: Colors.red)),
          );
        }

        final data = controller.currentConfigData.value;

        if (data == null) {
          return const Center(
            child: Text("No Data", style: TextStyle(color: Colors.white)),
          );
        }

        final config = data.config;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// AGE CARD
              _buildCard(
                title: "System Age",
                value: "${data.ageS} sec",
                icon: Icons.timer,
                color: Colors.blue,
              ),

              const SizedBox(height: 12),

              /// MODE CARD
              _buildCard(
                title: "Mode",
                value: _getMode(config?.mode ?? 0),
                icon: Icons.settings,
                color: Colors.orange,
              ),

              const SizedBox(height: 12),

              /// SPEED CARD
              _buildCard(
                title: "Max Linear Velocity",
                value: "${config?.maxLinearVelocity}",
                icon: Icons.speed,
                color: Colors.green,
              ),

              const SizedBox(height: 12),

              /// RPM CARD
              _buildCard(
                title: "Max RPM",
                value: "${config?.maxRpm}",
                icon: Icons.rotate_right,
                color: Colors.purple,
              ),

              const SizedBox(height: 12),

              /// BALANCE CARD
              _buildCard(
                title: "Balance Enabled",
                value: (config?.balanceEnabled ?? false) ? "YES" : "NO",
                icon: Icons.balance,
                color: Colors.teal,
              ),

              const SizedBox(height: 12),

              /// EMERGENCY STOP
              _buildCard(
                title: "Emergency Stop",
                value: (config?.emergencyStopActive ?? false)
                    ? "ACTIVE"
                    : "OFF",
                icon: Icons.warning,
                color: Colors.red,
              ), /// EMERGENCY STOP
              const SizedBox(height: 12),

              _buildClickableCard(
                title: "Motor and velocity control settings",
                value: "120 RPM",
                icon: Icons.speed,
                color: Colors.green,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OtpScreen();
                  },));
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  /// 🔥 Stylish Card Widget
  Widget _buildCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildClickableCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: color.withOpacity(0.2),
        highlightColor: color.withOpacity(0.1),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),

              const SizedBox(width: 16),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Value


              // Arrow Icon (gives button feel)
              Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 26),
            ],
          ),
        ),
      ),
    );
  }
  /// 🔥 Mode Mapping
  String _getMode(int mode) {
    switch (mode) {
      case 1:
        return "Manual";
      case 2:
        return "Auto 1";
      case 3:
        return "Auto 2";
      default:
        return "Unknown";
    }
  }
}