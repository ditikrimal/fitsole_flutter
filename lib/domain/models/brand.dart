class Brand {
  final String brand;

  Brand({required this.brand});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      brand: json['brand'],
    );
  }

  get name => null;

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
    };
  }

  @override
  String toString() {
    return brand;
  }
}
