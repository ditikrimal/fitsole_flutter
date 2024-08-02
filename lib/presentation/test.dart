import 'package:fitsole_flutter/presentation/components/wavy_painter.dart';
import 'package:fitsole_flutter/presentation/components/widgets.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class TestHomeScreen extends StatefulWidget {
  const TestHomeScreen({super.key});

  @override
  State<TestHomeScreen> createState() => _TestHomeScreenState();
}

class _TestHomeScreenState extends State<TestHomeScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 60, 60, 60),
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 80.0,
                maxHeight: 80.0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  color: Color.fromARGB(255, 60, 60, 60),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 60,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  'Search for products',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Stack(children: [
          Positioned.fill(
              child: CustomPaint(
            painter: WavyPainter(),
          )),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 15),
                    // Promo Banner
                    Container(
                      height: 150,
                      child: Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: 3,
                              itemBuilder: (context, index) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                width: MediaQuery.of(context).size.width - 10,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Promo Banner $index',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: 3,
                            effect: WormEffect(
                              dotHeight: 8,
                              dotWidth: 8,
                              activeDotColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    // Brand Filters
                    Container(
                      height: 60,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 40,
                            width: 100,
                            child: Center(
                              child: Text(
                                'Brand $index',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Most Popular Product List
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Container(
                          child: TextFitsole(
                            text: 'Most Popular Products',
                            fontSize: 20,
                            isTitle: true,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Container(
                          child: TextFitsole(
                            text: 'View All',
                            fontSize: 16,
                            isTitle: false,
                            isUnderline: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    // Two-column product grid
                    StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      itemCount:
                          6, // Change this to the number of products you have
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            print('Product $index');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
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
                                  SizedBox(height: 5),
                                  Container(
                                    height: 120,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Product Image',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 2),
                                    width: double.infinity,
                                    child: TextFitsole(
                                      text: 'Product Name',
                                      fontSize: 16,
                                      isTitle: true,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 2),
                                    width: double.infinity,
                                    child: TextFitsole(
                                      text: 'Product Price',
                                      fontSize: 14,
                                      isTitle: false,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(
                        1,
                      ),
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 15.0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                    //view all button
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        width: double.infinity,
                        child: Row(
                          children: [
                            TextFitsole(
                              text: 'Categories',
                              fontSize: 20,
                              isTitle: true,
                              fontWeight: FontWeight.w600,
                            ),
                            Spacer(),
                            TextFitsole(
                              text: 'View All',
                              fontSize: 16,
                              isTitle: false,
                              isUnderline: true,
                            ),
                          ],
                        )),
                    SizedBox(height: 15),
                    //Scrollable Row

                    Container(
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(120),
                            ),
                            height: 40,
                            width: 100,
                            child: Center(
                              child: Text(
                                'Category $index',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    //Single Column grid for Latest Arrivals
                    Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          TextFitsole(
                            text: 'Latest Arrivals',
                            fontSize: 20,
                            isTitle: true,
                            fontWeight: FontWeight.w600,
                          ),
                          Spacer(),
                          TextFitsole(
                            text: 'View All',
                            fontSize: 16,
                            isTitle: false,
                            isUnderline: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) => Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                print('Product $index');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Product Image',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 2),
                                        width: double.infinity,
                                        child: TextFitsole(
                                          text: 'Product Name',
                                          fontSize: 16,
                                          isTitle: true,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 2),
                                        width: double.infinity,
                                        child: TextFitsole(
                                          text: 'Product Price',
                                          fontSize: 14,
                                          isTitle: false,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    //Double Column grid for all products
                    Container(
                      width: double.infinity,
                      child: TextFitsole(
                          text: 'All Products', fontSize: 20, isTitle: true),
                    ),
                    SizedBox(height: 15),
                    StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      itemCount:
                          6, // Change this to the number of products you have
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            print('Product $index');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
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
                                  SizedBox(height: 5),
                                  Container(
                                    height: 120,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Product Image',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 2),
                                    width: double.infinity,
                                    child: TextFitsole(
                                      text: 'Product Name',
                                      fontSize: 16,
                                      isTitle: true,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 2),
                                    width: double.infinity,
                                    child: TextFitsole(
                                      text: 'Product Price',
                                      fontSize: 14,
                                      isTitle: false,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(
                        1,
                      ),
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 15.0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                    SizedBox(height: 15),
                    //Load More Icon Button
                    GestureDetector(
                      onTap: () {
                        print('Load More');
                      },
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFitsole(
                              text: 'Load More',
                              fontSize: 16,
                              isTitle: false,
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 15),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
