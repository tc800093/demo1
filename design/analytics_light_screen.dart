import 'package:flutter/material.dart';

class AnalyticsLightScreen extends StatelessWidget {
  const AnalyticsLightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text('Power & Fuel Analytics', style: TextStyle(color: Colors.black, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Row(
              children: [
                Text('This Month', style: TextStyle(color: Colors.blue)),
                Icon(Icons.keyboard_arrow_down, color: Colors.blue),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartCard('Power vs Fuel Utilization Trends', 200),
            const SizedBox(height: 16),
            _buildChartCard('Generator Utilization', 250),
            const SizedBox(height: 16),
            _buildChartCard('Power vs Fuel Contributions', 200, isPie: true),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(String title, double height, {bool isPie = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: isPie 
                  ? const Icon(Icons.pie_chart, size: 64, color: Colors.blue) 
                  : const Icon(Icons.bar_chart, size: 64, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
