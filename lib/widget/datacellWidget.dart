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
            child: new Row(
              children: <Widget>[
                new Image.network(
                  product.galleryURL,
                ),
                new Container(
                  width: 16.0,
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: new Column(
                          children: <Widget>[
                            new Text(product.title,
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            new Container(height: 8.0),
                            new FittedBox(
                                child: new Row(
                              children: <Widget>[
                                new Text(product.price + " + "),
                                new Text(product.shipping,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 184, 157, 1),
                                        fontWeight: FontWeight.bold))
                              ],
                            )),
                            new Container(height: 3.0),
                            new Container(
                                child: new Row(
                              children: <Widget>[
                                new Text(
                                  "Condition: ",
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                new Text(
                                  product.condition,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Color.fromRGBO(36, 109, 116, 1.0),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ))
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
