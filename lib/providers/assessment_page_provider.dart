import 'package:flutter/material.dart';

class MockResponseGenerator {
  static final List<Map<String, dynamic>> mockResponses = [
    {
      'criteria': 'Code Quality',
      'response':
          'The code demonstrates solid structure with clear modularization and consistent naming conventions.',
      'score': 8.5,
      'delay': const Duration(seconds: 2),
    },
    {
      'criteria': 'Performance Optimization',
      'response':
          'Efficient algorithms used, but some areas could benefit from caching mechanisms.',
      'score': 7.8,
      'delay': const Duration(seconds: 3),
    },
    {
      'criteria': 'Documentation',
      'response':
          'Comprehensive documentation with clear examples, though some edge cases are not covered.',
      'score': 8.0,
      'delay': const Duration(seconds: 1),
    },
    {
      'criteria': 'Error Handling',
      'response':
          'Robust error handling implemented, with clear error messages and recovery paths.',
      'score': 8.7,
      'delay': const Duration(seconds: 4),
    },
  ];

  static Future<Map<String, dynamic>> fetchMockResponse(int index) async {
    await Future.delayed(mockResponses[index]['delay']);
    return mockResponses[index];
  }
}

class AssessmentPageProvider extends ChangeNotifier {
  List<String> _criteria = [];
  List<String> _responses = [];
  List<double> _scores = [];
  List<bool> _loadingStates = [];
  bool _isSubmitting = false;

  List<String> get criteria => _criteria;
  List<String> get responses => _responses;
  List<double> get scores => _scores;
  List<bool> get loadingStates => _loadingStates;
  bool get isSubmitting => _isSubmitting;

  double get averageScore =>
      _scores.isEmpty
          ? 0.0
          : (_scores.reduce((a, b) => a + b) / _scores.length);

  AssessmentPageProvider() {
    _initializeData();
  }

  void _initializeData() {
    _criteria =
        MockResponseGenerator.mockResponses
            .map((e) => e['criteria'] as String)
            .toList();
    _responses = List.filled(_criteria.length, '');
    _scores = List.filled(_criteria.length, 0.0);
    _loadingStates = List.filled(_criteria.length, true);
    _fetchAllResponses();
  }

  Future<void> _fetchAllResponses() async {
    final futures = List.generate(
      _criteria.length,
      (index) => MockResponseGenerator.fetchMockResponse(index),
    );

    final results = await Future.wait(futures);

    for (int i = 0; i < results.length; i++) {
      _responses[i] = results[i]['response'] as String;
      _scores[i] = results[i]['score'] as double;
      _loadingStates[i] = false;
      notifyListeners();
    }
  }

  void submitAssessment() {
    if (_isSubmitting || _loadingStates.contains(true)) return;
    _isSubmitting = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      _isSubmitting = false;
      notifyListeners();
    });
  }
}

// Sparkle Animation Widget
class SparkleAnimation extends StatefulWidget {
  final Widget child;
  const SparkleAnimation({super.key, required this.child});

  @override
  _SparkleAnimationState createState() => _SparkleAnimationState();
}

class _SparkleAnimationState extends State<SparkleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}
