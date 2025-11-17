import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/scan/scan_bloc.dart';
import '../../../blocs/scan/scan_event.dart';
import '../../../blocs/scan/scan_state.dart';
import '../../../config/colors.dart';

class ModernScannerZone extends StatefulWidget {
  final ScanState state;

  const ModernScannerZone({
    super.key,
    required this.state,
  });

  @override
  State<ModernScannerZone> createState() => _ModernScannerZoneState();
}

class _ModernScannerZoneState extends State<ModernScannerZone>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.state is ScanLoading) return;

    // Si on a déjà un résultat, reset avant de scanner
    if (widget.state is ScanSuccess) {
      context.read<ScanBloc>().add(ResetScan());
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          context.read<ScanBloc>().add(ScanFood(portionInfo: null));
        }
      });
    } else {
      // Sinon, scanner directement
      context.read<ScanBloc>().add(ScanFood(portionInfo: null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 300,
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.emeraldPale.withOpacity(0.4),
              AppColors.indigoPale.withOpacity(0.4),
            ],
          ),
          border: Border.all(
            width: 2.5,
            color: Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(-4, -4),
            ),
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              // Image de fond
              if (widget.state is! ScanLoading)
                Positioned.fill(
                  child: Image.asset(
                    'assets/scan_img.png',
                    fit: BoxFit.cover,
                  ),
                ),

              // Overlay avec gradient (pour améliorer la lisibilité)
              if (widget.state is! ScanLoading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryGreen.withOpacity(0.03),
                          AppColors.primaryPurple.withOpacity(0.03),
                        ],
                      ),
                    ),
                  ),
                ),

              // Contenu (icône + texte ou loading)
              Positioned.fill(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.state is ScanLoading) {
      return _buildLoadingContent();
    }

    return _buildIdleContent();
  }

  Widget _buildIdleContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.1),
            Colors.black.withOpacity(0.25),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryGreen.withOpacity(0.25),
                        AppColors.primaryPurple.withOpacity(0.25),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2.5,
                      color: Colors.white.withOpacity(0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(-3, -3),
                      ),
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(3, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_enhance_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primaryGreen.withOpacity(0.9),
                  AppColors.lightGreen.withOpacity(0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Text(
              'Touchez pour scanner',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen.withOpacity(0.85),
            AppColors.primaryPurple.withOpacity(0.85),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Analyse en cours...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Temps estimé: 10-15s',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
