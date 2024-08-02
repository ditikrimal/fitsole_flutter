// lib/domain/blocs/promo_banner/PromoBannerState.dart
part of 'PromoBannerBloc.dart';

abstract class PromoBannerState extends Equatable {
  const PromoBannerState();

  @override
  List<Object> get props => [];
}

class PromoBannerInitial extends PromoBannerState {}

class PromoBannerLoading extends PromoBannerState {}

class PromoBannerLoaded extends PromoBannerState {
  final List<PromoBanner> promoBanners;

  const PromoBannerLoaded({required this.promoBanners});

  @override
  List<Object> get props => [promoBanners];
}

class PromoBannerError extends PromoBannerState {
  final String error;

  const PromoBannerError(this.error);

  @override
  List<Object> get props => [error];
}
