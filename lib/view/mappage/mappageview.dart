import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../service/ApiService.dart';
import '../../utils/customWidget.dart';
import '../../utils/popups.dart';
import '../maplistpage/Controller/MaplistController.dart';
import '../maplistpage/maplistpage.dart';
import '../settingspage/Controller/CurrentConfigController.dart';
import '../settingspage/settingspage.dart';
import 'Controller/poiController.dart';
import 'Controller/robotDetailsController.dart';
import 'Model/poiModel.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const CameraStreamPage(),
    const MapScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) async {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        break;
      case 1:
        await Get.find<MapListController>().mapListDataz();

        break;
      case 2:
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _pages),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.devices),
              label: 'Devices',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// CAMERA STREAM PAGE

class CameraStreamPage extends StatefulWidget {
  const CameraStreamPage({super.key});

  @override
  State<CameraStreamPage> createState() => _CameraStreamPageState();
}

class _CameraStreamPageState extends State<CameraStreamPage> {
  final String streamUrl = 'http://192.168.1.199:5000/stream';
  final CurrentConfigController controller = Get.find();

  late final WebViewController _webViewController;
  bool isExpanded = false;
  bool _isLoading = true;
  bool _hasError = false;
  Timer? messageTimer2;

  final TransformationController _transformationController =
      TransformationController();
  final double _battery = 74;
  final double _cpu = 43;
  final double _ram = 61;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController xController = TextEditingController();
  final TextEditingController yController = TextEditingController();
  final TextEditingController yawController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messageTimer2 = Timer.periodic(const Duration(seconds: 2), (timer) {
      print("HomePage initialized");
      Get.find<RobotStatusController>().robotMapDataz();
    });
    _initWebView();
  }

  // @override
  // void dispose() {
  //   _transformationController.dispose();
  //   super.dispose();
  // }
  @override
  void dispose() {
    _webViewController.loadRequest(
      Uri.parse('about:blank'),
    ); // release WebView memory
    _transformationController.dispose();
    super.dispose();
  }

  void _initWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _isLoading = true;
            _hasError = false;
          }),

          onPageFinished: (_) => setState(() => _isLoading = false),

          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(streamUrl));
  }

  // SNACKBAR HELPER

  void _showSnack(bool success, String successMsg) {
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

  Future<void> _callApi(String value, String successMsg) async {
    final resp = await ApiServices.mapService(value: value);
    _showSnack(resp['success'] == true, successMsg);
  }

  // CONTROL BUTTON BUILDERS

  Widget _buildControlButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 25),
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // RIGHT CONTROL PANEL

  Widget _buildControlPanel() {
    return Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Toggle tab
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Container(
              width: 24,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
              ),
              child: Icon(
                isExpanded ? Icons.chevron_right : Icons.chevron_left,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),

          // Sliding panel
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isExpanded ? 110 : 0,
            color: Colors.black.withOpacity(0.75),
            clipBehavior: Clip.hardEdge,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSectionLabel("Navigations"),
                    _buildControlButton(
                      Icons.play_circle_outlined,
                      "Start Mapping",
                          () => _callApi(
                        "start_mapping_navigation",
                        "MAP NAVIGATION STARTED",
                      ),                    ),
                    _buildControlButton(
                      Icons.stop_circle,
                      "Stop Mapping",
                      () => _callApi("stop_mapping", "MAPPING STOPPED"),
                    ),
                    _buildControlButton(Icons.mode, "mode", () {
                      showDialog(
                        context: context,
                        builder: (_) => const ModeDialog(),
                      );
                    }),
                    // _buildControlButton(
                    //   Icons.location_on_outlined,
                    //   "Map Navigate",
                    //   () => _callApi(
                    //     "start_mapping_navigation",
                    //     "MAP NAVIGATION STARTED",
                    //   ),
                    // ),
                    // _buildControlButton(
                    //   Icons.save,
                    //   "Nav Stack",
                    //   () => _callApi("start_nav_stack", "NAV STACK STARTED"),
                    // ),
                    _buildControlButton(
                      Icons.stop,
                      "Stop All",
                          () => _callApi("stop_all", "ALL NAVIGATION STOPPED"),
                    ),
                    const Divider(color: Colors.white24, thickness: 2),
                    _buildSectionLabel("Mapping"),


                    _buildControlButton(Icons.navigation, "POI", () async {
                      var data = await ApiServices.currentValue();

                      if (data['success'] == true) {
                        var pose = data['pose'];

                        xController.text = pose['x'].toString();
                        yController.text = pose['y'].toString();
                        yawController.text = pose['yaw_deg'].toString();
                      }

                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.transparent,
                            child: SingleChildScrollView(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(
                                  context,
                                ).viewInsets.bottom, // ✅ keyboard safe
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.55,
                                  padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // HEADER
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "ADD POI",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 18),

                                    // FIELDS
                                    _styledField(
                                      nameController,
                                      "Name",
                                      Icons.person,
                                    ),
                                    _styledField(
                                      xController,
                                      "X Coordinate",
                                      Icons.location_on,
                                      enabled: false,
                                    ),
                                    _styledField(
                                      yController,
                                      "Y Coordinate",
                                      Icons.location_on_outlined,
                                      enabled: false,
                                    ),
                                    _styledField(
                                      yawController,
                                      "Yaw Coordinate",
                                      Icons.rotate_right,
                                      enabled: false,
                                    ),

                                    const SizedBox(height: 20),

                                    // BUTTONS
                                    Row(
                                      children: [
                                        // ❌ CLOSE BUTTON (Modern Outline)
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                              side: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text(
                                              "Close",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        // ✅ SUBMIT BUTTON (Gradient + Elevation)
                                        Expanded(
                                          child: ElevatedButton(
                                            style:
                                                ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                      ),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shadowColor: Colors.black26,
                                                  elevation: 6,
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
                                            onPressed: () {
                                              submitData(
                                                nameController.text,
                                                double.tryParse(
                                                      xController.text,
                                                    ) ??
                                                    0.0,
                                                double.tryParse(
                                                      yController.text,
                                                    ) ??
                                                    0.0,
                                                double.tryParse(
                                                      yawController.text,
                                                    ) ??
                                                    0.0,
                                                "POI ADDED",
                                              );
                                            },
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
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    _buildControlButton(
                      Icons.navigation_outlined,
                      "POI list",
                      () async {
                        await Get.find<PoiController>()
                            .PoiDataz(); // load first
                        showPoiManagerDialog(context);
                      },
                    ),
                    _buildControlButton(Icons.save, "Save", () {
                      showMapNameDialog(context, (mapName) async{
                        print("Map Name: $mapName");
                        await   _callApi("save_map", "MAP SAVED");
                        await ApiServices.mapName(name: mapName);
                        // 👉 Call API here
                      });
                      // Get.dialog(
                      //   MapNameDialog(
                      //     onSubmit: (mapName) {
                      //       _callApi("save_map", "MAP SAVED");
                      //       // 👉 call your API here
                      //       // ApiServices.createMap(mapName);
                      //     },
                      //   ),
                      // );
                    }),

                    const Divider(color: Colors.white24, thickness: 2),
                    //
                    _buildSectionLabel("EMERGENCY"),

                    _buildControlButton(
                      Icons.warning_amber,
                      "Emergency ON",
                      () async {
                        final resp = await ApiServices.emergency(name: true);
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
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Emergency Button Pressed",
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
                          Get.find<PoiController>().PoiDataz();
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
                      },
                    ),
                    _buildControlButton(
                      Icons.warning_amber,
                      "Emergency OFF",
                      () async {
                        final resp = await ApiServices.emergency(name: false);
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
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Emergency Button Pressed",
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
                          Get.find<PoiController>().PoiDataz();
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
                      },
                    ),
                    _buildControlButton(Icons.speed, "Speed", () async {
                      // ✅ add async
                      if (controller.currentConfigData.value == null) {
                        await controller.currentConfigDataz();
                      }
                      if (context.mounted) {
                        showRpmDialog(context);
                      }
                    }),
                    _buildControlButton(Icons.mode, "mode", () {
                      showDialog(
                        context: context,
                        builder: (_) => const ModeDialog(),
                      );
                    }),
                    //
                    // const Divider(color: Colors.white24, thickness: 2),
                    //
                    // _buildControlButton(Icons.border_outer, "Walls", () {}),
                    // _buildControlButton(Icons.timeline, "Tracks", () {}),
                    // _buildControlButton(Icons.crop_square, "Areas", () {}),
                    // _buildControlButton(Icons.edit, "Edit", () {}),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _styledField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool enabled = true,
  }) {
    final isName = label == "Name";

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        enabled: enabled,

        // 👈 important
        keyboardType: isName
            ? TextInputType.name
            : const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),

          // 🔹 ICON STYLE
          prefixIcon: Icon(icon, color: Colors.blueAccent, size: 20),

          // 🔹 BACKGROUND
          filled: true,
          fillColor: const Color(0xFFF5F7FA),

          // 🔹 PADDING
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),

          // 🔹 BORDER (DEFAULT)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),

          // 🔹 NORMAL BORDER
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),

          // 🔹 FOCUSED BORDER (IMPORTANT)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
          ),

          // 🔹 HINT STYLE
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ),
    );
  }

  Future<void> submitData(
    String name,
    double x,
    double y,
    double yaw,
    String successMsg,
  ) async {
    final resp = await ApiServices.addPoi(name: name, x: x, y: y, yaw: yaw);
    _showSnack(resp['success'] == true, successMsg);

    if (resp['success'] == true) {
      nameController.clear();
      xController.clear();
      yController.clear();
      yawController.clear();

      Navigator.pop(context);
    }
  }

  // Future<void> submitData(
  //   String name,
  //   double x,
  //   double y,
  //   double yaw,
  //   String successMsg,
  // ) async {
  //   final resp = await ApiServices.addPoi(name: name, x: x, y: y, yaw: yaw);
  //   _showSnack(resp['success'] == true, successMsg);
  //   nameController.value.clear();
  //   Navigator.pop(context);
  // }

  //  LEFT STATUS PANEL

  Widget _buildStatusPanel() {
    return Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      child: Container(
        width: 230,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.80),
          border: Border(
            right: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5),
          ),
        ),
        child: SingleChildScrollView(
          child: GetX<RobotStatusController>(
            builder: (controller) {
              final data = controller.robotMapData.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _statusSection(
                    title: "SYSTEM",
                    child: Column(
                      children: [
                        _barRow("Battery", _battery / 100, Colors.greenAccent),
                      ],
                    ),
                  ),
                  _statusSection(
                    title: "ROBOT STATUS",
                    child: Column(
                      children: [
                        const SizedBox(height: 4),
                        _statusRow(
                          color: Colors.greenAccent,
                          label: "Emergency Stop",
                          value: data?.emergencyStopActive ?? false,
                        ),
                        // _statusRow2(color: Colors.blueAccent, label: "Distance Travelled",
                        //     value: data?.distanceTraveled ?? 0, isModeBadge: true),
                        // _statusRow(color: Colors.amberAccent, label: "Localized",
                        //     value: data?.l ?? false),
                        _statusRow(
                          color: Colors.amberAccent,
                          label: "Map Ready",
                          value: data?.mapReady ?? false,
                        ),
                        _statusRow(
                          color: Colors.blueAccent,
                          label: "Map Active",
                          value: data?.mappingActive ?? false,
                        ),
                        _statusRow2(
                          color: Colors.lightGreen,
                          label: "Navigation State",
                          value: data?.navState ?? "No Data",
                        ),
                        _statusRow2(
                          color: Colors.purple,
                          label: "Work Flow Mode",
                          value: data?.workflowMode ?? "No Data",
                        ),
                        _statusRow2(
                          color: Colors.teal,
                          label: "Work Flow Running",
                          value: data?.workflowRunning ?? "No Data",
                        ),
                        // _statusRow2(
                        //   color: Colors.cyan,
                        //   label: "Work Flow Status",
                        //   value: data?.workflowStatus ?? "No Data",
                        // ),
                      ],
                    ),
                  ),

                  _statusSection(
                    title: "NAVIGATION",
                    child: Column(
                      children: [
                        _statusRow(
                          color: Colors.amberAccent,
                          label: "Goal Reached",
                          value: data?.goalReached ?? false,
                        ),
                        _statusRow3(
                          color: Colors.orangeAccent,
                          label: "Distance Travelled",
                          value: data?.distanceTraveled ?? 0,
                        ),
                        _statusRow3(
                          color: Colors.purpleAccent,
                          label: "Goal Distance",
                          value: data?.goalDistance ?? 0,
                        ),
                        _statusRow3(
                          color: Colors.purpleAccent,
                          label: "Goal Distance",
                          value: data?.goalDistance ?? 0,
                        ),

                        // _statusRow2(color: Colors.amberAccent, label: "Goal Dist",
                        //     value: data?.goalDistance ?? 0),
                        // _statusRow2(color: Colors.amberAccent, label: "Path Points",
                        //     value: data?.pathPoints ?? 0),
                      ],
                    ),
                  ),

                  _statusSection(
                    title: "ROBOT POSE",
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 1.6,
                      children: [
                        _metricCard("X", data?.robotPose?.x ?? 0, ""),
                        _metricCard("Y", data?.robotPose?.y ?? 0, ""),
                        _metricCard("Yaw", data?.robotPose?.yawDeg ?? 0, ""),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // BUILD

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Gesture-controlled camera stream ──────────────────
        Positioned.fill(
          child: InteractiveViewer(
            transformationController: _transformationController,
            panEnabled: true,
            scaleEnabled: true,
            minScale: 0.5,
            maxScale: 5.0,
            child: WebViewWidget(controller: _webViewController,),
          ),
        ),

        // ── Loading overlay ───────────────────────────────────
        // if (_isLoading)
        //   Container(
        //     color: Colors.black87,
        //     child: const Center(
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           CircularProgressIndicator(color: Colors.white),
        //           SizedBox(height: 12),
        //           Text("Connecting to stream...",
        //               style: TextStyle(color: Colors.white70)),
        //         ],
        //       ),
        //     ),
        //   ),

        // ── Error overlay ─────────────────────────────────────
        if (_hasError)
          Container(
            color: Colors.black87,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const Icon(Icons.videocam_off, color: Colors.redAccent, size: 64),
                  // const SizedBox(height: 16),
                  // const Text("Stream unavailable",
                  //     style: TextStyle(color: Colors.white70, fontSize: 16)),
                  // const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _hasError = false;
                      });
                      _webViewController.reload();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                  ),
                ],
              ),
            ),
          ),

        // ── Reload + Reset-zoom buttons (top-right) ───────────
        Positioned(
          top: 40,
          right: isExpanded ? 124 : 38,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: "reload",
                mini: true,
                backgroundColor: Colors.black54,
                onPressed: () => _webViewController.reload(),
                child: const Icon(Icons.refresh, color: Colors.white),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: "resetZoom",
                mini: true,
                backgroundColor: Colors.black54,
                onPressed: () =>
                    _transformationController.value = Matrix4.identity(),
                child: const Icon(
                  Icons.center_focus_strong,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        _buildStatusPanel(),
        _buildControlPanel(),
      ],
    );
  }
}

