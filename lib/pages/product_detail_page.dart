import 'package:flutter/material.dart';

import '../models/product.dart';
import './products_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product item;

  ProductDetailPage({this.item});

  @override
  Widget build(BuildContext context) {
    final String pictureUrl = 'http://localhost:1337${item.picture['url']}';
    final Orientation orientation = MediaQuery.of(context).orientation;
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
              child: Hero(
                tag: item.id,
                child: Image.network(
                  pictureUrl,
                  fit: BoxFit.cover,
                  width: orientation == Orientation.portrait ? 600 : 250,
                  height: orientation == Orientation.portrait ? 400 : 200,
                ),
              ),
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
