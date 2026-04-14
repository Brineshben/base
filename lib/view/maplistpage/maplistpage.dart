
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Map"), backgroundColor: Colors.black),
      body: const Center(
        child: Text("Map Screen (ROS2 Visualization Here)",
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}