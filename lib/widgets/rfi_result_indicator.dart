import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/rfi_model.dart';
import 'utils/app_palette.dart';
import 'utils/app_textStyles.dart';

class RFIResultIndicator extends StatelessWidget {
  final RFIModel rfi;
  const RFIResultIndicator({super.key, required this.rfi});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 21,
            lineWidth: 5.0,
            animation: true,
            percent: rfi.percentage / 100,
            center: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                "${rfi.percentage}%",
                style: JasaraTextStyles.primaryText500.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            progressColor: rfi.progressColor,
            backgroundColor: JasaraPalette.grey.withOpacity(0.2),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          Text(
            rfi.result,
            style: JasaraTextStyles.primaryText500.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: rfi.progressColor,
            ),
          ),
        ],
      ),
    );
  }
}
