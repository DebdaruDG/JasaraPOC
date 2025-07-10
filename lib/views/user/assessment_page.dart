import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jasara_poc/widgets/utils/app_palette.dart';
import '../../widgets/utils/app_textStyles.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  final List<String> criteriaList = ["Criteria 1", "Criteria 2", "Criteria 3"];
  late List<String?> responses;
  late List<bool> isLoading;
  int completed = 0;
  double get progress => completed / criteriaList.length;

  @override
  void initState() {
    super.initState();
    responses = List.generate(criteriaList.length, (_) => null);
    isLoading = List.generate(criteriaList.length, (_) => true);
    _startDummyAssessments();
  }

  Future<void> _startDummyAssessments() async {
    for (int i = 0; i < criteriaList.length; i++) {
      _simulateApi(i);
    }
  }

  void _simulateApi(int index) async {
    await Future.delayed(Duration(seconds: 2 + index));
    setState(() {
      responses[index] = "Response from AI for ${criteriaList[index]}";
      isLoading[index] = false;
      completed++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JasaraPalette.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Counter",
                      style: JasaraTextStyles.primaryText500,
                    ),
                    Text(
                      "Showing $completed out of ${criteriaList.length} criteria evaluated.",
                      style: JasaraTextStyles.primaryText400,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Final Score",
                      style: JasaraTextStyles.primaryText500,
                    ),
                    Text(
                      "Average Score: ${(responses.where((e) => e != null).length * 10).toDouble() / (criteriaList.length)}",
                      style: JasaraTextStyles.primaryText400,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: criteriaList.length,
                itemBuilder: (context, index) {
                  return _buildCriteriaCard(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriteriaCard(int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(criteriaList[index], style: JasaraTextStyles.primaryText500),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: JasaraPalette.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: JasaraPalette.primary.withOpacity(0.3),
                ),
              ),
              child:
                  isLoading[index]
                      ? _buildSparkleLoader()
                      : Text(
                        responses[index] ?? "--",
                        style: JasaraTextStyles.primaryText400,
                      ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: JasaraPalette.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isLoading[index] ? "Calculating..." : "Score: 10",
                  style: JasaraTextStyles.primaryText400,
                ),
              ),
            ),
          ],
        ),
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
          onEnd: () => setState(() {}),
        ),
      ),
    );
  }
}
