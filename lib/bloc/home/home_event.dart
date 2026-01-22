import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {}

class LoadCategoryProducts extends HomeEvent {
  final int categoryId;

  const LoadCategoryProducts(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}