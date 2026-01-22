import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategoryModel> categories;
  final List<ProductModel> newArrivals;
  final List<ProductModel>? categoryProducts;

  const HomeLoaded({
    required this.categories,
    required this.newArrivals,
    this.categoryProducts,
  });

  @override
  List<Object> get props => [categories, newArrivals];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

class CategoryProductsLoading extends HomeState {}

class CategoryProductsLoaded extends HomeState {
  final List<ProductModel> products;

  const CategoryProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}