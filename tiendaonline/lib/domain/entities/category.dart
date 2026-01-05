class Category {
  final String id;
  final String name;
  final String slug;
  final String? parentId;
  final int order;
  final bool active;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.parentId,
    required this.order,
    required this.active,
    required this.createdAt,
  });
}
