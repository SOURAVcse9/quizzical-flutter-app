import 'package:flutter/material.dart';
import '../models/category.dart';
import '../providers/quiz_provider.dart';
import '../utils/category_helper.dart';
import 'category_illustrations.dart';

/// Category card widget for the 2-column grid matching Screenshot 2
/// with heart favorite toggle, micro-press animation, and personal stats badge.
class CategoryCard extends StatefulWidget {
  final Category category;
  final int index;
  final bool isLastPlayed;
  final bool isFavorite;
  final CategoryStats stats;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const CategoryCard({
    super.key,
    required this.category,
    required this.index,
    this.isLastPlayed = false,
    this.isFavorite = false,
    required this.stats,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final pastelColor = CategoryHelper.getPastelColor(
      widget.index,
      widget.category.name,
      widget.category.id,
    );
    final displayName = CategoryHelper.formatCategoryName(widget.category.name);

    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          borderRadius: BorderRadius.circular(22),
          splashColor: Colors.black.withValues(alpha: 0.05),
          highlightColor: Colors.black.withValues(alpha: 0.03),
          child: Container(
            decoration: BoxDecoration(
              color: pastelColor,
              borderRadius: BorderRadius.circular(22),
              border: widget.isLastPlayed
                  ? Border.all(color: const Color(0xFF006D68), width: 2.2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: optional stats badge + favorite heart button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Badge: "Best 90%" or "🔥 Popular" or "Played 3x"
                    if (widget.stats.bestScore > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 12, color: Color(0xFFD97706)),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.stats.bestScore}%',
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (widget.category.id == 9 || widget.category.id == 17 || widget.category.id == 11)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '🔥 Popular',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEA580C),
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),

                    // Heart favorite button
                    InkWell(
                      onTap: widget.onToggleFavorite,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          widget.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 19,
                          color: widget.isFavorite
                              ? const Color(0xFFE11D48)
                              : Colors.black.withValues(alpha: 0.28),
                        ),
                      ),
                    ),
                  ],
                ),

                // Illustration area occupying upper/middle card space
                Expanded(
                  child: Center(
                    child: CategoryGraphic(
                      categoryName: widget.category.name,
                      categoryId: widget.category.id,
                      size: 96,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Category Name aligned bottom-left
                Text(
                  displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2C3E50),
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
