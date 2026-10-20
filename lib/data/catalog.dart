import 'package:flutter/material.dart';

class Product {
  const Product(
    this.id,
    this.name,
    this.price,
    this.image,
    this.category, {
    this.color = const Color(0xFFF5F5F5),
    this.description = 'Freshly prepared with carefully selected ingredients.',
  });
  final String id, name, image, category, description;
  final double price;
  final Color color;
  String get asset => 'assets/images/$image.png';
}

const catalog = <Product>[
  Product('combo1', 'Combo 1', 24, 'salad_one', 'Salad'),
  Product('combo2', 'Combo 2', 20, 'salad_two', 'Salad'),
  Product('combo3', 'Combo 3', 18, 'salad_three', 'Salad'),
  Product('combo4', 'Combo 4', 22, 'salad_four', 'Salad'),
  Product(
    'burger',
    'Special Hamburger',
    10,
    'burger',
    'Meat',
    color: Color(0xFFEE9236),
  ),
  Product(
    'yogurt',
    'Fruit yogurt',
    30,
    'yogurt',
    'Fruit',
    description:
        'Yogurt has been part of the human diet for thousands of years.',
  ),
  Product('cereal1', 'Cereals type 1', 24, 'cereal_one', 'Salad'),
  Product('cereal2', 'Cereals special', 20, 'cereal_two', 'Salad'),
  Product(
    'zucchini',
    'Zucchini',
    4,
    'zucchini',
    'Fruit',
    color: Color(0xFF9EB183),
  ),
  Product(
    'cabbage',
    'Savoy Cabbage',
    3,
    'cabbage',
    'Fruit',
    color: Color(0xFFBACB83),
  ),
  Product('garlic', 'Garlic', 2, 'garlic', 'Fruit', color: Color(0xFFD6B89E)),
  Product(
    'mushroom',
    'Mushroom',
    6,
    'mushroom',
    'Fruit',
    color: Color(0xFFE2D5B6),
  ),
  Product('pepper', 'Pepper', 4, 'pepper', 'Fruit', color: Color(0xFFBC594F)),
  Product('banana', 'Banana', 3, 'banana', 'Fruit', color: Color(0xFFECDC6B)),
  Product(
    'dimsum',
    'Dimsum',
    18,
    'dimsum',
    'Meat',
    description: 'A traditional Chinese meal made up of small plates of dumplings and other snack dishes, freshly steamed and served to share.',
  ),
  Product('tea', 'Jasmine Tea', 10, 'tea', 'Fruit'),
  Product('avocado', 'Avocado', 21, 'avocado', 'Fruit'),
  Product('cake', 'Sweet Cake', 10, 'cake', 'Salad'),
];

Product product(String id) =>
    catalog.firstWhere((p) => p.id == id.split('|').first);
String cartOption(String key) =>
    key.contains('|') ? key.split('|').last : 'Fresh ingredients';
String money(num value) => '\$${value.toStringAsFixed(2)}';
