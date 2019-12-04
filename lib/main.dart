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
  var _isLoading = true;
  var prevKeyword = '';
  var pageNumber = 1;
  var totalPages;
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
        _fetchData("nike oregon ducks backpack", this.pageNumber.toString());
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
      // print("inside the if statement");
      productData.clear();
      this.prevKeyword = keyword;
      this.pageNumber = 1;
      pageNumber = "1";
    }
    // productData.clear();
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
      items.forEach((i) {
        final item = new Product(
            title: i['title'][0],
            galleryURL: i['galleryURL'][0],
            price: i['sellingStatus'][0]['currentPrice'][0]['__value__'] +
                " " +
                i['sellingStatus'][0]['currentPrice'][0]['@currencyId'],
            shipping: i['shippingInfo'][0]['shippingType'][0] + " shipping",
            condition: i['condition'][0]['conditionDisplayName'][0]);
        productData.add(item);
      });
      this.totalPages = int.parse(totalpage);
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
        title: new Text("eBay Search"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _fetchData(
                  "nike oregon ducks backpack", this.pageNumber.toString());
            },
          )
        ],
      ),
      body: new Center(
          child: _isLoading
              ? new CircularProgressIndicator()
              : new ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      this.productData != null ? this.productData.length : 0,
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
                )),
    ));
  }
}
