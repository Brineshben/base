import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/ApiService.dart';
import 'Controller/MaplistController.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  /// ✅ Define controller
  final MapListController controller = Get.find<MapListController>();

  @override
  void initState() {
    super.initState();

    /// ✅ Call API once
    controller.mapListDataz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("MAP LIST",style: TextStyle(color: Colors.white),),
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
            child: Text(
              "Failed to load maps",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        /// 📭 Empty
        if (controller.mapList.isEmpty) {
          return const Center(
            child: Text(
              "No Maps Available",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        /// ✅ Grid UI
        return Padding(
          padding: const EdgeInsets.only(left: 50,right: 50),
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

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueGrey.shade900,
                        Colors.black,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.3),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      /// Background icon
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

                            /// 🔹 Top Row (Edit + Delete)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.white),
                                  onPressed: () {
                                    print("Edit ${map.mapName}");
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: ()async {
                                    final resp = await ApiServices.deleteMap(value: map.mapName ?? "", id: map.id ?? 0);
                                    if (resp['success'] == true) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 50,
                                            vertical: 20,
                                          ),
                                          content: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
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
                                                Icon(Icons.check_circle, color: Colors.white),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    "Map Deleted Successfully",
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
                                      Get.find<MapListController>().mapListDataz();
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 50,
                                            vertical: 20,
                                          ),
                                          content: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
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
                                                Icon(Icons.error, color: Colors.white),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    "Error",
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
                                    print("Delete ${map.mapName}");
                                  },
                                ),
                              ],
                            ),

                            const Spacer(),

                            /// 📌 Map Name
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

                            /// 🔥 Buttons Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                /// ✅ Select
                                // ElevatedButton(
                                //   style: ElevatedButton.styleFrom(
                                //     backgroundColor: Colors.green,
                                //     padding: const EdgeInsets.symmetric(horizontal: 8),
                                //   ),
                                //   onPressed: () {
                                //     print("Selected ${map.mapName}");
                                //   },
                                //   child: const Text("Select", style: TextStyle(fontSize: 10)),
                                // ),

                                /// ✏️ Rename
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
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orange.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.edit, size: 14, color: Colors.white),
                                        SizedBox(width: 5),
                                        Text(
                                          "Rename",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }          ),
        );
      }),
    );
  }
}
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
          decoration: const InputDecoration(
            hintText: "Enter new name",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: ()async {
              final resp = await ApiServices.renameMap(value: controller.text ?? "", id: map.id ?? 0);
              if (resp['success'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 20,
                    ),
                    content: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
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
                          Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Map Deleted Successfully",
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
                Get.find<MapListController>().mapListDataz();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 20,
                    ),
                    content: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
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
                          Icon(Icons.error, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Error",
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
              Navigator.of(context).pop();
              print("Delete ${map.mapName}");
            },
            child: const Text("Save"),
          )
        ],
      );
    },
  );
}