import 'package:flutter/material.dart';
import 'package:jasara_poc/widgets/utils/app_palette.dart';
import 'package:provider/provider.dart';
import '../core/services/api/api_response.dart';
import '../providers/assessment_provider.dart';
import '../widgets/utils/app_textStyles.dart';

class AssessmentPage extends StatelessWidget {
  const AssessmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssessmentProvider>(context);
    final result = provider.result;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "AI Assessment",
                style: JasaraTextStyles.primaryText500.copyWith(
                  fontSize: 22,
                  color: JasaraPalette.dark2,
                ),
              ),
            ),
            Expanded(
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
          ],
        ),
      ),
    );
  }
}
