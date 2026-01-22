

import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadProductDetail extends ProductDetailEvent {
  final String slug;

  const LoadProductDetail(this.slug);

  @override
  List<Object> get props => [slug];
}