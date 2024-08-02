// lib/domain/blocs/product/ProductEvent.dart
part of 'ProductBloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadAllProducts extends ProductEvent {
  const LoadAllProducts();

  @override
  List<Object> get props => [];
}

class LoadPopularProducts extends ProductEvent {
  const LoadPopularProducts();

  @override
  List<Object> get props => [];
}

class LoadLatestProducts extends ProductEvent {
  const LoadLatestProducts();

  @override
  List<Object> get props => [];
}

class LoadMoreProducts extends ProductEvent {
  const LoadMoreProducts();

  @override
  List<Object> get props => [];
}
