import 'package:flutter/material.dart';

class Product {
  final String title;
  final String galleryURL;
  final String price;
  final String shipping;

  const Product(
      {@required this.title, this.galleryURL, this.price, this.shipping});
}
