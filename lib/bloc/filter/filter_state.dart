



import 'package:equatable/equatable.dart';

import '../../data/models/product_model.dart';

class FilterState extends Equatable {
  final SortType sortType;
  final double? minPrice;
  final double? maxPrice;
  final int? categoryId;
  final List<ProductModel> filteredProducts;

  const FilterState({
    this.sortType = SortType.newest,
    this.minPrice,
    this.maxPrice,
    this.categoryId,
    this.filteredProducts = const [],
  });

  FilterState copyWith({
    SortType? sortType,
    double? minPrice,
    double? maxPrice,
    int? categoryId,
    List<ProductModel>? filteredProducts,
  }) {
    return FilterState(
      sortType: sortType ?? this.sortType,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      categoryId: categoryId ?? this.categoryId,
      filteredProducts: filteredProducts ?? this.filteredProducts,
    );
  }

  @override
  List<Object?> get props => [
    sortType,
    minPrice,
    maxPrice,
    categoryId,
    filteredProducts,
  ];
}

enum SortType {
  newest('Newest'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low'),
  topRated('Top Rated'),
  bestSelling('Best Selling');

  final String label;
  const SortType(this.label);
}