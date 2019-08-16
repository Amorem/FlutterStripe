import 'package:meta/meta.dart';

@immutable
class AppState {
  final dynamic user;
  final List<dynamic> products;

  AppState({@required this.user, @required this.products});

  factory AppState.initial() {
    return AppState(user: null, products: []);
  }
}