// SHARED PANEL WIDGETS

Widget _statusSection({required String title, required Widget child}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.white.withOpacity(0.07), width: 0.5),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );
}

Widget _statusRow({
  required Color color,
  required String label,
  required bool value,
  bool isModeBadge = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.5), blurRadius: 4),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.65),
            ),
          ),
        ),
        if (isModeBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.15),
              border: Border.all(
                color: Colors.blueAccent.withOpacity(0.35),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value ? "True" : "False",
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Colors.lightBlueAccent,
                letterSpacing: 0.5,
              ),
            ),
          )
        else
          Text(
            value ? "True" : "False",
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
      ],
    ),
  );
}

Widget _statusRow2({
  required Color color,
  required String label,
  required String value,
  bool isModeBadge = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.5), blurRadius: 4),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.65),
            ),
          ),
        ),
        if (isModeBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.15),
              border: Border.all(
                color: Colors.blueAccent.withOpacity(0.35),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Colors.lightBlueAccent,
                letterSpacing: 0.5,
              ),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: Colors.lightBlueAccent,
              letterSpacing: 0.5,
            ),
          ),
      ],
    ),
  );
}

Widget _statusRow3({
  required Color color,
  required String label,
  required double value,
  bool isModeBadge = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.5), blurRadius: 4),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.65),
            ),
          ),
        ),
        if (isModeBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.15),
              border: Border.all(
                color: Colors.blueAccent.withOpacity(0.35),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value.toDouble().toString(),
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Colors.lightBlueAccent,
                letterSpacing: 0.5,
              ),
            ),
          )
        else
          Text(
            value.toDouble().toString(),
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: Colors.lightBlueAccent,
              letterSpacing: 0.5,
            ),
          ),
      ],
    ),
  );
}

