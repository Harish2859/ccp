import 'package:flutter/material.dart';

class HazardMapPage extends StatelessWidget {
  const HazardMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hazard Map'),
      ),
      body: const Center(
        child: Text('Hazard Map Page'),
      ),
    );
  }
}
