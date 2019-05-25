import 'package:flutter/material.dart';
import 'package:flutter_final/allpage/database.dart';
import 'package:flutter_final/allpage/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';


class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}


class LoginState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreen();
  }
}

class LoginScreen extends State<LoginState> {
  final _formKey = new GlobalKey<FormState>();
  String userid;
  String password;

  UserProvider database = UserProvider();

  @override
  initState() {
    super.initState();
    this._checkuserlogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child:
          Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(
              children: <Widget>[
                new Center(child: Image.asset("img/login.jpg", width: 200, height: 200,fit: BoxFit.cover,),),
                new Center(
                  child: TextFormField(
                    decoration: InputDecoration(
                    icon: Icon(Icons.account_box),
                    hintText: 'User id'),
                    validator: (value) {
                        if(value.isEmpty) {
                          return 'Please fill out this form';
                        }
                    },
                    keyboardType: TextInputType.text,
                    onSaved: (value) {
                      this.userid = value;
                    },
                  ), 
                ),
                new Center(
                  child: TextFormField(
                      decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      hintText: 'Password'),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        this.password = value;
                      },
                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Please fill out this form';
                        }
                      },
                  ),
                ),
                
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("LOGIN"),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _formKey.currentState.save();
                        await database.open('user.db');
                        print(await database.getAllUser());

                        User user = await database.auth(this.userid, this.password);
                        
                        print(user);
                        if (user == null){
                          this._loginfail();
                        }
                        else{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('user', user.id);
                          await prefs.setString('name', user.name);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeState()));
                        }
                      }
                    },
                  ),
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        child: Text(
                          "Register New Account",
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterState()));
                        })),
              ],
            )
          ),
        )
      )
    );
  }
  void _loginfail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Wrong!"),
          content: new Text("Invalid user or password"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("done"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _checkuserlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('user') != null){
      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeState()));
    }
  }
}
