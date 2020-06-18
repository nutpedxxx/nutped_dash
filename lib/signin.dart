import 'package:flutter/material.dart';
import 'package:web/home.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _userName = "";
  String _passWord = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
          child: Card(
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(20),
          width: 300,
          height: 280,
          child: Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration:
                    InputDecoration(labelText: "Username", prefixIcon: Icon(Icons.account_circle)),
                onChanged: (value) {
                  _userName = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.textsms)),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                onChanged: (value) {
                  _passWord = value;
                },
              ),
              SizedBox(height: 16),
              RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text("Sign In"),
                  onPressed: () {
                    if ((_userName == "nutpedxxx@gmail.com") &&
                        (_passWord == "nutpedxxx@gmail.com")) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                    }
                  }),
            ],
          )),
        ),
      )),
    );
  }
}
