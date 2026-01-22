import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/product_model.dart';
import 'filter_event.dart';
import 'filter_state.dart';


class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(const FilterState()) {
    on<UpdateSortType>(_onUpdateSortType);
    on<UpdateMinPrice>(_onUpdateMinPrice);
    on<UpdateMaxPrice>(_onUpdateMaxPrice);
    on<UpdateCategoryFilter>(_onUpdateCategoryFilter);
    on<ResetFilters>(_onResetFilters);
    on<ApplyFilters>(_onApplyFilters);
  }

  void _onUpdateSortType(UpdateSortType event, Emitter<FilterState> emit) {
    emit(state.copyWith(sortType: event.sortType));
  }

  void _onUpdateMinPrice(UpdateMinPrice event, Emitter<FilterState> emit) {
    emit(state.copyWith(minPrice: event.minPrice));
  }

  void _onUpdateMaxPrice(UpdateMaxPrice event, Emitter<FilterState> emit) {
    emit(state.copyWith(maxPrice: event.maxPrice));
  }

  void _onUpdateCategoryFilter(
      UpdateCategoryFilter event,
      Emitter<FilterState> emit,
      ) {
    emit(state.copyWith(categoryId: event.categoryId));
  }

  void _onResetFilters(ResetFilters event, Emitter<FilterState> emit) {
    emit(const FilterState());
  }

  void _onApplyFilters(ApplyFilters event, Emitter<FilterState> emit) {
    List<ProductModel> filteredProducts = event.products;

    // Apply price filter
    if (state.minPrice != null && state.minPrice! > 0) {
      filteredProducts = filteredProducts
          .where((product) {
        final priceToCheck = product.offerPrice ?? product.price;
        return priceToCheck >= state.minPrice!;
      })
          .toList();
    }

    if (state.maxPrice != null && state.maxPrice! > 0) {
      filteredProducts = filteredProducts
          .where((product) {
        final priceToCheck = product.offerPrice ?? product.price;
        return priceToCheck <= state.maxPrice!;
      })
          .toList();
    }

    // Apply category filter (only if categoryId is not null)
    if (state.categoryId != null) {
      filteredProducts = filteredProducts
          .where((product) => product.categoryId == state.categoryId)
          .toList();
    }

    // Apply sorting
    filteredProducts = _sortProducts(filteredProducts, state.sortType);

    emit(state.copyWith(filteredProducts: filteredProducts));
  }

  List<ProductModel> _sortProducts(
      List<ProductModel> products,
      SortType sortType,
      ) {
    List<ProductModel> sortedProducts = List.from(products);

    switch (sortType) {
      case SortType.priceLowToHigh:
        sortedProducts.sort((a, b) {
          final priceA = a.offerPrice ?? a.price;
          final priceB = b.offerPrice ?? b.price;
          return priceA.compareTo(priceB);
        });
        break;

      case SortType.priceHighToLow:
        sortedProducts.sort((a, b) {
          final priceA = a.offerPrice ?? a.price;
          final priceB = b.offerPrice ?? b.price;
          return priceB.compareTo(priceA);
        });
        break;

      case SortType.topRated:
        sortedProducts.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        break;

      case SortType.bestSelling:
        sortedProducts.sort((a, b) => b.totalSold.compareTo(a.totalSold));
        break;

      case SortType.newest:
      default:
      // Keep original order (new products first based on API)
        break;
    }

    return sortedProducts;
  }
}