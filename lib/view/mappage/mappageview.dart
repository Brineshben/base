import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../service/ApiService.dart';
import '../maplistpage/maplistpage.dart';
import '../settingspage/settingspage.dart';
import 'Controller/robotDetailsController.dart';


class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;



  final List<Widget> _pages = const [
    CameraStreamPage(),
    MapScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

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
            BottomNavigationBarItem(icon: Icon(Icons.devices), label: 'Devices'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
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

  late final WebViewController _webViewController;
  bool isExpanded = false;
  bool _isLoading = true;
  bool _hasError = false;
  Timer? messageTimer2;

  final TransformationController _transformationController = TransformationController();
  final double _battery = 74;
  final double _cpu = 43;
  final double _ram = 61;

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
    _webViewController.loadRequest(Uri.parse('about:blank')); // release WebView memory
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
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
          ),
          child: Row(
            children: [
              Icon(success ? Icons.check_circle : Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  success ? successMsg : "ERROR",
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
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
            Text(label.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(label.toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
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
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
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
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSectionLabel("Navigations"),
                    _buildControlButton(Icons.play_circle_outlined, "Start Mapping",
                            () => _callApi("start_mapping", "MAPPING STARTED")),
                    _buildControlButton(Icons.stop_circle, "Stop Mapping",
                            () => _callApi("stop_mapping", "MAPPING STOPPED")),
                    _buildControlButton(Icons.location_on_outlined, "Map Navigate",
                            () => _callApi("start_mapping_navigation", "MAP NAVIGATION STARTED")),
                    _buildControlButton(Icons.save, "Nav Stack",
                            () => _callApi("start_nav_stack", "NAV STACK STARTED")),

                    const Divider(color: Colors.white24, thickness: 2),
                    _buildSectionLabel("Mapping"),

                    _buildControlButton(Icons.stop, "Stop All",
                            () => _callApi("stop_all", "ALL NAVIGATION STOPPED")),
                    _buildControlButton(Icons.save, "Save",
                            () => _callApi("save_map", "MAP SAVED")),
                    _buildControlButton(Icons.home, "Home", () {}),
                    _buildControlButton(Icons.navigation, "Move To", () {}),
                    _buildControlButton(Icons.location_searching, "Localizing", () {}),
                    _buildControlButton(Icons.map, "Mapping", () {}),

                    const Divider(color: Colors.white24, thickness: 2),

                    _buildControlButton(Icons.delete, "Clear", () {}),
                    _buildControlButton(Icons.restore, "Recover", () {}),
                    _buildControlButton(Icons.place, "POI", () {}),

                    const Divider(color: Colors.white24, thickness: 2),

                    _buildControlButton(Icons.border_outer, "Walls", () {}),
                    _buildControlButton(Icons.timeline, "Tracks", () {}),
                    _buildControlButton(Icons.crop_square, "Areas", () {}),
                    _buildControlButton(Icons.edit, "Edit", () {}),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                        _statusRow(color: Colors.greenAccent, label: "Emergency Stop",
                            value: data?.emergencyStopActive ?? false),
                        _statusRow2(color: Colors.blueAccent, label: "Distance Travelled",
                            value: data?.distanceTraveled ?? 0, isModeBadge: true),
                        // _statusRow(color: Colors.amberAccent, label: "Localized",
                        //     value: data?.l ?? false),
                        _statusRow(color: Colors.amberAccent, label: "Map Ready",
                            value: data?.mapReady ?? false),
                        _statusRow(color: Colors.amberAccent, label: "Map Active",
                            value: data?.mappingActive ?? false),
                      ],
                    ),
                  ),

                  _statusSection(
                    title: "NAVIGATION",
                    child: Column(
                      children: [
                        _statusRow(color: Colors.amberAccent, label: "Goal Reached",
                            value: data?.goalReached ?? false),
                        _statusRow2(color: Colors.amberAccent, label: "Goal",
                            value: data?.goal ?? 0),
                        _statusRow2(color: Colors.amberAccent, label: "Goal Dist",
                            value: data?.goalDistance ?? 0),
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
                        _metricCard("X",   data?.robotPose?.x ?? 0, ""),
                        _metricCard("Y",   data?.robotPose?.y ?? 0,  ""),
                        _metricCard("Yaw",  data?.robotPose?.yawDeg ?? 0, ""),
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
            child: WebViewWidget(controller: _webViewController),
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
                      setState(() { _isLoading = true; _hasError = false; });
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
                onPressed: () => _transformationController.value = Matrix4.identity(),
                child: const Icon(Icons.center_focus_strong, color: Colors.white),
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
        Text(title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500,
                color: Colors.white, letterSpacing: 1.0)),
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
          width: 7, height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 4)],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label,
              style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.65))),
        ),
        if (isModeBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.15),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.35), width: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(value ? "True" : "False",
                style: const TextStyle(
                    fontSize: 9, fontWeight: FontWeight.w500,
                    color: Colors.lightBlueAccent, letterSpacing: 0.5)),
          )
        else
          Text(value ? "True" : "False",
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white)),
      ],
    ),
  );
}Widget _statusRow2({
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
          width: 7, height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 4)],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label,
              style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.65))),
        ),
        if (isModeBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.15),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.35), width: 0.5),
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
          )
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
        Text(name,
            style: TextStyle(
                fontSize: 14, color: Colors.white.withOpacity(0.38), letterSpacing: 0.5)),
        const SizedBox(height: 3),
        RichText(
          text: TextSpan(
            children: [

              TextSpan(text:  val.toDouble().toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
              TextSpan(text: " $unit",
                  style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.45))),
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
            Text(label,
                style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.55))),
            Text("${(value * 100).toInt()}%",
                style: const TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white)),
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


