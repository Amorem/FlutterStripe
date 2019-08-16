import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart';
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Widget _cartTab() {
    return (Text('Cart'));
  }

  Widget _cardsTab() {
    return (Text('Cards'));
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
