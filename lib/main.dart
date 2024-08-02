import 'package:fitsole_flutter/domain/blocs/brand/brand_bloc.dart';
import 'package:fitsole_flutter/domain/blocs/product/ProductBloc.dart';
import 'package:fitsole_flutter/domain/blocs/promo_banner/PromoBannerBloc.dart';
import 'package:fitsole_flutter/domain/repositories/brand_repository.dart';
import 'package:fitsole_flutter/domain/repositories/category_repository.dart';
import 'package:fitsole_flutter/domain/repositories/product_repository.dart';
import 'package:fitsole_flutter/domain/repositories/promo_banner_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitsole_flutter/domain/blocs/blocs.dart'; // Import all BLoCs from this file
import 'package:fitsole_flutter/presentation/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (context) => AuthBloc()..add(CheckLoginEvent())),
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
        BlocProvider<PromoBannerBloc>(
          create: (context) =>
              PromoBannerBloc(promoBannerRepository: PromoBannerRepository()),
        ),
        BlocProvider<ProductBloc>(
          create: (context) =>
              ProductBloc(productRepository: ProductRepository()),
        ),
        BlocProvider<BrandBloc>(
            create: (context) => BrandBloc(BrandRepository())),
        BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(CategoryRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commers Products - Fraved',
        initialRoute: 'homePage',
        routes: routes,
      ),
    );
  }
}
