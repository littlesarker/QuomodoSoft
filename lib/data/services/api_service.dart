import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/home_response_model.dart';
import '../models/product_detail_model.dart';
import '../models/product_model.dart';

class ApiService {
  final http.Client client;

  ApiService({required this.client});

  Future<HomeResponseModel> getHomeData() async {
    try {
      final response = await client.get(Uri.parse(ApiConstants.homeData));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return HomeResponseModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load home data');
      }
    } catch (e) {
      throw Exception('Failed to load home data: $e');
    }
  }

  Future<List<ProductModel>> getProducts({int page = 1}) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.productList}?page=$page'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final productsList = (jsonData['products']['data'] as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();
        return productsList;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      final response = await client.get(
        Uri.parse(ApiConstants.productsByCategory(categoryId)),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final productsList = (jsonData['products'] as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();
        return productsList;
      } else {
        throw Exception('Failed to load category products');
      }
    } catch (e) {
      throw Exception('Failed to load category products: $e');
    }
  }

  Future<ProductDetailModel> getProductDetail(String slug) async {
    try {
      print('Fetching product detail for slug: $slug');
      final response = await client.get(
        Uri.parse(ApiConstants.productDetail(slug)),
      );

      print('Product detail response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Product detail JSON keys: ${jsonData.keys}');
        return ProductDetailModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load product detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in ApiService.getProductDetail: $e');
      rethrow;
    }
  }
}