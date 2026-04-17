import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showMapNameDialog(BuildContext context, Function(String) onSubmit) {
  final TextEditingController controller = TextEditingController();
  bool isValid = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "CREATE MAP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// TextField
                    TextField(
                      controller: controller,
                      onChanged: (value) {
                        setState(() {
                          isValid = value.trim().isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Enter map name",
                        prefixIcon: const Icon(Icons.map),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Submit Button
                    SizedBox(
                      width: double.infinity,
                      child:
                      ElevatedButton(
                        style:
                        ElevatedButton.styleFrom(


                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              12,
                            ),
                          ),
                        ).copyWith(
                          backgroundColor:
                          MaterialStateProperty.resolveWith(
                                (states) => null,
                          ),
                        ),
                        onPressed: isValid
                            ? () {
                          onSubmit(controller.text.trim());
                          Navigator.pop(context);
                        }
                            : null,
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4FACFE),
                                Color(0xFF00F2FE),
                              ],
                            ),
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints:
                            const BoxConstraints(
                              minHeight: 48,
                            ),
                            child: const Text(
                              "Submit",
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
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}