import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mdrahim/bloc/product_detail/product_detail_event.dart';
import 'package:mdrahim/bloc/product_detail/product_detail_state.dart';

import '../../data/repositories/product_repository.dart';


class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository repository;

  ProductDetailBloc({required this.repository}) : super(ProductDetailInitial()) {
    on<LoadProductDetail>(_onLoadProductDetail);
  }

  Future<void> _onLoadProductDetail(
      LoadProductDetail event,
      Emitter<ProductDetailState> emit,
      ) async {
    emit(ProductDetailLoading());
    try {
      print('Loading product detail for slug: ${event.slug}');
      final productDetail = await repository.getProductDetail(event.slug);
      print('Product detail loaded successfully');
      emit(ProductDetailLoaded(
        productDetail: productDetail,
        relatedProducts: productDetail.relatedProducts,
      ));
    } catch (e) {
      print('Error in ProductDetailBloc: $e');
      emit(ProductDetailError('Failed to load product details. Please try again.'));
    }
  }
}