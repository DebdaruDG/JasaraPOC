import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/rfi_model.dart';

class RFIResultIndicator extends StatelessWidget {
  final RFIModel rfi;
  const RFIResultIndicator({super.key, required this.rfi});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 25.0,
      lineWidth: 5.0,
      animation: true,
      percent: rfi.percentage / 100,
      center: Text("${rfi.percentage}%"),
      progressColor: rfi.progressColor,
      backgroundColor: Colors.grey[300]!,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
