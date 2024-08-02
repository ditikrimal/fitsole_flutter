import 'package:bloc/bloc.dart';
import 'package:fitsole_flutter/domain/blocs/blocs.dart';
import 'package:fitsole_flutter/domain/blocs/category/category_event.dart';
import 'package:fitsole_flutter/domain/blocs/category/category_state.dart';
import 'package:fitsole_flutter/domain/repositories/brand_repository.dart';
import 'package:fitsole_flutter/domain/repositories/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    on<FetchCategories>(_onFechCategory);
  }

  Future<void> _onFechCategory(
      FetchCategories event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoading());
      final category = await repository.getCategories();

      emit(CategoryLoaded(categories: category));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
