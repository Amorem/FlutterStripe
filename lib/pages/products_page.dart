import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../models/app_state.dart';

class ProductsPage extends StatefulWidget {
  static const routeName = "/products";

  final void Function() onInit;

  ProductsPage({this.onInit});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  final _appBar = PreferredSize(
    preferredSize: Size.fromHeight(60),
    child: StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return AppBar(
          centerTitle: true,
          title: SizedBox(child: state.user !=null ? Text(state.user.username) : Text(""),),
          leading: Icon(Icons.store),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: state.user != null ? IconButton(icon: Icon(Icons.exit_to_app), onPressed: () {},) : Text(''),
            )
          ],
        );
      }
    ),
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar, body: Container(child: Text("Product Pages"),),)
  }
}
