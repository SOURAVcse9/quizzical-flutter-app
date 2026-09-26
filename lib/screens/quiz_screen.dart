import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/answer_option.dart';
import '../widgets/primary_button.dart';
import 'result_screen.dart';

/// Screen 4: Active Quiz Screen
/// Matches Figma Screenshots 4 & 5:
/// - Centered question counter (e.g. 7/10)
/// - EXIT button on top right with confirmation dialog
/// - Linear blue progress bar
/// - Live timer and Streak counter (🔥 streak)
/// - Answer cards with green check and red cross visual feedback
/// - Bottom Next button
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  void _onExitPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Exit Quiz?',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: const Text(
          'Are you sure you want to exit the quiz? Your current progress will be lost.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<QuizProvider>().resetAll();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _onNextPressed(BuildContext context, QuizProvider provider) {
    final hasNext = provider.nextQuestion();
    if (!hasNext) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResultScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final question = provider.currentQuestion;

    if (question == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No question available', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    }

    final currentIndex = provider.currentQuestionIndex + 1;
    final total = provider.totalQuestions;
    final progress = provider.quizProgress;
    final streak = provider.currentStreak;
    final remainingTime = provider.remainingSeconds;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onExitPressed(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Integrated Timer Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: remainingTime <= 5 ? AppColors.errorLight : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 14,
                        color: remainingTime <= 5 ? AppColors.error : const Color(0xFF475569),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${remainingTime}s',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: remainingTime <= 5 ? AppColors.error : const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          leadingWidth: 80,
          centerTitle: true,
          title: Text(
            '$currentIndex/$total',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          actions: [
            // Figma EXIT Button on Top Right
            InkWell(
              onTap: () => _onExitPressed(context),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: const [
                    Text(
                      'EXIT',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: Color(0xFF1E293B),
                    ),
                  ],
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Streak Banner (if user has active streak >= 2)
              if (streak >= 2)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 24, right: 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 15)),
                        const SizedBox(width: 6),
                        Text(
                          '$streak answer streak! Keep it going!',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question Card matching Figma
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          question.question,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                            height: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Shuffled Answers List
                      ...question.allAnswers.map((answer) {
                        final isSelected = provider.selectedAnswer == answer;
                        final isCorrect = answer == question.correctAnswer;
                        final isUserSelectedIncorrect =
                            provider.isAnswerSubmitted && isSelected && !isCorrect;

                        return AnswerOption(
                          answerText: answer,
                          isSelected: isSelected,
                          isSubmitted: provider.isAnswerSubmitted,
                          isCorrect: isCorrect,
                          isUserSelectedIncorrect: isUserSelectedIncorrect,
                          onTap: () => provider.selectAnswer(answer),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Bottom Next CTA Button matching Figma
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: PrimaryButton(
                  text: 'Next',
                  backgroundColor: const Color(0xFF006D68),
                  borderRadius: 18,
                  height: 56,
                  onPressed: provider.isAnswerSubmitted
                      ? () => _onNextPressed(context, provider)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
