import 'package:equatable/equatable.dart';
import 'package:fitsole_flutter/domain/models/brand.dart';

abstract class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object> get props => [];
}

class BrandInitial extends BrandState {}

class BrandLoading extends BrandState {}

class BrandLoaded extends BrandState {
  final List<Brand> brands; // Adjust type as needed

  BrandLoaded({required this.brands});

  @override
  List<Object> get props => [brands];
}

class BrandError extends BrandState {
  final String error;

  BrandError(this.error);

  @override
  List<Object> get props => [error];
}
