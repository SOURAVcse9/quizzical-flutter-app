import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Class representing category visual metadata including 3D asset, background, and accent colors.
class CategoryVisual {
  final String imagePath;
  final Color backgroundColor;
  final Color accentColor;
  final IconData icon;

  const CategoryVisual({
    required this.imagePath,
    required this.backgroundColor,
    required this.accentColor,
    required this.icon,
  });
}

/// Helper utility for OpenTDB category icons, cleaned display names, and pastel styling matching Figma.
class CategoryHelper {
  /// Cleans category names by removing prefixes like "Entertainment: " or "Science: "
  static String formatCategoryName(String rawName) {
    if (rawName.contains(': ')) {
      final parts = rawName.split(': ');
      if (parts.length > 1) {
        return parts[1].trim();
      }
    }
    return rawName;
  }

  /// Strict 1-to-1 Mapping of EVERY OpenTDB category ID (9–32) to its OWN UNIQUE 3D Asset
  static const Map<int, CategoryVisual> categoryVisualMap = {
    // 9: General Knowledge
    9: CategoryVisual(
      imagePath: 'assets/categories/general_knowledge.png',
      backgroundColor: Color(0xFFC7D9FE),
      accentColor: Color(0xFF2563EB),
      icon: Icons.public_rounded,
    ),
    // 10: Entertainment: Books
    10: CategoryVisual(
      imagePath: 'assets/categories/books.png',
      backgroundColor: Color(0xFFBBF7D0),
      accentColor: Color(0xFF16A34A),
      icon: Icons.menu_book_rounded,
    ),
    // 11: Entertainment: Film
    11: CategoryVisual(
      imagePath: 'assets/categories/film.png',
      backgroundColor: Color(0xFFFFD6D6),
      accentColor: Color(0xFFE11D48),
      icon: Icons.movie_creation_rounded,
    ),
    // 12: Entertainment: Music
    12: CategoryVisual(
      imagePath: 'assets/categories/music.png',
      backgroundColor: Color(0xFFEDE9FE),
      accentColor: Color(0xFF7C3AED),
      icon: Icons.music_note_rounded,
    ),
    // 13: Entertainment: Musicals & Theatres
    13: CategoryVisual(
      imagePath: 'assets/categories/musicals.png',
      backgroundColor: Color(0xFFFFE4E6),
      accentColor: Color(0xFFBE185D),
      icon: Icons.theater_comedy_rounded,
    ),
    // 14: Entertainment: Television
    14: CategoryVisual(
      imagePath: 'assets/categories/television.png',
      backgroundColor: Color(0xFFE0F2FE),
      accentColor: Color(0xFF0284C7),
      icon: Icons.tv_rounded,
    ),
    // 15: Entertainment: Video Games
    15: CategoryVisual(
      imagePath: 'assets/categories/video_games.png',
      backgroundColor: Color(0xFFE0E7FF),
      accentColor: Color(0xFF4F46E5),
      icon: Icons.sports_esports_rounded,
    ),
    // 16: Entertainment: Board Games
    16: CategoryVisual(
      imagePath: 'assets/categories/board_games.png',
      backgroundColor: Color(0xFFCCFBF1),
      accentColor: Color(0xFF0D9488),
      icon: Icons.casino_rounded,
    ),
    // 17: Science & Nature
    17: CategoryVisual(
      imagePath: 'assets/categories/science_nature.png',
      backgroundColor: Color(0xFFE9D5FF),
      accentColor: Color(0xFF9333EA),
      icon: Icons.science_rounded,
    ),
    // 18: Science: Computers
    18: CategoryVisual(
      imagePath: 'assets/categories/computers.png',
      backgroundColor: Color(0xFFCFFAFE),
      accentColor: Color(0xFF0891B2),
      icon: Icons.computer_rounded,
    ),
    // 19: Science: Mathematics
    19: CategoryVisual(
      imagePath: 'assets/categories/mathematics.png',
      backgroundColor: Color(0xFFF1F5F9),
      accentColor: Color(0xFF475569),
      icon: Icons.calculate_rounded,
    ),
    // 20: Mythology
    20: CategoryVisual(
      imagePath: 'assets/categories/mythology.png',
      backgroundColor: Color(0xFFFEF3C7),
      accentColor: Color(0xFFD97706),
      icon: Icons.auto_awesome_rounded,
    ),
    // 21: Sports
    21: CategoryVisual(
      imagePath: 'assets/categories/sports.png',
      backgroundColor: Color(0xFFFFEDD5),
      accentColor: Color(0xFFEA580C),
      icon: Icons.sports_soccer_rounded,
    ),
    // 22: Geography
    22: CategoryVisual(
      imagePath: 'assets/categories/geography.png',
      backgroundColor: Color(0xFFD1FAE5),
      accentColor: Color(0xFF059669),
      icon: Icons.map_rounded,
    ),
    // 23: History
    23: CategoryVisual(
      imagePath: 'assets/categories/history.png',
      backgroundColor: Color(0xFFFEF08A),
      accentColor: Color(0xFFCA8A04),
      icon: Icons.history_edu_rounded,
    ),
    // 24: Politics
    24: CategoryVisual(
      imagePath: 'assets/categories/politics.png',
      backgroundColor: Color(0xFFE2E8F0),
      accentColor: Color(0xFF334155),
      icon: Icons.how_to_vote_rounded,
    ),
    // 25: Art
    25: CategoryVisual(
      imagePath: 'assets/categories/art.png',
      backgroundColor: Color(0xFFFFD6D6),
      accentColor: Color(0xFFE11D48),
      icon: Icons.palette_rounded,
    ),
    // 26: Celebrities
    26: CategoryVisual(
      imagePath: 'assets/categories/celebrities.png',
      backgroundColor: Color(0xFFFEF9C3),
      accentColor: Color(0xFFCA8A04),
      icon: Icons.star_rounded,
    ),
    // 27: Animals
    27: CategoryVisual(
      imagePath: 'assets/categories/animals.png',
      backgroundColor: Color(0xFFDCFCE7),
      accentColor: Color(0xFF16A34A),
      icon: Icons.pets_rounded,
    ),
    // 28: Vehicles
    28: CategoryVisual(
      imagePath: 'assets/categories/vehicles.png',
      backgroundColor: Color(0xFFFFEDD5),
      accentColor: Color(0xFFEA580C),
      icon: Icons.directions_car_rounded,
    ),
    // 29: Entertainment: Comics
    29: CategoryVisual(
      imagePath: 'assets/categories/comics.png',
      backgroundColor: Color(0xFFFFE4E6),
      accentColor: Color(0xFFDC2626),
      icon: Icons.import_contacts_rounded,
    ),
    // 30: Science: Gadgets
    30: CategoryVisual(
      imagePath: 'assets/categories/gadgets.png',
      backgroundColor: Color(0xFFCCFBF1),
      accentColor: Color(0xFF0F766E),
      icon: Icons.devices_other_rounded,
    ),
    // 31: Entertainment: Japanese Anime & Manga
    31: CategoryVisual(
      imagePath: 'assets/categories/japanese_anime_manga.png',
      backgroundColor: Color(0xFFFCE7F3),
      accentColor: Color(0xFFDB2777),
      icon: Icons.animation_rounded,
    ),
    // 32: Entertainment: Cartoon & Animations
    32: CategoryVisual(
      imagePath: 'assets/categories/cartoon_animations.png',
      backgroundColor: Color(0xFFFEF3C7),
      accentColor: Color(0xFFB45309),
      icon: Icons.draw_rounded,
    ),
  };

