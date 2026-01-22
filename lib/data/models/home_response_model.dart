import 'package:mdrahim/data/models/product_model.dart';


import 'category_model.dart';

class HomeResponseModel {
  final List<CategoryModel> categories;
  final List<ProductModel> newArrivalProducts;

  HomeResponseModel({
    required this.categories,
    required this.newArrivalProducts,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    final categoriesList = (json['homepage_categories'] as List)
        .map((item) => CategoryModel.fromJson(item))
        .toList();

    final productsList = (json['newArrivalProducts'] as List)
        .map((item) => ProductModel.fromJson(item))
        .toList();

    return HomeResponseModel(
      categories: categoriesList,
      newArrivalProducts: productsList,
    );
  }
}