import 'package:flutter/material.dart';
import '../models/nutrition_program.dart';

class ProgramCard extends StatelessWidget {
  final NutritionProgram program;
  final bool isGradient;

  const ProgramCard(
      {super.key, required this.program, required this.isGradient});

  @override
  Widget build(BuildContext context) {
    if (isGradient) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.green.shade500, Colors.green.shade600]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(program.title,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(program.subtitle,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14)),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text('Actif',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: program.progress,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),
            Text('Prochain repas : ${program.nextMeal}',
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(program.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(program.subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20)),
                child: Text('Actif',
                    style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: program.progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Text('Prochaine séance : ${program.nextMeal}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        ],
      ),
    );
  }
}
