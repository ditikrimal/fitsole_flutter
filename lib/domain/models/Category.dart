class ShoeCategory {
  final String shoecategory;

  ShoeCategory({required this.shoecategory});

  factory ShoeCategory.fromJson(Map<String, dynamic> json) {
    return ShoeCategory(
      shoecategory: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': shoecategory,
    };
  }

  @override
  String toString() {
    return shoecategory;
  }
}
