import 'package:flutter/material.dart';
import '../module/product.dart';

class ProductDataCell extends StatelessWidget {
  final Product product;

  ProductDataCell({@required this.product});

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
            padding: new EdgeInsets.all(16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(product.galleryURL))),
                ),
                // new Image.network(product.galleryURL, fit: BoxFit.fill),
                new Container(
                  height: 8.0,
                ),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(width: 16.0),
                    new Flexible(
                        child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(product.title,
                            style: new TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold)),
                        new Container(
                          height: 4.0,
                        ),
                        new Text(product.price + " + " + product.shipping),
                      ],
                    ))
                  ],
                )
              ],
            )),
        new Divider()
      ],
    );
  }
}
