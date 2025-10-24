import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;

  const StatCard({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade600)),
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
      ],
    );
  }
}
