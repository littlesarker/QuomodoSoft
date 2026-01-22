
import 'package:mdrahim/data/models/product_model.dart';


//
// class ProductDetailModel {
//   final ProductModel product;
//   final List<Map<String, dynamic>> gallery;
//   final String longDescription;
//   final List<String> features;
//   final List<ProductModel> relatedProducts;
//
//   ProductDetailModel({
//     required this.product,
//     required this.gallery,
//     required this.longDescription,
//     required this.features,
//     required this.relatedProducts,
//   });
//
//   factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
//     final product = ProductModel.fromJson(json['product']);
//
//     final gallery = (json['gallery'] as List).cast<Map<String, dynamic>>();
//
//     final relatedProducts = (json['relatedProducts'] as List)
//         .map((item) => ProductModel.fromJson(item))
//         .toList();
//
//     // Extract features from long_description or active_variants
//     final features = <String>[];
//     if (json['product']['active_variants'] != null) {
//       final variants = json['product']['active_variants'] as List;
//       for (var variant in variants) {
//         if (variant['active_variant_items'] != null) {
//           final items = variant['active_variant_items'] as List;
//           for (var item in items) {
//             features.add('${item['name']}: \$${item['price']}');
//           }
//         }
//       }
//     }
//
//     return ProductDetailModel(
//       product: product,
//       gallery: gallery,
//       longDescription: json['product']['long_description'] ?? '',
//       features: features,
//       relatedProducts: relatedProducts,
//     );
//   }
// }

class ProductDetailModel {
  final ProductModel product;
  final List<GalleryImage> gallery;
  final List<ProductModel> relatedProducts;
  final String? longDescription;
  final List<String> features;

  ProductDetailModel({
    required this.product,
    required this.gallery,
    required this.relatedProducts,
    this.longDescription,
    this.features = const [],
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse main product
      ProductModel product;
      if (json['product'] != null && json['product'] is Map<String, dynamic>) {
        product = ProductModel.fromJson(json['product'] as Map<String, dynamic>);
      } else {
        // Create a fallback product
        product = ProductModel(
          id: json['id'] ?? 0,
          name: json['name']?.toString() ?? 'Product',
          shortName: json['short_name']?.toString() ?? '',
          slug: json['slug']?.toString() ?? '',
          thumbImage: json['thumb_image']?.toString() ?? '',
          price: (json['price'] ?? 0.0).toDouble(),
          offerPrice: json['offer_price'] != null
              ? (json['offer_price'] as num).toDouble()
              : null,
          averageRating: double.tryParse(json['averageRating']?.toString() ?? '0') ?? 0.0,
          totalSold: int.tryParse(json['totalSold']?.toString() ?? '0') ?? 0,
          isNewProduct: (json['new_product'] ?? 0) == 1,
          categoryId: json['category_id'] ?? 0,
          shortDescription: json['short_description']?.toString(),
          longDescription: json['long_description']?.toString(),
        );
      }

      // Parse gallery
      List<GalleryImage> gallery = [];
      if (json['gallery'] != null && json['gallery'] is List) {
        final galleryList = json['gallery'] as List;
        gallery = galleryList
            .whereType<Map<String, dynamic>>()
            .map((item) => GalleryImage.fromJson(item))
            .toList();
      }

      // Parse related products
      List<ProductModel> relatedProducts = [];
      if (json['relatedProducts'] != null && json['relatedProducts'] is List) {
        final relatedList = json['relatedProducts'] as List;
        relatedProducts = relatedList
            .whereType<Map<String, dynamic>>()
            .map((item) => ProductModel.fromJson(item))
            .toList();
      }

      // Parse long description
      String? longDescription;
      if (json['product'] is Map<String, dynamic>) {
        final productJson = json['product'] as Map<String, dynamic>;
        longDescription = productJson['long_description']?.toString();
      }

      // Parse features from active_variants
      List<String> features = [];
      if (json['product'] is Map<String, dynamic>) {
        final productJson = json['product'] as Map<String, dynamic>;
        if (productJson['active_variants'] is List) {
          final variants = productJson['active_variants'] as List;
          for (var variant in variants) {
            if (variant is Map<String, dynamic>) {
              final variantItems = variant['active_variant_items'];
              if (variantItems is List) {
                for (var item in variantItems) {
                  if (item is Map<String, dynamic>) {
                    final name = item['name']?.toString() ?? '';
                    final price = item['price']?.toString() ?? '0';
                    features.add('$name: \$$price');
                  }
                }
              }
            }
          }
        }
      }

      return ProductDetailModel(
        product: product,
        gallery: gallery,
        relatedProducts: relatedProducts,
        longDescription: longDescription,
        features: features,
      );
    } catch (e) {
      print('Error parsing ProductDetailModel: $e');
      // Return a basic model with the available data
      return ProductDetailModel(
        product: ProductModel(
          id: 0,
          name: 'Error Loading Product',
          shortName: '',
          slug: '',
          thumbImage: '',
          price: 0,
          averageRating: 0,
          totalSold: 0,
          isNewProduct: false,
          categoryId: 0,
        ),
        gallery: [],
        relatedProducts: [],
        longDescription: 'Failed to load product details.',
        features: [],
      );
    }
  }
}

class GalleryImage {
  final int id;
  final int productId;
  final String image;
  final int status;

  GalleryImage({
    required this.id,
    required this.productId,
    required this.image,
    required this.status,
  });

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      id: json['id']?.toInt() ?? 0,
      productId: json['product_id']?.toInt() ?? 0,
      image: json['image']?.toString() ?? '',
      status: json['status']?.toInt() ?? 0,
    );
  }
}