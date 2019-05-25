import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_final/allpage/database.dart';

import 'package:sqflite/sqflite.dart';

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

class RegisterState extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RegisterScreen();
  }
}

class RegisterScreen extends State<RegisterState>{
  final _formKey = GlobalKey<FormState>();
  String userId;
  String username;
  int age;
  String password;

  UserProvider userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
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
                      this.username = value;
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

                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Register new account"),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        _formKey.currentState.save();
                        User user = User(this.userId, this.username, this.age, this.password);
                        try {
                          await userProvider.open('user.db');
                          User userack = await userProvider.insert(user);
                          await userProvider.close();
                          Navigator.of(context).popUntil(ModalRoute.withName('/'));
                        }
                        on DatabaseException catch(e) {
                          if(e.isUniqueConstraintError()){
                            Navigator.of(context).pop();
                          }
                        }
                      }
                    },
                  )
                )
              ],
            ),
          ),
        ),
      )
    );
  }


}