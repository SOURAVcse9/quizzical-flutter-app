import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/illustrations.dart';
import '../widgets/primary_button.dart';
import 'categories_screen.dart';

/// Screen 5: Quiz Results Screen
/// Exact match with reference screenshot 3 (media_1790271458129.png):
/// - Pure white background
/// - Centered celebration party popper with colorful confetti streamers
/// - "Congratulation" / "Keep Trying!"
/// - Rounded double-pill score container (outer light green + inner mint green with bold 80%)
/// - Subtitle message
/// - "PLAY AGAIN" teal button
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final score = provider.scorePercentage;
    final isSuccess = score >= 50;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        provider.resetAll();
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              final illustrationSize = (availableHeight * 0.32).clamp(160.0, 240.0);

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: availableHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(flex: 1),

                          // Illustration matching Screenshot 3
                          isSuccess
                              ? HighScoreIllustration(size: illustrationSize)
                              : LowScoreIllustration(size: illustrationSize),

                          const SizedBox(height: 28),

                          // Title matching Screenshot 3 typography
                          Text(
                            isSuccess ? 'Congratulation' : 'Keep Trying!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2C3E50),
                              letterSpacing: -0.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Score Box matching Screenshot 3 exact double-pill structure
                          if (isSuccess)
                            // Outer soft green pill + Inner mint green pill for High Score (Screenshot 3)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7), // Soft outer green halo
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF74DBA2), // Mint green inner pill matching screenshot 3
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  '$score%',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF2C3E50), // Dark charcoal/navy text matching screenshot 3
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                            )
                          else
                            // Outer soft coral halo + Inner red pill for Lower Score
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE4E6),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF5252),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  '$score%',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 44,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Subtitle message matching Screenshot 3
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              isSuccess
                                  ? "You've got a great foundation. Ready to try a\ndifferent category?"
                                  : "Don't give up! Practice makes perfect.\nTry again to improve your score.",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                                height: 1.4,
                              ),
                            ),
                          ),

                          const Spacer(flex: 2),

                          // PLAY AGAIN Button matching Screenshot 3
                          PrimaryButton(
                            text: 'PLAY AGAIN',
                            backgroundColor: const Color(0xFF006D68),
                            borderRadius: 20,
                            height: 56,
                            onPressed: () {
                              provider.resetQuizForReplay();
                              Navigator.of(context).pop();
                            },
                          ),

                          const SizedBox(height: 8),

                          // Secondary text link to choose another category
                          TextButton(
                            onPressed: () {
                              provider.resetAll();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const CategoriesScreen()),
                                (route) => route.isFirst,
                              );
                            },
                            child: const Text(
                              'Choose Another Category',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
