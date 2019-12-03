import 'package:flutter/material.dart';

import '../module/product.dart';

class DetailPage extends StatefulWidget {
  final Product product;

  DetailPage({@required this.product});

  @override
  State<StatefulWidget> createState() {
    return new DetailPageState(product: product);
  }
}

class DetailPageState extends State<DetailPage> {
  final Product product;

  DetailPageState({@required this.product});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(product.title)),
        body: new Center(child: new Text("Detail Detail Detail")));
  }
}
