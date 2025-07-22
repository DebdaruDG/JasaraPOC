import 'package:flutter/material.dart';
import 'package:jasara_poc/widgets/utils/app_palette.dart';
import 'package:jasara_poc/widgets/utils/app_textStyles.dart';
import '../models/rfi_stat_model.dart';

class StatCard extends StatelessWidget {
  final StatModel stat;

  const StatCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: stat.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: stat.gradientColors.last.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(stat.icon, color: JasaraPalette.background, size: 40),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  stat.label,
                  style: JasaraTextStyles.primaryText500.copyWith(
                    fontSize: 18,
                    color: JasaraPalette.background,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                stat.value,
                style: const TextStyle(
                  color: JasaraPalette.background,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
