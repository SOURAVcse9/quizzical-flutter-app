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

  /// Maps a category to its complete 3D visual package
  static CategoryVisual getVisual(int categoryId, String categoryName, [int index = 0]) {
    final lower = categoryName.toLowerCase();

    if (lower.contains('general knowledge')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/general_knowledge.png',
        backgroundColor: Color(0xFFC7D9FE),
        accentColor: Color(0xFF2563EB),
        icon: Icons.public_rounded,
      );
    } else if (lower.contains('book') || lower.contains('literature')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/books.png',
        backgroundColor: Color(0xFFBBF7D0),
        accentColor: Color(0xFF16A34A),
        icon: Icons.menu_book_rounded,
      );
    } else if (lower.contains('history')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/history.png',
        backgroundColor: Color(0xFFFEF08A),
        accentColor: Color(0xFFCA8A04),
        icon: Icons.history_edu_rounded,
      );
    } else if (lower.contains('science & nature') || (lower.contains('science') && !lower.contains('computer') && !lower.contains('gadget') && !lower.contains('math'))) {
      return const CategoryVisual(
        imagePath: 'assets/categories/science_nature.png',
        backgroundColor: Color(0xFFE9D5FF),
        accentColor: Color(0xFF9333EA),
        icon: Icons.science_rounded,
      );
    } else if (lower.contains('art') || lower.contains('design')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/art.png',
        backgroundColor: Color(0xFFFFD6D6),
        accentColor: Color(0xFFE11D48),
        icon: Icons.palette_rounded,
      );
    } else if (lower.contains('vehicle')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/vehicles.png',
        backgroundColor: Color(0xFFFFEDD5),
        accentColor: Color(0xFFEA580C),
        icon: Icons.directions_car_rounded,
      );
    } else if (lower.contains('film') || lower.contains('movie') || lower.contains('theatre') || lower.contains('cinema')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/film.png',
        backgroundColor: Color(0xFFFFE4E6),
        accentColor: Color(0xFFE11D48),
        icon: Icons.movie_creation_rounded,
      );
    } else if (lower.contains('music') || lower.contains('musical') || lower.contains('audio') || lower.contains('song')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/music.png',
        backgroundColor: Color(0xFFEDE9FE),
        accentColor: Color(0xFF7C3AED),
        icon: Icons.music_note_rounded,
      );
    } else if (lower.contains('video game') || lower.contains('board game') || lower.contains('game')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/video_games.png',
        backgroundColor: Color(0xFFE0E7FF),
        accentColor: Color(0xFF4F46E5),
        icon: Icons.sports_esports_rounded,
      );
    } else if (lower.contains('computer') || lower.contains('gadget')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/computers.png',
        backgroundColor: Color(0xFFCCFBF1),
        accentColor: Color(0xFF0D9488),
        icon: Icons.computer_rounded,
      );
    } else if (lower.contains('sport')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/sports.png',
        backgroundColor: Color(0xFFFFEDD5),
        accentColor: Color(0xFFEA580C),
        icon: Icons.sports_soccer_rounded,
      );
    } else if (lower.contains('geography')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/geography.png',
        backgroundColor: Color(0xFFE0F2FE),
        accentColor: Color(0xFF0284C7),
        icon: Icons.map_rounded,
      );
    } else if (lower.contains('mythology')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/mythology.png',
        backgroundColor: Color(0xFFFEF3C7),
        accentColor: Color(0xFFD97706),
        icon: Icons.auto_awesome_rounded,
      );
    } else if (lower.contains('television') || lower.contains('tv')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/television.png',
        backgroundColor: Color(0xFFFFE4E6),
        accentColor: Color(0xFFBE185D),
        icon: Icons.tv_rounded,
      );
    } else if (lower.contains('animal')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/animals.png',
        backgroundColor: Color(0xFFDCFCE7),
        accentColor: Color(0xFF15803D),
        icon: Icons.pets_rounded,
      );
    } else if (lower.contains('math')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/mathematics.png',
        backgroundColor: Color(0xFFF1F5F9),
        accentColor: Color(0xFF475569),
        icon: Icons.calculate_rounded,
      );
    } else if (lower.contains('comic')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/comics.png',
        backgroundColor: Color(0xFFFFE4E6),
        accentColor: Color(0xFFE11D48),
        icon: Icons.import_contacts_rounded,
      );
    } else if (lower.contains('anime') || lower.contains('manga') || lower.contains('cartoon')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/anime.png',
        backgroundColor: Color(0xFFFCE7F3),
        accentColor: Color(0xFFDB2777),
        icon: Icons.animation_rounded,
      );
    } else if (lower.contains('politic')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/politics.png',
        backgroundColor: Color(0xFFE2E8F0),
        accentColor: Color(0xFF334155),
        icon: Icons.gavel_rounded,
      );
    } else if (lower.contains('celebrities')) {
      return const CategoryVisual(
        imagePath: 'assets/categories/celebrities.png',
        backgroundColor: Color(0xFFFEF9C3),
        accentColor: Color(0xFFCA8A04),
        icon: Icons.star_rounded,
      );
    }

    // Default fallback visual
    final fallbackPastel = AppColors.categoryPastels[index % AppColors.categoryPastels.length];
    final fallbackAccent = AppColors.categoryIconColors[index % AppColors.categoryIconColors.length];
    return CategoryVisual(
      imagePath: 'assets/categories/default_quiz.png',
      backgroundColor: fallbackPastel,
      accentColor: fallbackAccent,
      icon: Icons.lightbulb_rounded,
    );
  }

  /// Maps a category ID or name to a suitable Material icon
  static IconData getCategoryIcon(int categoryId, String categoryName) {
    return getVisual(categoryId, categoryName).icon;
  }

  /// Returns category pastel color matching Figma
  static Color getPastelColor(int index, [String? categoryName]) {
    if (categoryName != null) {
      return getVisual(0, categoryName, index).backgroundColor;
    }
    return AppColors.categoryPastels[index % AppColors.categoryPastels.length];
  }

  /// Gets icon accent color
  static Color getIconColor(int index, [String? categoryName]) {
    if (categoryName != null) {
      return getVisual(0, categoryName, index).accentColor;
    }
    return AppColors.categoryIconColors[index % AppColors.categoryIconColors.length];
  }
}
