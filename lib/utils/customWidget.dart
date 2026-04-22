import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../service/ApiService.dart';

void showRpmDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => const RpmVolumeDialog(),
  );
}

class RpmVolumeDialog extends StatefulWidget {
  const RpmVolumeDialog({super.key});

  @override
  State<RpmVolumeDialog> createState() => _RpmVolumeDialogState();
}

class _RpmVolumeDialogState extends State<RpmVolumeDialog> {
  int currentRpm = 0;
  int initialRpm = 0;
  int step = 1;

  bool isPosting = false;
  bool isLoading = true;

  String statusMsg = '';
  bool isSuccess = false;

  final int maxRpm = 100;

  @override
  void initState() {
    super.initState();
    _loadInitialValue();
  }

  /// 🔹 GET API CALL
  Future<void> _loadInitialValue() async {
    try {
      final resp = await ApiServices.currentConfig();

      print("API RESPONSE: $resp"); // 🔍 debug

      if (resp['success'] == true && resp['config'] != null) {
        final config = resp['config'];

        /// ✅ SAFE PARSING (handles int + double + null)
        final rpmValue = config['max_rpm'];

        int parsedRpm;

        if (rpmValue is int) {
          parsedRpm = rpmValue;
        } else if (rpmValue is double) {
          parsedRpm = rpmValue.toInt();
        } else {
          parsedRpm = int.tryParse(rpmValue.toString()) ?? 10;
        }

        setState(() {
          currentRpm = parsedRpm;
          initialRpm = parsedRpm;
        });

        print("RPM SET: $currentRpm"); // 🔍 debug
      } else {
        setState(() {
          currentRpm = 10;
          initialRpm = 10;
        });
      }
    } catch (e) {
      print("ERROR: $e");

      setState(() {
        currentRpm = 10;
        initialRpm = 10;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _changeValue(int direction) {
    setState(() {
      currentRpm = (currentRpm + direction * step).clamp(0, maxRpm);
      statusMsg = '';
    });
  }

  void _reset() {
    setState(() {
      currentRpm = initialRpm;
      statusMsg = 'Reset to $initialRpm';
      isSuccess = false;
    });
  }

  /// 🔹 POST API CALL
  Future<void> _postValue() async {
    setState(() {
      isPosting = true;
      statusMsg = '';
    });

    try {
      final resp = await ApiServices.speedPost(value: currentRpm.toString());

      if (resp['success'] == true) {
        setState(() {
          initialRpm = currentRpm;
          statusMsg = 'Applied: max_rpm = $currentRpm';
          isSuccess = true;
        });
      } else {
        setState(() {
          statusMsg = resp['message'] ?? 'Failed to apply';
          isSuccess = false;
        });
      }
    } catch (e) {
      setState(() {
        statusMsg = 'Error: $e';
        isSuccess = false;
      });
    } finally {
      setState(() => isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 🔹 LOADING STATE
    if (isLoading) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width * 0.65,

            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    final fillRatio = (currentRpm / maxRpm).clamp(0.0, 1.0);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,

        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Speed",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// PROGRESS BAR
              LinearProgressIndicator(value: fillRatio),

              const SizedBox(height: 20),

              /// STEP SELECTOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [1, 5, 10].map((s) {
                  return GestureDetector(
                    onTap: () => setState(() => step = s),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: step == s ? Colors.blue : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$s",
                        style: TextStyle(
                          color: step == s ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              /// VALUE CONTROLLER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: currentRpm > 0 ? () => _changeValue(-1) : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    "$currentRpm",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: currentRpm < maxRpm
                        ? () => _changeValue(1)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// BUTTONS
              Row(
                children: [
                  // Expanded(
                  //   child: OutlinedButton(
                  //     onPressed: _reset,
                  //     child: const Text("Reset"),
                  //   ),
                  // ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: isPosting ? null : _postValue,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(minHeight: 48),
                          child: const Text(
                            "Apply",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: ElevatedButton(
                  //
                  //     onPressed: isPosting ? null : _postValue,
                  //     child: isPosting
                  //         ? const SizedBox(
                  //       height: 18,
                  //       width: 18,
                  //       child: CircularProgressIndicator(
                  //           strokeWidth: 2, color: Colors.white),
                  //     )
                  //         : const Text("Apply"),
                  //   ),
                  // ),
                ],
              ),

              /// STATUS MESSAGE
              if (statusMsg.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  statusMsg,
                  style: TextStyle(
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

///Mode widget

class ModeDialog extends StatefulWidget {
  const ModeDialog({super.key});

  @override
  State<ModeDialog> createState() => _ModeDialogState();
}

class _ModeDialogState extends State<ModeDialog> {
  int currentMode = -3;
  bool isLoading = true;
  bool isPosting = false;

  String statusMsg = '';
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    _loadMode();
  }

  /// ✅ GET INITIAL MODE
  Future<void> _loadMode() async {
    try {
      final resp = await ApiServices.currentConfig();

      if (resp['success'] == true) {
        print("jsdjhehd");
        final mode = (resp['config']['mode'] as num).toInt();
        print("jsdjhehd$mode");

        setState(() {
          currentMode = mode;
        });
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// ✅ POST MODE
  Future<void> _setMode(int modeValue) async {
    setState(() {
      isPosting = true;
      statusMsg = '';
    });

    try {
      final resp = await ApiServices.mode(name: modeValue);

      if (resp['success'] == true) {
        setState(() {
          currentMode = modeValue;
          statusMsg = "Mode updated";
          isSuccess = true;
        });
      } else {
        setState(() {
          statusMsg = resp['message'] ?? "Failed";
          isSuccess = false;
        });
      }
    } catch (e) {
      setState(() {
        statusMsg = "Error: $e";
        isSuccess = false;
      });
    } finally {
      setState(() => isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width * 0.65,

            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Mode",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// MODE CARDS
              Row(
                children: [
                  Expanded(child: _buildCard("Manual", 4)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildCard("Auto 1", 3)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildCard("Auto 2", -3)),
                ],
              ),

              const SizedBox(height: 20),

              /// STATUS
              if (statusMsg.isNotEmpty)
                Text(
                  statusMsg,
                  style: TextStyle(
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 CARD BUILDER
  Widget _buildCard(String title, int value) {
    final isSelected = currentMode == value;

    return GestureDetector(
      onTap: isPosting ? null : () => _setMode(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF185FA5) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF185FA5) : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _getIcon(value),
              color: isSelected ? Colors.white : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(int value) {
    switch (value) {
      case -3:
        return Icons.settings;
      case 3:
        return Icons.smart_toy;
      case 4:
        return Icons.auto_mode;
      default:
        return Icons.device_unknown;
    }
  }
}
Widget configCard({
  required String title,
  required String endpoint,
  required bool isBool,
  required BuildContext context,
}) {
  final TextEditingController controller = TextEditingController();
  RxBool toggle = false.obs;

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade900,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.2),
          blurRadius: 10,
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 16)),

        const SizedBox(height: 10),

        /// INPUT
        isBool
            ? Obx(() => Switch(
          value: toggle.value,
          activeColor: Colors.green,
          onChanged: (val) => toggle.value = val,
        ))
            : TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter value",
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.black,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 10),

        /// BUTTON
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            dynamic value =
            isBool ? toggle.value : double.tryParse(controller.text);
print("valuvaluee$value");
            if (!isBool && value == null) {
              Get.snackbar("Error", "Enter valid number");
              return;
            }

            bool success = await ApiServices.postData(
              endpoint: endpoint,
              value: value,
            );
            print("valuvaluee$success");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success ? "Updated successfully" : "API Failed",
                ),
                backgroundColor: success ? Colors.green : Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
            // Get.showSnackbar(
            //   GetSnackBar(
            //     title: success ? "Success" : "Failed",
            //     message: success ? "Updated successfully" : "API failed",
            //     duration: const Duration(seconds: 2),
            //     backgroundColor: success ? Colors.green : Colors.red,
            //   ),
            // );
          },
          child: const Text("SEND",style: TextStyle(color: Colors.white),),
        )
      ],
    ),
  );
}


