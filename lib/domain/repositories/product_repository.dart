import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductDetails(String slug);
  Future<List<ProductModel>> getProductsByCategory(int categoryId);
  Future<List<ProductModel>> getNewArrivals();
  Future<List<ProductModel>> getFeaturedProducts();
}