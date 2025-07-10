import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/api/api_response.dart';
import '../providers/assessment_provider.dart';

class AssessmentPage extends StatelessWidget {
  const AssessmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssessmentProvider>(context);
    final result = provider.result;

    return Scaffold(
      appBar: AppBar(title: const Text("AI Assessment")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (result.status == Status.loading)
              const CircularProgressIndicator()
            else if (result.status == Status.completed)
              Text("✅ Score: ${result.data}")
            else if (result.status == Status.error)
              Text("❌ Error: ${result.message}"),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                provider.submitAssessment({
                  "rfp": "mock.pdf",
                  "go_no_go": "mock.pdf",
                });
              },
              child: const Text("Submit Dummy Assessment"),
            ),
          ],
        ),
      ),
    );
  }
}
