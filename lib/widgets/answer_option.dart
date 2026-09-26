import 'package:flutter/material.dart';

/// Answer option widget for QuizScreen matching Figma screenshot 4 & 5.
class AnswerOption extends StatelessWidget {
  final String answerText;
  final bool isSelected;
  final bool isSubmitted;
  final bool isCorrect;
  final bool isUserSelectedIncorrect;
  final VoidCallback? onTap;

  const AnswerOption({
    super.key,
    required this.answerText,
    required this.isSelected,
    required this.isSubmitted,
    required this.isCorrect,
    required this.isUserSelectedIncorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color(0xFFF8FAFC);
    Color textColor = const Color(0xFF1E293B);
    Widget indicator = Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF94A3B8), width: 1.8),
      ),
    );

    if (isSubmitted) {
      if (isCorrect) {
        // Figma Green Correct State (Page 4)
        backgroundColor = const Color(0xFFA7D7C5); // Soft Figma teal-green
        textColor = const Color(0xFF064E3B);
        indicator = Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF0E7A75),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
        );
      } else if (isUserSelectedIncorrect) {
        // Figma Red/Coral Incorrect State (Page 5)
        backgroundColor = const Color(0xFFFFA8A8); // Soft Figma coral-red
        textColor = const Color(0xFF7F1D1D);
        indicator = Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFEF4444),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
        );
      } else {
        backgroundColor = const Color(0xFFF1F5F9);
        textColor = const Color(0xFF64748B);
      }
    } else if (isSelected) {
      backgroundColor = const Color(0xFFE0F2FE);
      textColor = const Color(0xFF0369A1);
      indicator = Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF0284C7), width: 6),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSubmitted ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    answerText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected || (isSubmitted && (isCorrect || isUserSelectedIncorrect))
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: textColor,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                indicator,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
