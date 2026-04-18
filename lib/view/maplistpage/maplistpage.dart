import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/ApiService.dart';
import 'Controller/MaplistController.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final MapListController controller = Get.find<MapListController>();

  /// ✅ Selected Map ID (important)
  int? selectedMapId;

  @override
  void initState() {
    super.initState();
    controller.mapListDataz();
  }

  /// ✅ Save selection
  Future<void> saveSelectedMap(String name, int id) async {
    final prefs = await SharedPreferences.getInstance();

    /// remove old
    await prefs.remove('map_name');
    await prefs.remove('map_id');

    /// save new
    await prefs.setString('map_name', name);
    await prefs.setInt('map_id', id);
  }

  /// ✅ Load selection
  Future<void> loadSelectedMap() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getInt('map_id');

    if (savedId != null) {
      setState(() {
        selectedMapId = savedId;
      });
    }
  }
  Future<void> _callApi(String value, String successMsg) async {
    final resp = await ApiServices.mapService(value: value);
    _showSnack(context ,resp['success'] == true, successMsg);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("MAP LIST", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Obx(() {

        /// 🔄 Loading
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        /// ❌ Error
        if (controller.isError.value) {
          return const Center(
            child: Text("Failed to load maps",
                style: TextStyle(color: Colors.red)),
          );
        }

        /// 📭 Empty
        if (controller.mapList.isEmpty) {
          return const Center(
            child: Text("No Maps Available",
                style: TextStyle(color: Colors.white)),
          );
        }

        /// ✅ Load saved selection AFTER data arrives
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (selectedMapId == null) {
            loadSelectedMap();
          }
        });

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: GridView.builder(
            itemCount: controller.mapList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final map = controller.mapList[index];

              /// 🔥 Check selected
              final isSelected = selectedMapId == map.id;

              return GestureDetector(
                onTap: () async {
                  setState(() {
                    selectedMapId = map.id;
                  });

                  await saveSelectedMap(
                    map.mapName ?? "",
                    map.id ?? 0,
                  );
                  await _callApi("start_nav_stack", "Map Uploaded");

                  print("Selected ${map.mapName}");
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),

                    /// 🔥 Highlight
                    border: Border.all(
                      color: isSelected
                          ? Colors.greenAccent
                          : Colors.transparent,
                      width: 2,
                    ),

                    gradient: LinearGradient(
                      colors: isSelected
                          ? [Colors.green.shade700, Colors.black]
                          : [Colors.blueGrey.shade900, Colors.black],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? Colors.greenAccent.withOpacity(0.5)
                            : Colors.blueAccent.withOpacity(0.3),
                        blurRadius: 12,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [

                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: Icon(
                          Icons.map,
                          size: 100,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// Delete
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final resp = await ApiServices.deleteMap(
                                      value: map.mapName ?? "",
                                      id: map.id ?? 0,
                                    );

                                    if (resp['success'] == true) {

                                      /// 🔥 If deleted selected item → clear pref
                                      if (selectedMapId == map.id) {
                                        final prefs = await SharedPreferences.getInstance();
                                        await prefs.remove('map_name');
                                        await prefs.remove('map_id');

                                        setState(() {
                                          selectedMapId = null;
                                        });
                                      }

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Map Deleted Successfully"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      controller.mapListDataz();
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Error"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),

                            const Spacer(),

                            /// Name
                            Text(
                              map.mapName ?? "Unknown",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "ID: ${map.id}",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 11,
                              ),
                            ),

                            const SizedBox(height: 8),

                            /// Rename
                            GestureDetector(
                              onTap: () {
                                _showRenameDialog(context, map);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit, size: 14, color: Colors.white),
                                    SizedBox(width: 5),
                                    Text(
                                      "Rename",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
void _showSnack(BuildContext context,bool success, String successMsg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: success ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                success ? successMsg : "ERROR",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Rename Dialog (same as yours)
void _showRenameDialog(BuildContext context, map) {
  TextEditingController controller =
  TextEditingController(text: map.mapName);

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: const Text("Rename Map",
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await ApiServices.renameMap(
                value: controller.text,
                id: map.id ?? 0,
              );
              Navigator.pop(context);
              Get.find<MapListController>().mapListDataz();
            },
            child: const Text("Save"),
          )
        ],
      );
    },
  );
}
