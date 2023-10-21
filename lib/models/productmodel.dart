import 'category.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final Categoryy category;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });
}