Widget _metricCard(String name, double val, String unit) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.38),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 3),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: val.toDouble().toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: " $unit",
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.white.withOpacity(0.45),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _barRow(String label, double value, Color color) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.55),
              ),
            ),
            Text(
              "${(value * 100).toInt()}%",
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 4,
            backgroundColor: Colors.white.withOpacity(0.08),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    ),
  );
}

void showPoiManagerDialog(BuildContext context) {
  showDialog(context: context, builder: (_) => const _PoiDialog());
}

class _PoiDialog extends StatelessWidget {
  const _PoiDialog();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PoiController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.55,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Text(
                    "POI LIST",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.red),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // LIST
            Flexible(
              child: Obx(() {
                if (ctrl.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final list = ctrl.PoiData.value?.pois ?? [];

                if (list.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No POIs found"),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final p = list[i];
                    return _PoiItem(p: p, ctrl: ctrl);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _PoiItem extends StatelessWidget {
  final Pois p;
  final PoiController ctrl;

  const _PoiItem({required this.p, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 1,
      child: ListTile(
        dense: true,
        title: Text(
          p.name ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "x: ${p.x}   y: ${p.y}   yaw: ${p.yawDeg}",
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // navigate
            IconButton(
              icon: const Icon(Icons.navigation, size: 18, color: Colors.green),
              onPressed: () async {
                final resp = await ApiServices.navigate(ids: p.id ?? 0);
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
                                "Navigation Activated",
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
                  Navigator.of(context).pop();
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
              },
            ),
            // EDIT
            IconButton(
              icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
              onPressed: () => _showEditDialog(context, p, ctrl),
            ),

            // DELETE
            IconButton(
              icon: const Icon(Icons.delete, size: 18, color: Colors.red),
              onPressed: () async {
                final resp = await ApiServices.delete(p.id ?? 0);
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
                  Get.find<PoiController>().PoiDataz();
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
              },
            ),
          ],
        ),
      ),
    );
  }
}

void _showEditDialog(BuildContext context, Pois p, PoiController ctrl) {
  final name = TextEditingController(text: p.name);
  final x = TextEditingController(text: p.x?.toString());
  final y = TextEditingController(text: p.y?.toString());
  final yaw = TextEditingController(text: p.yawDeg?.toString());

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("EDIT POI", style: TextStyle(fontSize: 15)),
      content: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // ✅ keyboard safe
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                labelText: "Name",
                hintText: "Enter name",
                prefixIcon: const Icon(Icons.person_outline),

                filled: true,
                fillColor: Colors.grey.shade100,

                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),

                labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: x,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                labelText: "X",
                hintText: "Enter X",
                prefixIcon: const Icon(Icons.person_outline),

                filled: true,
                fillColor: Colors.grey.shade100,

                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),

                labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            SizedBox(height: 10),

            TextField(
              controller: y,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                labelText: "Y",
                hintText: "Enter Y",
                prefixIcon: const Icon(Icons.person_outline),

                filled: true,
                fillColor: Colors.grey.shade100,

                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),

                labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            SizedBox(height: 10),

            TextField(
              controller: y,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                labelText: "yaw",
                hintText: "Enter yaw",
                prefixIcon: const Icon(Icons.person_outline),

                filled: true,
                fillColor: Colors.grey.shade100,

                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),

                labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            // ❌ CLOSE BUTTON (Modern Outline)
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ✅ SUBMIT BUTTON (Gradient + Elevation)
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  editdata(
                    name.text,
                    double.tryParse(x.text) ?? 0.0,
                    double.tryParse(y.text) ?? 0.0,
                    double.tryParse(yaw.text) ?? 0.0,
                    p.id ?? 0,
                    // id
                    "Map Updated Successfully",
                    // success message
                    context, // context (IMPORTANT)
                  );
                },
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
                      "Update",
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
      ],
    ),
  );
}

Future<void> editdata(
  String name,
  double x,
  double y,
  double yaw,
  int id,
  String successMsg,
  BuildContext context,
) async {
  try {
    final resp = await ApiServices.editPoi(
      name: name,
      x: x,
      y: y,
      yaw: yaw,
      id: id,
    );

    if (resp['success'] == true) {
      _showSnackBar(
        context,
        message: successMsg,
        color: Colors.green,
        icon: Icons.check_circle,
      );
      Navigator.of(context).pop();
      Get.find<PoiController>().PoiDataz();
    } else {
      _showSnackBar(
        context,
        message: resp['message'] ?? "Something went wrong",
        color: Colors.red,
        icon: Icons.error,
      );
    }
  } catch (e) {
    _showSnackBar(
      context,
      message: "Error: ${e.toString()}",
      color: Colors.red,
      icon: Icons.error,
    );
  }
}

void _showSnackBar(
  BuildContext context, {
  required String message,
  required Color color,
  required IconData icon,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: color,
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
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
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
