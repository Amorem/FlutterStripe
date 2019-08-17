import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
//import 'package:stripe_payment/stripe_payment.dart';

import '../models/app_state.dart';
import '../models/user.dart';
import '../widgets/product_item.dart';
import '../redux/actions.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart';

  final void Function() onInit;

  CartPage({this.onInit});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    widget.onInit();
    //StripeSource.setPublishableKey('pk_test_6FTOvxXVJH9h3yyPI7ZT4Kki');
  }

  Widget _cartTab(state) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Column(
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
    );
  }

  Widget _cardsTab(state) {
    _addCard(cardToken) async {
      final User user = state.user;

      // Update user's data to include cardToken (PUT /users/:id)
      await http.put('http://localhost:1337/users/${user.id}',
          body: {'card_token': cardToken},
          headers: {'Authorization': 'Bearer ${user.jwt}'});

      // Associate cardToken (added card) with Stripe customer (POST /card/add)
      http.Response response = await http.post('http://localhost:1337/card/add',
          body: {"source": cardToken, "customer": user.customerId});
      final responseData = json.decode(response.body);
      return responseData;
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        // RaisedButton(
        //   onPressed: () async {
        //     final String cardToken = await StripeSource.addSource();
        //     final card = await _addCard(cardToken);

        //     // Action to AddCard
        //     StoreProvider.of<AppState>(context)
        //         .dispatch(AddCardAction(card));

        //     // Action to update CardToken
        //     StoreProvider.of<AppState>(context)
        //         .dispatch(UpdateCardTokenAction(card['id']));

        //     // Show operations in with a snackbar
        //     final snackbar = SnackBar(
        //       content: Text(
        //         'Card added',
        //         style: TextStyle(color: Colors.green),
        //       ),
        //     );
        //     _scaffoldKey.currentState.showSnackBar(snackbar);
        //   },
        //   elevation: 8.0,
        //   child: Text('Add Card'),
        // ),
        Expanded(
          child: ListView(
            children: state.cards
                .map<Widget>(
                  (c) => (ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      child: Icon(
                        Icons.credit_card,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                        '${c['exp_month']}/${c['exp_year']}, ${c['last4']}'),
                    subtitle: Text(c['brand']),
                    trailing: state.cardToken == c['id']
                        ? Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                            ),
                            label: Text('Primary Card'),
                          )
                        : FlatButton(
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
                            onPressed: () {
                              StoreProvider.of<AppState>(context)
                                  .dispatch(UpdateCardTokenAction(c['id']));
                            },
                          ),
                  )),
                )
                .toList(),
          ),
        )
      ],
    );
  }

  Widget _ordersTab() {
    return (Text('Orders'));
  }

  String calculateTotalPrice(cartProducts) {
    double totalPrice = 0.0;
    cartProducts.forEach((cartProduct) {
      totalPrice += cartProduct.price;
    });
    return totalPrice.toStringAsFixed(2);
  }

  Future _showCheckOutDialog(state) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          if (state.cards.length == 0) {
            return AlertDialog(
              title: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text('Add Card'),
                  ),
                  Icon(
                    Icons.credit_card,
                    size: 26.0,
                  )
                ],
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      'Provide a credit card before checking out',
                      style: Theme.of(context).textTheme.body1,
                    )
                  ],
                ),
              ),
            );
          }
          String cartSummary = '';
          state.cartProducts.forEach((cartProduct) {
            cartSummary += "| ${cartProduct.name}, \$${cartProduct.price}\n";
          });
          final primaryCard =
              state.cards.singleWhere((card) => card['id'] == state.cardToken);
          print(primaryCard);
          return AlertDialog(
            title: Text('Checkout'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'CART ITEMS (${state.cartProducts.length})\n',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Text(
                    '$cartSummary',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Text(
                    'CARD DETAILS',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Text(
                    'Brand: ${primaryCard['brand']}',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Text(
                    'Card Number: ${primaryCard['last4']}',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Text(
                    'Expires On: ${primaryCard['exp_month']}/${primaryCard['exp_year']}\n',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Text(
                    'ORDER TOTAL: \$${calculateTotalPrice(state.cartProducts)}',
                    style: Theme.of(context).textTheme.body1,
                  )
                ],
              ),
            ),
            actions: [
              FlatButton(
                color: Colors.red,
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              RaisedButton(
                color: Colors.green,
                child: Text(
                  'Checkout',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          );
        }).then((value) => {
          if (value == true) {print('checkout')}
        });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) {
          return DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Scaffold(
              floatingActionButton: state.cartProducts.length > 0
                  ? FloatingActionButton(
                      backgroundColor: Colors.deepOrange,
                      child: Icon(
                        Icons.local_atm,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () => _showCheckOutDialog(state),
                    )
                  : Text(''),
              appBar: AppBar(
                title: Text(
                    'Summary: ${state.cartProducts.length} items | \$${calculateTotalPrice(state.cartProducts)}'),
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
                children: <Widget>[
                  _cartTab(state),
                  _cardsTab(state),
                  _ordersTab()
                ],
              ),
            ),
          );
        });
  }
}
