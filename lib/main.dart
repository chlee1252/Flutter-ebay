import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  var _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        title: new Text("eBay Search"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isLoading ? _isLoading = false : _isLoading = true;
              });
            },
          )
        ],
      ),
      body: new Center(
          child: _isLoading
              ? new CircularProgressIndicator()
              : new Text("Done Loading!")),
    ));
  }
}
