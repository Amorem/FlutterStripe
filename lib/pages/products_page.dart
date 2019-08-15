import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsPage extends StatefulWidget {
  static const routeName = "/products";

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var storedUser = prefs.getString('user');
    print(json.decode(storedUser));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Products'),
    );
  }
}
