import 'package:flutter/material.dart';
import '../models/category.dart';
import '../utils/category_helper.dart';
import 'category_illustrations.dart';

/// Category card widget for the 2-column grid matching Screenshot 2.
class CategoryCard extends StatelessWidget {
  final Category category;
  final int index;
  final bool isLastPlayed;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.index,
    this.isLastPlayed = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pastelColor = CategoryHelper.getPastelColor(index, category.name);
    final displayName = CategoryHelper.formatCategoryName(category.name);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        splashColor: Colors.black.withValues(alpha: 0.05),
        highlightColor: Colors.black.withValues(alpha: 0.03),
        child: Container(
          decoration: BoxDecoration(
            color: pastelColor,
            borderRadius: BorderRadius.circular(22),
            border: isLastPlayed
                ? Border.all(color: const Color(0xFF006D68), width: 2.2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Illustration area occupying upper card space
              Expanded(
                child: Center(
                  child: CategoryGraphic(
                    categoryName: category.name,
                    categoryId: category.id,
                    size: 92,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Category Name aligned bottom-left
              Text(
                displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15.5,
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
    );
  }
}
