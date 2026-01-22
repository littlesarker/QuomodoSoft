

import 'package:equatable/equatable.dart';

import '../../data/models/product_model.dart';
import 'filter_state.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object> get props => [];
}

class UpdateSortType extends FilterEvent {
  final SortType sortType;

  const UpdateSortType(this.sortType);

  @override
  List<Object> get props => [sortType];
}

class UpdateMinPrice extends FilterEvent {
  final double? minPrice;

  const UpdateMinPrice(this.minPrice);

  @override
  List<Object> get props => [minPrice ?? 0];
}

class UpdateMaxPrice extends FilterEvent {
  final double? maxPrice;

  const UpdateMaxPrice(this.maxPrice);

  @override
  List<Object> get props => [maxPrice ?? 0];
}

class UpdateCategoryFilter extends FilterEvent {
  final int? categoryId;

  const UpdateCategoryFilter(this.categoryId);

  @override
  List<Object> get props => [categoryId ?? 0];
}

class ResetFilters extends FilterEvent {}

class ApplyFilters extends FilterEvent {
  final List<ProductModel> products;

  const ApplyFilters(this.products);

  @override
  List<Object> get props => [products];
}