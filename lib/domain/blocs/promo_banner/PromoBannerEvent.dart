// lib/domain/blocs/promo_banner/PromoBannerEvent.dart
part of 'PromoBannerBloc.dart';

abstract class PromoBannerEvent extends Equatable {
  const PromoBannerEvent();

  @override
  List<Object> get props => [];
}

class LoadPromoBanners extends PromoBannerEvent {
  const LoadPromoBanners();

  @override
  List<Object> get props => [];
}
