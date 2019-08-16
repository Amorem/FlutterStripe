import 'package:flutter/material.dart';

import '../models/product.dart';
import './products_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product item;

  ProductDetailPage({this.item});

  @override
  Widget build(BuildContext context) {
    final String pictureUrl = 'http://localhost:1337${item.picture['url']}';
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Container(
        decoration: gradientBackground,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Image.network(pictureUrl, fit: BoxFit.cover),
            ),
            Text(
              item.name,
              style: Theme.of(context).textTheme.title,
            ),
            Text(
              '\$${item.price}',
              style: Theme.of(context).textTheme.body1,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 32, right: 32),
                  child: Text(item.description),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
