import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ScreenPreview extends StatelessWidget {
  final IconData icon;
  final String title;
  const ScreenPreview({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3E4446), Color(0xFF2C3032)],
        ),
        border: Border.all(color: AppColors.outline, width: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // barra superior simulada (app bar)
          Row(
            children: [
              const Icon(Icons.arrow_back_ios_new, size: 9, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 6),
              _bar(width: 60, height: 6, color: AppColors.onSurfaceVariant.withOpacity(0.6)),
              const Spacer(),
              Container(width: 14, height: 14, decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.25), shape: BoxShape.circle)),
            ],
          ),
          const SizedBox(height: 14),
          // ícono dentro del círculo dorado
          Expanded(
            child: Center(
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.15),
                  border: Border.all(color: AppColors.primary, width: 1.8),
                ),
                child: Icon(icon, size: 30, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // filas de contenido simuladas
          _fauxRow(),
          const SizedBox(height: 8),
          _fauxRow(short: true),
        ],
      ),
    );
  }

  Widget _fauxRow({bool short = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outline.withOpacity(0.6), width: 0.5),
      ),
      child: Row(
        children: [
          Container(width: 18, height: 18, decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.30), borderRadius: BorderRadius.circular(5))),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bar(width: double.infinity, height: 5, color: AppColors.onSurfaceVariant.withOpacity(0.9)),
                const SizedBox(height: 5),
                _bar(width: short ? 50 : 90, height: 5, color: AppColors.outline),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar({required double width, required double height, required Color color}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
    );
  }
}
