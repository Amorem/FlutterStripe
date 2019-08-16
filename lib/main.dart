import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'models/app_state.dart';
import 'pages/login_page.dart';
import 'pages/products_page.dart';
import 'pages/register_page.dart';
import 'redux/actions.dart';
import 'redux/reducers.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(),
      middleware: [thunkMiddleware, LoggingMiddleware.printer()]);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Flutter Stripe',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.cyan[400],
          accentColor: Colors.deepOrange[200],
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 18.0),
          ),
        ),
        routes: {
          "/": (BuildContext context) => ProductsPage(onInit: () {
                // dispatch an action (getUserAction) to grab user data
                StoreProvider.of<AppState>(context).dispatch(getUserAction);
                StoreProvider.of<AppState>(context).dispatch(getProductsAction);
              }),
          LoginPage.routeName: (BuildContext context) => LoginPage(),
          RegisterPage.routeName: (BuildContext context) => RegisterPage(),
        },
      ),
    );
  }
}
