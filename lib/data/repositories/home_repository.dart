

import '../models/home_response_model.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class HomeRepository {
  final ApiService apiService;

  HomeRepository({required this.apiService});

  Future<HomeResponseModel> getHomeData() async {
    return await apiService.getHomeData();
  }

  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    return await apiService.getProductsByCategory(categoryId);
  }
}