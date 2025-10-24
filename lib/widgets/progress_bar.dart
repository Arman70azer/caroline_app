import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final String label;
  final double progress;

  const ProgressBar({super.key, required this.label, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            Text('${(progress * 100).toInt()}%',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade600)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
