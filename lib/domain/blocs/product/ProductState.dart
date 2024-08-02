// lib/domain/blocs/product/ProductState.dart
part of 'ProductBloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductsLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final bool hasReachedMax;

  ProductsLoaded({required this.products, required this.hasReachedMax});

  ProductsLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [products];
}

class ProductError extends ProductState {
  final String error;

  const ProductError(this.error);

  @override
  List<Object> get props => [error];
}
