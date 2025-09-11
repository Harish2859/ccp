import 'package:flutter/material.dart';

class SocialTrendsPage extends StatelessWidget {
  const SocialTrendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Trends'),
      ),
      body: const Center(
        child: Text('Social Trends Page'),
      ),
    );
  }
}
