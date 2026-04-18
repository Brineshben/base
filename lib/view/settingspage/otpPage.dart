import 'package:flutter/material.dart';

import 'MotorConfigurations.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> controllers =
  List.generate(4, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
  List.generate(4, (_) => FocusNode());

  String defaultPin = "4321";

  void verifyOtp() {
    String enteredPin =
    controllers.map((e) => e.text).join();

    if (enteredPin == defaultPin) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MotorConfigPage();
      },));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Access Granted"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Invalid PIN"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildOtpBox(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 60,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade800),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: TextField(
          controller: controllers[index],
          focusNode: focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              FocusScope.of(context)
                  .requestFocus(focusNodes[index + 1]);
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context)
                  .requestFocus(focusNodes[index - 1]);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                color: Colors.white,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                "Enter PIN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Secure access verification",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                List.generate(4, (index) => buildOtpBox(index)),
              ),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: verifyOtp,
                child: Container(
                  width: 650,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.deepPurple,
                        Colors.blueAccent
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "VERIFY",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),


            ],
          ),
        ),
      ),
    );
  }
}