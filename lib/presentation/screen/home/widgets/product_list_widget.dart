part of 'home_widgets.dart';

class ProductListWidget extends StatelessWidget {
  final String title;
  final bool isLoading;
  final ProductEvent event;
  final bool hasReachedMax; // New property
  final VoidCallback onLoadMore; // New property

  const ProductListWidget({
    Key? key,
    required this.title,
    this.isLoading = false,
    required this.event,
    this.hasReachedMax = false, // Default value
    required this.onLoadMore, // Callback for loading more products
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Spacer(),
            Text(
              'See All',
              style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
          if (state is ProductInitial) {
            context.read<ProductBloc>().add(event);
            return _buildLoadingSkeleton();
          } else if (state is ProductsLoading) {
            return _buildLoadingSkeleton();
          } else if (state is ProductsLoaded) {
            return Column(
              children: [
                _buildProductGrid(products: state.products),
                if (!hasReachedMax && title == "ALL PRODUCTS")
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        onLoadMore();
                        //scroll to the bottom of the page
                        ScrollController _scrollController = ScrollController();
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Center(
                        child: Text(
                          'Load More',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
          return Container();
        }),
      ],
    );
  }

  Widget _buildLoadingSkeleton() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          margin: EdgeInsets.only(bottom: 15),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 20,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 5),
                Container(
                  height: 20,
                  width: 100,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      mainAxisSpacing: 15.0,
      crossAxisSpacing: 15.0,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  Widget _buildProductGrid({
    required List<Product> products,
  }) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: title == "LATEST ARRIVALS" ? 1 : 2,
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) => Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: GestureDetector(
          onTap: () {
            print('Product $index');
          },
          child: Padding(
            padding: EdgeInsets.all(title == "LATEST ARRIVALS" ? 20 : 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      color: Colors.black,
                    ),
                  ],
                ),
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(products[index].imageUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                  width: double.infinity,
                  child: Text(
                    products[index].name.toUpperCase(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                  width: double.infinity,
                  child: Text(
                    products[index].description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
                SizedBox(height: 5),
                Divider(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                  width: double.infinity,
                  child: Text(
                    "\$ ${products[index].price.toString()}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      mainAxisSpacing: 15.0,
      crossAxisSpacing: 15.0,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}
