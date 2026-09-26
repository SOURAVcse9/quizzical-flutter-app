import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/illustrations.dart';
import '../widgets/primary_button.dart';
import 'categories_screen.dart';

/// Screen 1: Welcome Screen
/// Exact match with reference screenshot 1:
/// Pure white background, centered 3D character quiz illustration, "Quizzical", "Your_Name", and "GET STARTED".
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showEditNameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName == 'Your_Name' ? '' : currentName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.person_outline_rounded, color: AppColors.primary),
            SizedBox(width: 10),
            Text('Set Your Name', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          ],
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter student / player name',
            filled: true,
            fillColor: AppColors.surfaceMuted,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
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
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                context.read<QuizProvider>().setUserName(newName);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            // Responsive illustration size that dynamically adapts to screen height
            final illustrationSize = (availableHeight * 0.38).clamp(180.0, 270.0);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: availableHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(flex: 1),

                        // Centered 3D Question Avatar Illustration matching Screenshot 1
                        WelcomeIllustration(
                          size: illustrationSize,
                        ),

                        const SizedBox(height: 32),

                        // Title matching Screenshot 1 typography
                        const Text(
                          'Quizzical',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2C3E50),
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // "Your_Name" Subtitle matching Screenshot 1 (with tap-to-edit)
                        InkWell(
                          onTap: () => _showEditNameDialog(context, provider.userName),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  provider.userName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Color(0xFF4A5568),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.edit_outlined,
                                  size: 16,
                                  color: AppColors.textMuted,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(flex: 2),

                        // GET STARTED Button matching Screenshot 1
                        PrimaryButton(
                          text: 'GET STARTED',
                          backgroundColor: const Color(0xFF006D68),
                          borderRadius: 20,
                          height: 56,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CategoriesScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
