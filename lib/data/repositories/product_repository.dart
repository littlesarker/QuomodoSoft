import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/product_detail_model.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';


//
// class ProductRepository {
//   final ApiService apiService;
//
//   ProductRepository({required this.apiService});
//
//   Future<List<ProductModel>> getProducts({int page = 1}) async {
//     return await apiService.getProducts(page: page);
//   }
//
//   Future<ProductDetailModel> getProductDetail(String slug) async {
//     try {
//       final response = await http.get(
//         Uri.parse(ApiConstants.productDetail(slug)),
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         return ProductDetailModel.fromJson(jsonData);
//       } else {
//         throw Exception('Failed to load product detail');
//       }
//     } catch (e) {
//       throw Exception('Failed to load product detail: $e');
//     }
//   }
// }


class ProductRepository {
  final ApiService apiService;

  ProductRepository({required this.apiService});

  Future<List<ProductModel>> getProducts({int page = 1}) async {
    return await apiService.getProducts(page: page);
  }

  Future<ProductDetailModel> getProductDetail(String slug) async {
    return await apiService.getProductDetail(slug);
  }
}

