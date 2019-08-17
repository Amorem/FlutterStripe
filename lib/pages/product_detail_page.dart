import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_stripe/models/app_state.dart';
import 'package:flutter_stripe/redux/actions.dart';

import '../models/product.dart';
import './products_page.dart';

class ProductDetailPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Product item;
  ProductDetailPage({this.item});

  bool _isInCart(AppState state, String id) {
    final List<Product> cartProducts = state.cartProducts;
    return cartProducts.indexWhere((cartProducts) => cartProducts.id == id) >
        -1;
  }

  @override
  Widget build(BuildContext context) {
    final String pictureUrl = 'http://192.168.1.16:1337${item.picture['url']}';
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      key: _scaffoldKey,
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (_, state) {
                    return state.user != null
                        ? IconButton(
                            icon: Icon(Icons.shopping_cart,
                                color: _isInCart(state, item.id)
                                    ? Colors.cyan[700]
                                    : Colors.white),
                            onPressed: () {
                              StoreProvider.of<AppState>(context)
                                  .dispatch(toggleCartProductAction(item));
                              final snackbar = SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(
                                  'Cart updated',
                                  style: TextStyle(color: Colors.green),
                                ),
                              );
                              _scaffoldKey.currentState.showSnackBar(snackbar);
                            },
                          )
                        : Text('');
                  }),
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
