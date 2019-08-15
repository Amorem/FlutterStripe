import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'products_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Identify uniquely the form state
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _obscureText = true;
  bool _isSubmitting = false;

  String _email, _password;

  Widget _showTitle() => Text(
        'Login',
        style: Theme.of(context).textTheme.headline,
      );

  Widget _showEmailInput() => Padding(
        padding: EdgeInsets.only(top: 20),
        child: TextFormField(
          validator: (value) => !value.contains('@') ? 'Invalid email' : null,
          onSaved: (value) => _email = value,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Enter a valid email',
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget _showPasswordInput() => Padding(
        padding: EdgeInsets.only(top: 20),
        child: TextFormField(
          validator: (value) =>
              value.length < 6 ? 'Password too short !' : null,
          onSaved: (value) => _password = value,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter password (min length 6)',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            ),
            suffixIcon: GestureDetector(
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget _showFormActions() => Padding(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          children: <Widget>[
            _isSubmitting
                ? CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Theme.of(context).accentColor),
                  )
                : RaisedButton(
                    child: Text(
                      'Submit',
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(color: Colors.black),
                    ),
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: _submit,
                  ),
            FlatButton(
              child: Text('New user ? Register'),
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(RegisterPage.routeName),
            )
          ],
        ),
      );

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _loginUser();
    }
  }

  Future<void> _loginUser() async {
    setState(() {
      _isSubmitting = true;
    });

    http.Response response = await http.post('http://localhost:1337/auth/local',
        body: {'identifier': _email, 'password': _password});

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _isSubmitting = false;
      });
      _showSuccessSnack();
      _redirectUser();
    } else {
      setState(() {
        _isSubmitting = false;
        final String errorMsg = responseData['message'];
        _showErrorSnack(errorMsg);
      });
    }
  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
      content: Text(
        'Successfully logged in',
        style: TextStyle(color: Colors.green),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack(String errorMessage) {
    final snackbar = SnackBar(
      content: Text(
        errorMessage,
        style: TextStyle(color: Colors.red),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void _redirectUser() {
    Future.delayed(
        Duration(seconds: 3),
        () =>
            Navigator.of(context).pushReplacementNamed(ProductsPage.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _showTitle(),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showFormActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
