import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mdrahim/bloc/products/product_event.dart';
import 'package:mdrahim/bloc/products/product_state.dart';

import '../../data/repositories/product_repository.dart';




class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  static const int _productsPerPage = 12;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(
      LoadProducts event,
      Emitter<ProductState> emit,
      ) async {
    try {
      if (event.page == 1) {
        emit(ProductLoading());
      }

      final products = await repository.getProducts(page: event.page);

      final hasReachedMax = products.length < _productsPerPage;

      if (event.page == 1) {
        emit(ProductLoaded(
          products: products,
          hasReachedMax: hasReachedMax,
          currentPage: event.page,
        ));
      } else if (state is ProductLoaded) {
        final currentState = state as ProductLoaded;
        emit(ProductLoaded(
          products: currentState.products + products,
          hasReachedMax: hasReachedMax,
          currentPage: event.page,
        ));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}