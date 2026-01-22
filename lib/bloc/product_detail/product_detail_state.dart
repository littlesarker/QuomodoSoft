

import 'package:equatable/equatable.dart';

import '../../data/models/product_detail_model.dart';
import '../../data/models/product_model.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductDetailModel productDetail;
  final List<ProductModel> relatedProducts;

  const ProductDetailLoaded({
    required this.productDetail,
    required this.relatedProducts,
  });

  @override
  List<Object> get props => [productDetail, relatedProducts];
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object> get props => [message];
}