  /// Fallback visual for any unknown category ID
  static CategoryVisual getFallbackVisual([int index = 0]) {
    final fallbackPastel = AppColors.categoryPastels[index % AppColors.categoryPastels.length];
    final fallbackAccent = AppColors.categoryIconColors[index % AppColors.categoryIconColors.length];
    return CategoryVisual(
      imagePath: 'assets/categories/default.png',
      backgroundColor: fallbackPastel,
      accentColor: fallbackAccent,
      icon: Icons.lightbulb_rounded,
    );
  }

  /// Maps a category by its ID (primary) or name (secondary) to its unique 3D visual package
  static CategoryVisual getVisual(int categoryId, String categoryName, [int index = 0]) {
    // 1. Direct Primary Lookup by Category ID
    if (categoryVisualMap.containsKey(categoryId)) {
      return categoryVisualMap[categoryId]!;
    }

    // 2. Name-based secondary lookup for custom or unmapped IDs
    final lower = categoryName.toLowerCase();
    for (final entry in categoryVisualMap.entries) {
      if (entry.key == 9 && lower.contains('general knowledge')) return entry.value;
      if (entry.key == 10 && (lower.contains('book') || lower.contains('literature'))) return entry.value;
      if (entry.key == 11 && (lower.contains('film') || lower.contains('movie') || lower.contains('cinema'))) return entry.value;
      if (entry.key == 12 && (lower.contains('music') || lower.contains('song')) && !lower.contains('musical')) return entry.value;
      if (entry.key == 13 && (lower.contains('musical') || lower.contains('theatre') || lower.contains('theater'))) return entry.value;
      if (entry.key == 14 && (lower.contains('television') || lower.contains('tv'))) return entry.value;
      if (entry.key == 15 && lower.contains('video game')) return entry.value;
      if (entry.key == 16 && lower.contains('board game')) return entry.value;
      if (entry.key == 17 && (lower.contains('science & nature') || lower.contains('nature'))) return entry.value;
      if (entry.key == 18 && lower.contains('computer')) return entry.value;
      if (entry.key == 19 && (lower.contains('math') || lower.contains('calculate'))) return entry.value;
      if (entry.key == 20 && lower.contains('mythology')) return entry.value;
      if (entry.key == 21 && lower.contains('sport')) return entry.value;
      if (entry.key == 22 && lower.contains('geography')) return entry.value;
      if (entry.key == 23 && lower.contains('history')) return entry.value;
      if (entry.key == 24 && (lower.contains('politic') || lower.contains('vote'))) return entry.value;
      if (entry.key == 25 && (lower.contains('art') || lower.contains('paint'))) return entry.value;
      if (entry.key == 26 && (lower.contains('celebrities') || lower.contains('star'))) return entry.value;
      if (entry.key == 27 && (lower.contains('animal') || lower.contains('pet'))) return entry.value;
      if (entry.key == 28 && (lower.contains('vehicle') || lower.contains('car'))) return entry.value;
      if (entry.key == 29 && lower.contains('comic')) return entry.value;
      if (entry.key == 30 && lower.contains('gadget')) return entry.value;
      if (entry.key == 31 && (lower.contains('anime') || lower.contains('manga'))) return entry.value;
      if (entry.key == 32 && (lower.contains('cartoon') || lower.contains('animation'))) return entry.value;
    }

    // 3. True unknown fallback
    return getFallbackVisual(index);
  }

