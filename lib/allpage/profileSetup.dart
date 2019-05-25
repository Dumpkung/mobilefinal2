import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_final/allpage/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_final/utils/quote.dart';
import 'package:sqflite/sqflite.dart';


class ProfileSetupScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ProfileSetupScreenState();
  }
}

class ProfileSetupScreenState extends State<ProfileSetupScreen>{
  final _formKey = GlobalKey<FormState>();
  User user;
  UserProvider userProvider = UserProvider();

  String userId;
  String name;
  int age;
  String password;
  String quote;

  @override
  void initState() {
    super.initState();
    this._getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Setup'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          children: <Widget>[
            Center(
                  child: TextFormField(
                        decoration: InputDecoration(
                        icon: Icon(Icons.account_box),
                        hintText: 'User Id'),
                        validator: (value) {
                            if(value.length < 6 || value.length > 12) {
                              return 'User Id จะต้องมีความยาว ุ6-12 ตัวอักษร';
                            }
                        },
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          this.userId = value;
                        },
                      ),
                ),
                Center(
                  child: TextFormField(
                    decoration: InputDecoration(
                    icon: Icon(Icons.account_box),
                    hintText: 'Name'),
                    validator: (value) {
                        var values = value.trim().contains(' ');
                        if(!values) {
                          return 'Name จะต้องมีทั้งชื่อและนามสกุล';
                        }
                    },
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      this.name = value;
                    },
                  ),
             ),
             Center(
               child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    icon: Icon(Icons.calendar_today)
                  ),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (int.parse(value) < 10 || int.parse(value) > 80){
                      return 'ต้องเป็นตัวเลขเท่าน้ันและอยู่ในช่วง 10 - 80';
                    }
                  },
                  onSaved: (value) {
                    this.age = int.parse(value);
                  },
                ),
             ),
                Center(
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
                          if(value.length <= 6) {
                            return 'Password ต้องมีความยาวมากกว่า 6';
                          }
                        },
                  ),
                ),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Quote'
              ),
              maxLines: 2,
              onSaved: (value) {
                this.quote = value;
              },
            ),
            RaisedButton(
              child: Text("Save"),
              onPressed: () async {
                if(_formKey.currentState.validate()){
                  _formKey.currentState.save();
                  print(this.user);

                  this.user.userId = this.userId;
                  this.user.name = this.name;
                  this.user.age = this.age;
                  this.user.password = this.password;
                  print(this.user);
                  
                  try {
                    await userProvider.open('user.db');
                    await userProvider.update(this.user);
                    QuoteUtils.writeQuote(this.user.id, this.quote);

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('name', user.name);

                    Navigator.of(context).pop();
                  }
                  on DatabaseException catch(e) {
                    if(e.isUniqueConstraintError()){
                      this._showNotUniqueDialog();
                    }
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await this.userProvider.open('user.db');
    User user = await this.userProvider.getUser(prefs.getInt('user'));

    setState(() {
      this.user = user;
    });
  }

  void _showNotUniqueDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error"),
          content: new Text("This user Id is already registered"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Done"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}