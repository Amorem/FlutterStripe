import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../redux/actions.dart';

import '../models/app_state.dart';
import '../models/product.dart';
import '../pages/product_detail_page.dart';

class ProductItem extends StatelessWidget {
  final Product item;
  ProductItem({this.item});

  bool _isInCart(AppState state, String id) {
    final List<Product> cartProducts = state.cartProducts;
    return cartProducts.indexWhere((cartProducts) => cartProducts.id == id) >
        -1;
  }

  @override
  Widget build(BuildContext context) {
    final String pictureUrl = 'http://localhost:1337${item.picture['url']}';
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ProductDetailPage(item: item);
          },
        ),
      ),
      child: GridTile(
        child: Hero(
          tag: item.id,
          child: Image.network(pictureUrl, fit: BoxFit.cover),
        ),
        footer: GridTileBar(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              item.name,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          subtitle: Text(
            '\$${item.price}',
            style: TextStyle(fontSize: 16.0),
          ),
          trailing: StoreConnector<AppState, AppState>(
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
                        },
                      )
                    : Text('');
              }),
          backgroundColor: Color(0xBB000000),
        ),
      ),
    );
  }
}
