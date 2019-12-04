import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './view/detailPage.dart';
import './widget/datacellWidget.dart';
import './module/product.dart';
import './appID.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("eBay Search");

  var keyword = "nike";
  var _isLoading = true;
  var prevKeyword = '';
  var pageNumber = 1;
  var totalPages = 0;
  final productData = new List<Product>();
  final url =
      "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&";
  final appIDURL = "SECURITY-APPNAME=" + appID + "&RESPONSE-DATA-FORMAT=JSON";
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData("nike", this.pageNumber.toString());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          this.pageNumber < totalPages) {
        this.pageNumber++;
        _fetchData(this.keyword, this.pageNumber.toString());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _fetchData(String keyword, String pageNumber) async {
    if (this.prevKeyword != keyword) {
      productData.clear();
      this.prevKeyword = keyword;
      this.pageNumber = 1;
      pageNumber = "1";
    }
    final completeURL = url +
        appIDURL +
        "&keywords=$keyword" +
        "&paginationInput.entriesPerPage=5" +
        "&paginationInput.pageNumber=$pageNumber";
    final response = await http.get(completeURL);

    if (response.statusCode != 200) {
      print("Please check the url");
    } else {
      final dataJson = json.decode(response.body);
      final items =
          dataJson['findItemsByKeywordsResponse'][0]['searchResult'][0]["item"];
      final totalpage = dataJson['findItemsByKeywordsResponse'][0]
          ['paginationOutput'][0]['totalPages'][0];
      this.totalPages = int.parse(totalpage);
      if (this.totalPages != 0) {
        items.forEach((i) {
          var condition = i['condition'] != null
              ? i['condition'][0]['conditionDisplayName'][0]
              : "Not provided";
          final shipInfo = i['shippingInfo'][0]['shippingServiceCost'];
          var shipCost = shipInfo != null
              ? double.parse(shipInfo[0]['__value__']) == 0.0
                  ? "Free"
                  : shipInfo[0]['__value__'] + shipInfo[0]['@currencyId']
              : i['shippingInfo'][0]['shippingType'][0];
          final item = new Product(
              title: i['title'][0],
              galleryURL: i['galleryURL'][0],
              price: i['sellingStatus'][0]['currentPrice'][0]['__value__'] +
                  " " +
                  i['sellingStatus'][0]['currentPrice'][0]['@currencyId'],
              shipping: shipCost + " shipping",
              condition: condition);
          productData.add(item);
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(164, 175, 195, 1.0),
        title: this.cusSearchBar,
        actions: <Widget>[
          new IconButton(
            icon: this.cusIcon,
            onPressed: () {
              setState(() {
                if (this.cusIcon.icon == Icons.search) {
                  this.cusIcon = Icon(Icons.cancel);
                  this.cusSearchBar = TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search for anything",
                        hintStyle: TextStyle(color: Colors.white)),
                    textInputAction: TextInputAction.go,
                    style: TextStyle(color: Colors.white),
                    onSubmitted: (value) {
                      this.keyword = value;
                      _fetchData(value, this.pageNumber.toString());
                    },
                  );
                } else {
                  this.cusIcon = Icon(Icons.search);
                  this.cusSearchBar = Text("eBay Search");
                }
              });
            },
          )
        ],
      ),
      body: new Center(
          child: _isLoading
              ? new CircularProgressIndicator()
              : this.productData.length != 0
                  ? new ListView.builder(
                      controller: _scrollController,
                      itemCount: this.productData != null
                          ? this.productData.length
                          : 0,
                      itemBuilder: (context, i) {
                        final prod = this.productData[i];
                        return new FlatButton(
                          padding: new EdgeInsets.all(0.0),
                          child: new ProductDataCell(product: prod),
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        new DetailPage(product: prod)));
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text('Oops! No exact matches found.',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          )))),
    ));
  }
}
