part of 'home_widgets.dart';

class BrandFilterWidget extends StatefulWidget {
  final List<Brand> brands;
  final bool isLoading;

  const BrandFilterWidget(
      {Key? key, required this.brands, this.isLoading = false})
      : super(key: key);

  @override
  State<BrandFilterWidget> createState() => _BrandFilterWidgetState();
}

class _BrandFilterWidgetState extends State<BrandFilterWidget> {
  void _onBrandTap(Brand brand) {
    print('Brand Pressed: ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(top: 10),
      width: double.infinity,
      child: widget.isLoading ? _buildLoadingSkeleton() : _buildContent(),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 35,
            width: 100,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.brands.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: () => _onBrandTap(widget.brands[index]),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 35,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Image.asset(
                  "assets/${widget.brands[index]}.png",
                  height: 34,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
