import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../../../config/colors.dart';

class DescriptionWithFade extends StatefulWidget {
  final String description;
  final double maxHeight;

  const DescriptionWithFade({
    required this.description,
    this.maxHeight = 90,
    super.key,
  });

  @override
  State<DescriptionWithFade> createState() => _DescriptionWithFadeState();
}

class _DescriptionWithFadeState extends State<DescriptionWithFade> {
  final GlobalKey _key = GlobalKey();
  bool _needsFade = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkHeight());
  }

  void _checkHeight() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.size.height > widget.maxHeight) {
      setState(() {
        _needsFade = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Clip et limite la hauteur pour éviter l'overflow
        ClipRect(
          child: SizedBox(
            height: widget.maxHeight,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: MarkdownBody(
                key: _key,
                data: widget.description,
                selectable: false,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  h1: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  h2: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  strong: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                  listBullet: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Dégradé uniquement si nécessaire
        if (_needsFade)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 40,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: 1.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
