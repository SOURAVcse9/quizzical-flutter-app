import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_colors.dart';
import '../utils/category_helper.dart';
import '../widgets/category_card.dart';
import '../widgets/primary_button.dart';
import 'quiz_config_screen.dart';
import 'quiz_screen.dart';

enum CategoryFilter { all, favorites, recentlyPlayed, alphabetical }

/// Screen 2: Category Selection Screen
/// Full fidelity matching Screenshot 2 with:
/// - 1-to-1 unique 3D category illustrations
/// - Search with real-time filtering
/// - Favorites system with heart toggle
/// - Recently Played category carousel
/// - Daily Challenge card
/// - Personal category stats badges
/// - Zero-overflow responsive layout
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  CategoryFilter _selectedFilter = CategoryFilter.all;

  @override
  void initState() {
    super.initState();
    // Validate unique category assets in debug mode
    CategoryHelper.assertUniqueCategoryAssets();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().fetchCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(Category category) {
    context.read<QuizProvider>().setSelectedCategory(category);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QuizConfigScreen(),
      ),
    );
  }

  void _onStartDailyChallenge(QuizProvider provider) async {
    final success = await provider.startDailyChallenge();
    if (!mounted) return;
    if (success) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const QuizScreen(),
        ),
      );
    }
  }

  List<Category> _getFilteredCategories(List<Category> allCategories, QuizProvider provider) {
    List<Category> result = List.from(allCategories);

    // Filter by Tab
    switch (_selectedFilter) {
      case CategoryFilter.all:
        break;
      case CategoryFilter.favorites:
        result = result.where((c) => provider.isFavorite(c.id)).toList();
        break;
      case CategoryFilter.recentlyPlayed:
        final recentIds = provider.recentlyPlayedCategoryIds;
        result = result.where((c) => recentIds.contains(c.id)).toList();
        result.sort((a, b) {
          final indexA = recentIds.indexOf(a.id);
          final indexB = recentIds.indexOf(b.id);
          return indexA.compareTo(indexB);
        });
        break;
      case CategoryFilter.alphabetical:
        result.sort((a, b) {
          final nameA = CategoryHelper.formatCategoryName(a.name);
          final nameB = CategoryHelper.formatCategoryName(b.name);
          return nameA.toLowerCase().compareTo(nameB.toLowerCase());
        });
        break;
    }

    // Filter by Search Query
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      result = result.where((c) {
        final raw = c.name.toLowerCase();
        final clean = CategoryHelper.formatCategoryName(c.name).toLowerCase();
        return raw.contains(q) || clean.contains(q);
      }).toList();
    }

    return result;
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
                'assets/branding/quizzical_icon.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/app_logo.jpg',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
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
        actions: [
          // Search icon toggle
          IconButton(
            icon: Icon(
              _isSearchVisible ? Icons.search_off_rounded : Icons.search_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
          // Streak pill badge
          Consumer<QuizProvider>(
            builder: (context, provider, child) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      '${provider.dailyStreak}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
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

          final filteredCategories = _getFilteredCategories(allCategories, provider);
          final dailyCat = provider.getTodaysChallengeCategory();
          final recentCategories = provider.recentlyPlayedCategoryIds
              .map((id) => allCategories.cast<Category?>().firstWhere((c) => c?.id == id, orElse: () => null))
              .whereType<Category>()
              .take(5)
              .toList();

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Field (animated visibility)
                if (_isSearchVisible)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search categories (e.g. Science, Film)...',
                          hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                          prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF64748B)),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onChanged: (val) => setState(() => _searchQuery = val),
                      ),
                    ),
                  ),

                // Subtitle matching Screenshot 2
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0, bottom: 6.0),
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

                // Daily Challenge Card (when available and not searching)
                if (!_isSearchVisible && dailyCat != null && _selectedFilter == CategoryFilter.all)
                  _buildDailyChallengeCard(context, provider, dailyCat),

                // Filter & Sort Tabs
                _buildFilterChips(provider),

                // Recently Played Section (if available and filter is 'All' or 'Recently Played')
                if (!_isSearchVisible &&
                    recentCategories.isNotEmpty &&
                    _selectedFilter == CategoryFilter.all)
                  _buildRecentlyPlayedSection(recentCategories),

                // 2-Column Category Grid
                Expanded(
                  child: filteredCategories.isEmpty
                      ? _buildNoResultsState()
                      : RefreshIndicator(
                          color: const Color(0xFF006D68),
                          onRefresh: () => provider.fetchCategories(forceRefresh: true),
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.84,
                            ),
                            itemCount: filteredCategories.length,
                            itemBuilder: (context, index) {
                              final category = filteredCategories[index];
                              final isLastPlayed = category.id == provider.lastPlayedCategoryId;
                              final isFav = provider.isFavorite(category.id);
                              final stats = provider.getCategoryStats(category.id);

                              return CategoryCard(
                                category: category,
                                index: index,
                                isLastPlayed: isLastPlayed,
                                isFavorite: isFav,
                                stats: stats,
                                onToggleFavorite: () => provider.toggleFavorite(category.id),
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

  Widget _buildDailyChallengeCard(BuildContext context, QuizProvider provider, Category dailyCat) {
    final catName = CategoryHelper.formatCategoryName(dailyCat.name);
    final isDone = provider.isDailyChallengeCompletedToday;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE0F2FE), Color(0xFFEFF6FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFBAE6FD)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Text('🎯', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Challenge",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0369A1),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    catName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    isDone
                        ? 'Completed ✓ — Score: ${provider.dailyChallengeScore ?? 0}%'
                        : '🔥 10 Questions • Medium',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isDone ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDone ? Colors.white : const Color(0xFF006D68),
                foregroundColor: isDone ? const Color(0xFF006D68) : Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isDone ? const BorderSide(color: Color(0xFF006D68)) : BorderSide.none,
                ),
              ),
              onPressed: () => _onStartDailyChallenge(provider),
              child: Text(
                isDone ? 'Replay' : 'START',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(QuizProvider provider) {
    final favCount = provider.favoriteCategoryIds.length;
    final recentCount = provider.recentlyPlayedCategoryIds.length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Row(
        children: [
          _buildChip(CategoryFilter.all, 'All'),
          _buildChip(
            CategoryFilter.favorites,
            favCount > 0 ? '♥ Favorites ($favCount)' : 'Favorites',
          ),
          if (recentCount > 0)
            _buildChip(CategoryFilter.recentlyPlayed, 'Recently Played ($recentCount)'),
          _buildChip(CategoryFilter.alphabetical, 'A–Z'),
        ],
      ),
    );
  }

  Widget _buildChip(CategoryFilter filter, String label) {
    final isSelected = _selectedFilter == filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        labelStyle: TextStyle(
          fontSize: 12.5,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? Colors.white : const Color(0xFF475569),
        ),
        selected: isSelected,
        selectedColor: const Color(0xFF006D68),
        backgroundColor: const Color(0xFFF1F5F9),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isSelected ? const Color(0xFF006D68) : Colors.transparent,
          ),
        ),
        onSelected: (val) {
          if (val) setState(() => _selectedFilter = filter);
        },
      ),
    );
  }

  Widget _buildRecentlyPlayedSection(List<Category> recents) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 2.0),
      child: SizedBox(
        height: 38,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          itemCount: recents.length,
          itemBuilder: (context, index) {
            final cat = recents[index];
            final name = CategoryHelper.formatCategoryName(cat.name);
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ActionChip(
                backgroundColor: const Color(0xFFEFF6FF),
                side: const BorderSide(color: Color(0xFFBFDBFE)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                avatar: const Icon(Icons.history_rounded, size: 14, color: Color(0xFF2563EB)),
                label: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E40AF),
                  ),
                ),
                onPressed: () => _onCategorySelected(cat),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 54, color: Color(0xFF94A3B8)),
            const SizedBox(height: 14),
            Text(
              _selectedFilter == CategoryFilter.favorites
                  ? 'No favorites yet'
                  : 'No categories found',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 6),
            Text(
              _selectedFilter == CategoryFilter.favorites
                  ? 'Tap the heart icon on any category to add it here.'
                  : 'Try searching with a different term.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
            ),
          ],
        ),
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
