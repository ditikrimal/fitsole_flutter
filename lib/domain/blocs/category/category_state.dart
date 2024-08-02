import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitsole_flutter/domain/models/Category.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<ShoeCategory> categories; // Adjust type as needed

  CategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoryError extends CategoryState {
  final String error;

  CategoryError(this.error);

  @override
  List<Object> get props => [error];
}
