import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitsole_flutter/domain/models/Product.dart';
import 'package:fitsole_flutter/domain/repositories/product_repository.dart';

part 'ProductEvent.dart';
part 'ProductState.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<LoadAllProducts>((event, emit) async {
      try {
        emit(ProductsLoading());
        final products = await productRepository.fetchAllProducts();
        emit(ProductsLoaded(products: products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<LoadPopularProducts>((event, emit) async {
      try {
        emit(ProductsLoading());
        final products = await productRepository.fetchMostPopularProducts();
        emit(ProductsLoaded(products: products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<LoadLatestProducts>((event, emit) async {
      try {
        emit(ProductsLoading());
        final products = await productRepository.fetchLatestArrivals();
        emit(ProductsLoaded(products: products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
