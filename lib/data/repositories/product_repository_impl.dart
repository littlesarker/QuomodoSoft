import 'dart:convert';

import '../../domain/repositories/product_repository.dart';
import '../datasources/api_client.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;

  ProductRepositoryImpl({required this.apiClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.get('api');
    final data = response['data']['categories'] as List;
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await apiClient.get('api/product');
    final data = response['data']['featured_products'] as List;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<ProductModel> getProductDetails(String slug) async {
    final response = await apiClient.get('api/product/$slug');
    // Note: API returns homepage data, adjust based on actual API
    final data = response['data']['featured_products'][0];
    return ProductModel.fromJson(data);
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final response = await apiClient.get('api/product-by-category/$categoryId');
    final data = response['data']['featured_products'] as List;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<List<ProductModel>> getNewArrivals() async {
    final response = await apiClient.get('api');
    final data = response['data']['new_arrival_products'] as List;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    final response = await apiClient.get('api');
    final data = response['data']['featured_products'] as List;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}