import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/category_card.dart';
import '../widgets/primary_button.dart';
import 'quiz_config_screen.dart';

/// Screen 2: Category Selection Screen
/// Exact match with reference screenshot 2:
/// - Title: "Quizzical"
/// - Subtitle: "choose a category to focus on:"
/// - 2-column grid of tall rounded pastel cards with large illustrations.
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().fetchCategories();
    });
  }

  void _onCategorySelected(Category category) {
    context.read<QuizProvider>().setSelectedCategory(category);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QuizConfigScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/app_logo.jpg',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Quizzical',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingCategories) {
            return _buildLoadingState();
          }

          if (provider.categoriesError != null) {
            return _buildErrorState(provider);
          }

          final allCategories = provider.categories;

          if (allCategories.isEmpty) {
            return _buildEmptyState(provider);
          }

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtitle matching Screenshot 2 typography
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0, bottom: 12.0),
                  child: Text(
                    'choose a category to focus on:',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                // 2-Column Grid matching Screenshot 2
                Expanded(
                  child: RefreshIndicator(
                    color: const Color(0xFF006D68),
                    onRefresh: () => provider.fetchCategories(forceRefresh: true),
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.84, // Tall rounded rectangular cards matching Screenshot 2
                      ),
                      itemCount: allCategories.length,
                      itemBuilder: (context, index) {
                        final category = allCategories[index];
                        final isLastPlayed = category.id == provider.lastPlayedCategoryId;

                        return CategoryCard(
                          category: category,
                          index: index,
                          isLastPlayed: isLastPlayed,
                          onTap: () => _onCategorySelected(category),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0, bottom: 12.0),
            child: Container(
              width: 220,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.84,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 90,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(QuizProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: AppColors.error,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.categoriesError ?? 'Could not load categories.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 160,
              child: PrimaryButton(
                text: 'Retry',
                icon: Icons.refresh_rounded,
                backgroundColor: const Color(0xFF006D68),
                height: 48,
                onPressed: () => provider.fetchCategories(forceRefresh: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(QuizProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.category_outlined, size: 56, color: AppColors.textMuted),
          const SizedBox(height: 16),
          const Text(
            'No categories available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => provider.fetchCategories(forceRefresh: true),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
