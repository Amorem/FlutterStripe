import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_stripe/models/app_state.dart';
import 'package:flutter_stripe/widgets/product_item.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart';

  final void Function() onInit;

  CartPage({this.onInit});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void initState() {
    super.initState();
    widget.onInit();
  }

  Widget _cartTab() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => Column(
        children: <Widget>[
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: GridView.builder(
                itemCount: state.cartProducts.length,
                itemBuilder: (context, index) =>
                    ProductItem(item: state.cartProducts[index]),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    childAspectRatio:
                        orientation == Orientation.portrait ? 1.0 : 1.3),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _cardsTab() {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) => Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: state.cards
                        .map<Widget>(
                          (card) => (ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepOrange,
                              child: Icon(
                                Icons.credit_card,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                                '${card['exp_month']}/${card['exp_year']}, ${card['last4']}'),
                            subtitle: Text(card['brand']),
                            trailing: FlatButton(
                              child: Text(
                                'Set as Primary',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          )),
                        )
                        .toList(),
                  ),
                )
              ],
            ));
  }

  Widget _ordersTab() {
    return (Text('Orders'));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cart Page'),
          bottom: TabBar(
            labelColor: Colors.deepOrange[600],
            unselectedLabelColor: Colors.black,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.shopping_cart),
              ),
              Tab(
                icon: Icon(Icons.credit_card),
              ),
              Tab(
                icon: Icon(Icons.receipt),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[_cartTab(), _cardsTab(), _ordersTab()],
        ),
      ),
    );
  }
}
