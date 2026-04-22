import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tarabase/utils/Controller_handling.dart';
import 'package:tarabase/view/mappage/mappageview.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // ✅ Force Landscape Mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  HandleControllers.createGetControllers();

  runApp(const RobotControlApp());
}

class RobotControlApp extends StatelessWidget {
  const RobotControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tara Base',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D4ED8),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),
      ),
      home: const MainNavigationPage(),
    );
  }
}