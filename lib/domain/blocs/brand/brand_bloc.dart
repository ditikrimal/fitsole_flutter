import 'package:bloc/bloc.dart';
import 'package:fitsole_flutter/domain/repositories/brand_repository.dart';
import 'brand_event.dart';
import 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository repository;

  BrandBloc(this.repository) : super(BrandInitial()) {
    on<FetchBrands>(_onFetchBrands);
  }

  Future<void> _onFetchBrands(
      FetchBrands event, Emitter<BrandState> emit) async {
    try {
      emit(BrandLoading());
      final brands = await repository.getBrands();
      emit(BrandLoaded(brands: brands));
    } catch (e) {
      emit(BrandError(e.toString()));
    }
  }
}
