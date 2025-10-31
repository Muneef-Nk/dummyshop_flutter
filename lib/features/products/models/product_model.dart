class ProductModel {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final double? rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'] ?? '',
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'] ?? '',
      rating: json['rating']?.toDouble(),
    );
  }
}
