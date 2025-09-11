import 'package:flutter/material.dart';

class MyReportsPage extends StatelessWidget {
  const MyReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reports'),
      ),
      body: const Center(
        child: Text('My Reports Page'),
      ),
    );
  }
}
