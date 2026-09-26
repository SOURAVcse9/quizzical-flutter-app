import 'package:flutter/material.dart';

/// Screen 1 Hero Illustration using the generated 3D claymorphism asset matching Screenshot 1.
class WelcomeIllustration extends StatelessWidget {
  final double size;

  const WelcomeIllustration({super.key, this.size = 230});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.asset(
          'assets/quiz/welcome_hero.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/welcome_hero.jpg',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => _buildFallback(size),
          ),
        ),
      ),
    );
  }

  Widget _buildFallback(double s) {
    return Container(
      width: s,
      height: s,
      decoration: const BoxDecoration(
        color: Color(0xFFFEF3C7),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.quiz_rounded, size: 80, color: Color(0xFF006D68)),
      ),
    );
  }
}

/// Screen 3 Configuration Illustration using the 3D control panel asset.
class ConfigIllustration extends StatelessWidget {
  final double size;

  const ConfigIllustration({super.key, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          'assets/quiz/configuration.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/config_gear.jpg',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.tune_rounded, size: 64, color: Color(0xFF0284C7)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Screen 5 High Score Party Popper Illustration using the 3D confetti horn asset matching Screenshot 3.
class HighScoreIllustration extends StatelessWidget {
  final double size;

  const HighScoreIllustration({super.key, this.size = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          'assets/result/celebration.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/result_popper.jpg',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emoji_events_rounded, size: 80, color: Color(0xFFD97706)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Screen 5 Keep Trying Illustration using friendly encouragement asset.
class LowScoreIllustration extends StatelessWidget {
  final double size;

  const LowScoreIllustration({super.key, this.size = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          'assets/result/keep_trying.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/quiz/welcome_hero.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEDD5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology_rounded, size: 80, color: Color(0xFFEA580C)),
            ),
          ),
        ),
      ),
    );
  }
}
