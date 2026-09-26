import 'package:flutter/material.dart';
import '../utils/category_helper.dart';

/// Category graphic widget rendering high-quality 3D assets matching Screenshot 2.
class CategoryGraphic extends StatelessWidget {
  final String categoryName;
  final int categoryId;
  final double size;

  const CategoryGraphic({
    super.key,
    required this.categoryName,
    required this.categoryId,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    final visual = CategoryHelper.getVisual(categoryId, categoryName);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        visual.imagePath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildIcon(visual.icon, visual.accentColor),
      ),
    );
  }

  Widget _buildIcon(IconData icon, Color color) {
    return Container(
      width: size * 0.75,
      height: size * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: size * 0.45),
    );
  }
}
