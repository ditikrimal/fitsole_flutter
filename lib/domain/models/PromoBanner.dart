// lib/models/promo_banner.dart

class PromoBanner {
  final int id;
  final String title;
  final String imageUrl;

  PromoBanner({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory PromoBanner.fromJson(Map<String, dynamic> json) {
    return PromoBanner(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
    };
  }
}
