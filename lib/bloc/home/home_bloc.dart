import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


import '../../data/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';



class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<LoadCategoryProducts>(_onLoadCategoryProducts);
  }

  Future<void> _onLoadHomeData(
      LoadHomeData event,
      Emitter<HomeState> emit,
      ) async {
    emit(HomeLoading());
    try {
      final homeData = await repository.getHomeData();
      emit(HomeLoaded(
        categories: homeData.categories,
        newArrivals: homeData.newArrivalProducts,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onLoadCategoryProducts(
      LoadCategoryProducts event,
      Emitter<HomeState> emit,
      ) async {
    if (state is HomeLoaded) {
      emit(CategoryProductsLoading());
      try {
        final products = await repository.getProductsByCategory(event.categoryId);
        emit(CategoryProductsLoaded(products));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    }
  }
}