  /// Validation method ensuring NO two known categories share the same image asset
  static bool assertUniqueCategoryAssets() {
    final seenPaths = <String, int>{};
    for (final entry in categoryVisualMap.entries) {
      final path = entry.value.imagePath;
      if (seenPaths.containsKey(path)) {
        if (kDebugMode) {
          debugPrint(
            'ERROR: Duplicate category asset detected!\n'
            'Category ID ${seenPaths[path]} and Category ID ${entry.key} both use: $path',
          );
        }
        return false;
      }
      seenPaths[path] = entry.key;
    }
    if (kDebugMode) {
      debugPrint('VALIDATION PASSED: All ${categoryVisualMap.length} categories have 100% unique 3D illustrations.');
    }
    return true;
  }

  /// Maps a category ID or name to a suitable Material icon
  static IconData getCategoryIcon(int categoryId, String categoryName) {
    return getVisual(categoryId, categoryName).icon;
  }

  /// Returns category pastel color matching Figma
  static Color getPastelColor(int index, [String? categoryName, int? categoryId]) {
    if (categoryId != null && categoryVisualMap.containsKey(categoryId)) {
      return categoryVisualMap[categoryId]!.backgroundColor;
    }
    if (categoryName != null) {
      return getVisual(categoryId ?? 0, categoryName, index).backgroundColor;
    }
    return AppColors.categoryPastels[index % AppColors.categoryPastels.length];
  }

  /// Gets icon accent color
  static Color getIconColor(int index, [String? categoryName, int? categoryId]) {
    if (categoryId != null && categoryVisualMap.containsKey(categoryId)) {
      return categoryVisualMap[categoryId]!.accentColor;
    }
    if (categoryName != null) {
      return getVisual(categoryId ?? 0, categoryName, index).accentColor;
    }
    return AppColors.categoryIconColors[index % AppColors.categoryIconColors.length];
  }
}
