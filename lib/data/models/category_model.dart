class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String icon;
  final String? image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      icon: json['icon'] ?? '',
      image: json['image'],
    );
  }
}