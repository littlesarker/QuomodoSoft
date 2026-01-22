import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product_model.dart';
import 'filter_bloc.dart';
import 'filter_event.dart';
import 'filter_state.dart';

class FilterManager {
  static void applyProductFilters(
      BuildContext context,
      List<ProductModel> products,
      ) {
    context.read<FilterBloc>().add(ApplyFilters(products));
  }

  static void resetAllFilters(BuildContext context) {
    context.read<FilterBloc>().add(ResetFilters());
  }

  static void updateCategoryFilter(BuildContext context, int? categoryId) {
    context.read<FilterBloc>().add(UpdateCategoryFilter(categoryId));
  }

  static void updateSortType(BuildContext context, SortType sortType) {
    context.read<FilterBloc>().add(UpdateSortType(sortType));
  }

  static List<ProductModel> getFilteredProducts(
      BuildContext context,
      List<ProductModel> allProducts,
      ) {
    final filterState = context.read<FilterBloc>().state;

    if (filterState.filteredProducts.isNotEmpty) {
      return filterState.filteredProducts;
    }

    return allProducts;
  }
}