import 'package:fitsole_flutter/domain/blocs/blocs.dart';
import 'package:fitsole_flutter/domain/blocs/category/category_event.dart';
import 'package:fitsole_flutter/domain/blocs/category/category_state.dart';
import 'package:fitsole_flutter/domain/blocs/product/ProductBloc.dart';
import 'package:fitsole_flutter/domain/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitsole_flutter/domain/blocs/brand/brand_bloc.dart';
import 'package:fitsole_flutter/domain/blocs/brand/brand_event.dart';
import 'package:fitsole_flutter/domain/blocs/brand/brand_state.dart';
import 'package:fitsole_flutter/domain/blocs/promo_banner/PromoBannerBloc.dart';
import 'package:fitsole_flutter/presentation/components/widgets.dart';
import 'package:fitsole_flutter/presentation/screen/home/widgets/home_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<PromoBannerBloc>().add(const LoadPromoBanners());
    context.read<BrandBloc>().add(FetchBrands());
    context.read<CategoryBloc>().add(FetchCategories());
    context.read<ProductBloc>().add(const LoadAllProducts());
    // context.read<ProductBloc>().add(const LoadPopularProducts());
    // context.read<ProductBloc>().add(LoadLatestProducts());
  }

  Future<void> _loadData() async {
    context.read<PromoBannerBloc>().add(const LoadPromoBanners());
    context.read<BrandBloc>().add(FetchBrands());
    context.read<CategoryBloc>().add(FetchCategories());
    context.read<ProductBloc>().add(const LoadAllProducts());
    // context.read<ProductBloc>().add(const LoadPopularProducts());
    // context.read<ProductBloc>().add(LoadLatestProducts());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages() {
    return [
      HomePageContent(),
      const Center(child: Text('Favorites Page')), // Replace with actual pages
      const Center(child: Text('Profile Page')), // Replace with actual pages
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 241, 244),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages(),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomAppBar(),
            const CustomSearchBar(),
            const SizedBox(height: 15),
            // Promo Banners
            BlocBuilder<PromoBannerBloc, PromoBannerState>(
              builder: (context, state) {
                if (state is PromoBannerLoading) {
                  return const PromoBannerWidget(
                      promoBanners: [], isLoading: true);
                } else if (state is PromoBannerLoaded) {
                  return PromoBannerWidget(promoBanners: state.promoBanners);
                } else if (state is PromoBannerError) {
                  return errorContainer(
                      'Failed to load promo banners', context);
                } else {
                  return Container();
                }
              },
            ),
            const SizedBox(height: 15),
            // Brand Filters
            BlocBuilder<BrandBloc, BrandState>(
              builder: (context, state) {
                if (state is BrandLoading) {
                  return const BrandFilterWidget(brands: [], isLoading: true);
                } else if (state is BrandLoaded) {
                  if (state.brands.isEmpty) {
                    return const Text('No brands available');
                  }
                  return BrandFilterWidget(brands: state.brands);
                } else if (state is BrandError) {
                  return errorContainer('Failed to load brands', context);
                } else {
                  return Container();
                }
              },
            ),
            // Most Popular Product List
            const SizedBox(height: 15),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                bool hasReachedMax = false;
                VoidCallback onLoadMore = () {};

                if (state is ProductsLoaded) {
                  hasReachedMax = state
                      .hasReachedMax; // Assuming ProductState has this property
                  onLoadMore = () {};
                }

                return ProductListWidget(
                  title: 'Most Popular'.toUpperCase(),
                  event: const LoadPopularProducts(),
                  hasReachedMax: hasReachedMax,
                  onLoadMore: onLoadMore,
                );
              },
            ),
            const SizedBox(height: 15),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const BrandFilterWidget(brands: [], isLoading: true);
                } else if (state is CategoryLoaded) {
                  if (state.categories.isEmpty) {
                    return const Text('No categories available');
                  }
                  return CategoriesWidget(
                    categories: state.categories,
                    isLoading: false,
                  );
                } else if (state is CategoryError) {
                  return const Text('Failed to load categories');
                } else {
                  return errorContainer('Failed to load categories', context);
                }
              },
            ),
            // Latest Arrivals
            const SizedBox(height: 15),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                bool hasReachedMax = false;
                VoidCallback onLoadMore = () {};

                if (state is ProductsLoaded) {
                  hasReachedMax = state.hasReachedMax;
                  onLoadMore = () {};
                }

                return ProductListWidget(
                  title: 'Latest Arrivals'.toUpperCase(),
                  event: const LoadLatestProducts(),
                  hasReachedMax: hasReachedMax,
                  onLoadMore: onLoadMore,
                );
              },
            ),
            const SizedBox(height: 15),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                bool hasReachedMax = false;
                VoidCallback onLoadMore = () {};

                if (state is ProductsLoaded) {
                  hasReachedMax = state.hasReachedMax;
                  onLoadMore = () {
                    context.read<ProductBloc>().add(LoadMoreProducts());
                  };
                }

                return ProductListWidget(
                  title: 'All Products'.toUpperCase(),
                  event: const LoadAllProducts(),
                  hasReachedMax: hasReachedMax,
                  onLoadMore: onLoadMore,
                );
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget errorContainer(String s, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 101, 101, 101),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        s,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
