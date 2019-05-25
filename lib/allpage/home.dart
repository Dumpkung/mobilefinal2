import 'package:flutter/material.dart';
import 'package:flutter_final/allpage/database.dart';
import 'package:flutter_final/allpage/profileSetup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_final/utils/quote.dart';

class HomeState extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeScreen();
  }
}

class HomeScreen extends State<HomeState>{
  User user;
  String name;
  String quote;

  UserProvider userProvider = UserProvider();


  @override
  Widget build(BuildContext context) {
    this._getUser();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Text(
                "Hello ${this.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            SizedBox(
              width: double.infinity,
              child: Text(
                'this is my quote "${this.quote}"',
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text("Profile Setup"),
                onPressed: () {
                 Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileSetupScreen()));
                },
              )
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text("My Friend"),
              )
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text("Logout"),
                onPressed: () {
                  this.logout();
                },
              )
            )
          ],
        ),
      ),
    );
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('name');
    Navigator.of(context).pushReplacementNamed('/');
  }



  void _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await this.userProvider.open('user.db');
    if(prefs.containsKey('user')){
      User user = await this.userProvider.getUser(prefs.getInt('user'));
      String quote = await QuoteUtils.readQuote(user.id);

      setState(() {
        this.name = prefs.getString('name');
        this.user = user;
        this.quote = quote;
      });
    }
  }
}