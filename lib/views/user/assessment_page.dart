import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/assessment_page_provider.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/criteria_provider.dart';
import '../../widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';

class AssessmentPage extends StatefulWidget {
  final File? file;
  final Map<String, dynamic>? formJson;
  const AssessmentPage({super.key, required this.file, this.formJson});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  @override
  void initState() {
    super.initState();
    final criteriaVM = Provider.of<CriteriaProvider>(context, listen: false);
    final assessmentVM = Provider.of<AssessmentProvider>(
      context,
      listen: false,
    );
    Future.delayed(
      Duration.zero,
      () async => await criteriaVM.fetchCriteriaList(),
    );
    for (var item in criteriaVM.criteriaListResponse) {
      assessmentVM.evaluateBE(
        widget.formJson ?? {},
        item.assistantId,
        widget.file!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: JasaraPalette.accent,
        title: Text(
          "AI Assessment",
          style: JasaraTextStyles.primaryText500.copyWith(
            fontSize: 18,
            color: JasaraPalette.dark2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: JasaraPalette.dark2),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AssessmentPageProvider>(
        builder: (context, provider, _) {
          final total = provider.criteria.length;
          final completed =
              provider.responses.where((r) => r.isNotEmpty).length;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Counter: $completed of $total",
                      style: JasaraTextStyles.primaryText500.copyWith(
                        fontSize: 16,
                        color: JasaraPalette.dark2,
                      ),
                    ),
                    SparkleAnimation(
                      child: Text(
                        "Final Score: ${provider.averageScore}",
                        style: JasaraTextStyles.primaryText500.copyWith(
                          fontSize: 16,
                          color: JasaraPalette.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: total,
                    itemBuilder: (context, index) {
                      return _buildCriteriaItem(context, provider, index);
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCriteriaItem(
    BuildContext context,
    AssessmentPageProvider provider,
    int index,
  ) {
    final response = provider.responses[index];
    final score = provider.scores[index];
    final isLoading = provider.loadingStates[index];
    final criteria = provider.criteria[index];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: JasaraPalette.primary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Criteria ${index + 1}: $criteria",
            style: JasaraTextStyles.primaryText500.copyWith(
              fontSize: 16,
              color: JasaraPalette.dark2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child:
                isLoading
                    ? _buildSparkleLoader()
                    : Text(
                      response,
                      style: JasaraTextStyles.primaryText400.copyWith(
                        fontSize: 14,
                        color: JasaraPalette.dark2,
                      ),
                    ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: SparkleAnimation(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: JasaraPalette.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Score: $score",
                  style: JasaraTextStyles.primaryText500.copyWith(
                    fontSize: 14,
                    color: JasaraPalette.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkleLoader() {
    return SizedBox(
      height: 40,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(seconds: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: 0.5 + 0.5 * (1 - (value - 0.5).abs() * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.auto_awesome, color: JasaraPalette.primary),
                  SizedBox(width: 8),
                  Text("Thinking...", style: JasaraTextStyles.primaryText400),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
