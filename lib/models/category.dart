/// Category Model representing OpenTDB Trivia Category
/// Exam-friendly and clean implementation for viva explanation.
class Category {
  final int id;
  final String name;

  const Category({
    required this.id,
    required this.name,
  });

  /// Factory constructor to parse JSON response from https://opentdb.com/api_category.php
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  /// Converts Category instance back to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'Category(id: $id, name: $name)';
}
