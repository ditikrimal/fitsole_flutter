part of 'home_widgets.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({
    Key? key,
    required this.categories,
    required this.isLoading,
  }) : super(key: key);

  final List<ShoeCategory> categories;
  final bool isLoading;

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  late ScrollController _scrollController;
  late Timer _autoScrollTimer;
  final double _scrollOffset = 25.0; // Adjust to control scroll speed

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel(); // Cancel the timer when the widget is disposed
    _scrollController.dispose(); // Dispose the ScrollController
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        final currentScroll = _scrollController.offset;
        final maxScroll = _scrollController.position.maxScrollExtent;
        final newScroll = currentScroll + _scrollOffset;
        if (newScroll >= maxScroll) {
          _scrollController.jumpTo(0); // Jump back to start for a seamless loop
        } else {
          _scrollController.animateTo(
            newScroll,
            duration: Duration(milliseconds: 200),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildSkeletonLoader();
    } else if (widget.categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    } else {
      return _buildCategoryList();
    }
  }

  Widget _buildSkeletonLoader() {
    return Container(
      height: 100,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Number of skeleton items
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(120),
              ),
              height: 40,
              width: 100,
              child: Center(
                child: Container(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    final int totalItems = widget.categories.length *
        10; // Large number to simulate continuous scrolling

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'CATEGORIES',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                'See All',
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 120, // Adjust height to fit circular categories
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemCount: totalItems,
            itemBuilder: (context, index) {
              final actualIndex = index % widget.categories.length;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 69, 69, 69),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.categories[actualIndex].shoecategory,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
