import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_colors.dart';
import '../utils/category_helper.dart';
import '../widgets/illustrations.dart';
import '../widgets/primary_button.dart';
import 'quiz_screen.dart';

/// Screen 3: Quiz Configuration Screen
/// Fully redesigned to match Figma Screenshot 3:
/// Header illustration with hand toggle, 1-50 slider with blue counter, dropdowns, and START CTA.
class QuizConfigScreen extends StatefulWidget {
  const QuizConfigScreen({super.key});

  @override
  State<QuizConfigScreen> createState() => _QuizConfigScreenState();
}

class _QuizConfigScreenState extends State<QuizConfigScreen> {
  final List<String> _difficultyOptions = [
    'Any Difficulty',
    'Easy',
    'Medium',
    'Hard',
  ];

  final Map<String, String> _typeOptions = {
    'Multiple Choice': 'multiple',
    'True / False': 'boolean',
  };

  void _onStartQuiz() async {
    final provider = context.read<QuizProvider>();
    final success = await provider.startQuiz();

    if (!mounted) return;

    if (success) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const QuizScreen(),
        ),
      );
    } else {
      _showErrorDialog(provider.questionsError ?? 'Failed to load questions.');
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: AppColors.error),
            SizedBox(width: 10),
            Text('Could not start quiz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text(
          error,
          style: const TextStyle(fontSize: 14.5, color: AppColors.textSecondary, height: 1.3),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006D68),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _onStartQuiz();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final selectedCategory = provider.selectedCategory;
    final categoryName = selectedCategory != null
        ? CategoryHelper.formatCategoryName(selectedCategory.name)
        : 'General Knowledge';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Figma Top Illustration matching Screenshot 3
              const ConfigIllustration(size: 140),

              const SizedBox(height: 16),

              // Title matching Figma
              const Text(
                'Quizzical',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2C3E50),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 6),

              // Subtitle
              const Text(
                'Configuration',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 4),

              // Category Name
              Text(
                categoryName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),

              const SizedBox(height: 28),

              // Number of Questions Section
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Number of Questions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select 1–50',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          '${provider.numberOfQuestions}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // Slider matching Figma blue track
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF0284C7),
                  inactiveTrackColor: const Color(0xFFE0F2FE),
                  thumbColor: const Color(0xFF0284C7),
                  overlayColor: const Color(0xFF0284C7).withValues(alpha: 0.12),
                  trackHeight: 5,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                ),
                child: Slider(
                  value: provider.numberOfQuestions.toDouble(),
                  min: 1,
                  max: 50,
                  divisions: 49,
                  onChanged: (val) {
                    provider.setNumberOfQuestions(val.round());
                  },
                ),
              ),

              const SizedBox(height: 18),

              // Difficulty Dropdown Section
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Difficulty Level',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: provider.difficulty,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                    items: _difficultyOptions.map((diff) {
                      return DropdownMenuItem<String>(
                        value: diff,
                        child: Text(
                          diff,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF334155),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) provider.setDifficulty(val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Question Type Dropdown Section
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Question Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: provider.questionType,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                    items: _typeOptions.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.value,
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF334155),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) provider.setQuestionType(val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // START Button matching Figma
              PrimaryButton(
                text: 'START',
                backgroundColor: const Color(0xFF006D68),
                borderRadius: 18,
                height: 56,
                isLoading: provider.isLoadingQuestions,
                onPressed: provider.isLoadingQuestions ? null : _onStartQuiz,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
