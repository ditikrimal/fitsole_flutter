import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitsole_flutter/domain/models/PromoBanner.dart';
import 'package:fitsole_flutter/domain/repositories/promo_banner_repository.dart';

part 'PromoBannerEvent.dart';
part 'PromoBannerState.dart';

class PromoBannerBloc extends Bloc<PromoBannerEvent, PromoBannerState> {
  final PromoBannerRepository promoBannerRepository;

  PromoBannerBloc({required this.promoBannerRepository})
      : super(PromoBannerInitial()) {
    on<LoadPromoBanners>((event, emit) async {
      try {
        emit(PromoBannerLoading());
        final promoBanners = await promoBannerRepository.fetchPromoBanners();
        emit(PromoBannerLoaded(promoBanners: promoBanners));
      } catch (e) {
        emit(PromoBannerError(e.toString()));
      }
    });
  }
}
