part of 'home_widgets.dart';

class PromoBannerWidget extends StatefulWidget {
  final List<PromoBanner> promoBanners;
  final bool isLoading;

  const PromoBannerWidget({
    Key? key,
    required this.promoBanners,
    this.isLoading = false,
  }) : super(key: key);

  @override
  _PromoBannerWidgetState createState() => _PromoBannerWidgetState();
}

class _PromoBannerWidgetState extends State<PromoBannerWidget> {
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (!widget.isLoading) {
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PromoBannerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading && !widget.isLoading) {
      _startAutoScroll();
    } else if (widget.isLoading) {
      _timer?.cancel();
    }
  }

  void _startAutoScroll() {
    _timer?.cancel(); // Cancel any previous timers
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_pageController.page == widget.promoBanners.length - 1) {
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeIn,
        );
      } else {
        _pageController.nextPage(
          duration: Duration(milliseconds: 600),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: widget.isLoading ? _buildLoadingSkeleton() : _buildContent(),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              width: MediaQuery.of(context).size.width - 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 80,
            height: 8,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.promoBanners.length,
            itemBuilder: (context, index) {
              final banner = widget.promoBanners[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                width: MediaQuery.of(context).size.width - 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(banner.imageUrl, fit: BoxFit.cover),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.promoBanners.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.black,
          ),
        ),
      ],
    );
  }
}
