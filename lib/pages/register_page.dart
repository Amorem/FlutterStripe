import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: <Widget>[
                  Text(
                    'Register',
                    style: Theme.of(context).textTheme.headline,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter username (min length 6)',
                        icon: Icon(
                          Icons.face,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: TextFormField(
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter password (min length 6)',
                        icon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: <Widget>[
                        RaisedButton(
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
                          color: Theme.of(context).primaryColor,
                          onPressed: () {},
                        ),
                        FlatButton(
                          child: Text('Existing user ? Login'),
                          onPressed: () {},
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
