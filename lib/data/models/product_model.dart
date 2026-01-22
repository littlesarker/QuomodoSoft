import 'dart:convert';

class ProductModel {
  final int id;
  final String name;
  final String shortName;
  final String slug;
  final String thumbImage;
  final double price;
  final double? offerPrice;
  final double averageRating;
  final int totalSold;
  final bool isNewProduct;
  final int categoryId; // Add this
  final String? shortDescription;
  final String? longDescription;


  ProductModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.slug,
    required this.thumbImage,
    required this.price,
    this.offerPrice,
    required this.averageRating,
    required this.totalSold,
    required this.isNewProduct,
    required this.categoryId,
    // Add this
    this.shortDescription,
    this.longDescription,

  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      shortName: json['short_name'] ?? '',
      slug: json['slug'] ?? '',
      thumbImage: json['thumb_image'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      offerPrice: json['offer_price'] != null
          ? (json['offer_price'] as num).toDouble()
          : null,
      averageRating: double.tryParse(json['averageRating']?.toString() ?? '0') ?? 0.0,
      totalSold: int.tryParse(json['totalSold']?.toString() ?? '0') ?? 0,
      isNewProduct: (json['new_product'] ?? 0) == 1,
      shortDescription: json['short_description'],
      longDescription: json['long_description'],
      categoryId: json['category_id'] ?? 0, // Add this
    );
  }

  String get fullImageUrl => 'https://mamunuiux.com/flutter_task/$thumbImage';

  double get discountPercentage {
    if (offerPrice == null || offerPrice == 0) return 0;
    return ((price - offerPrice!) / price * 100).roundToDouble();
  }
}