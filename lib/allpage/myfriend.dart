import 'package:flutter/material.dart';
import 'todo.dart';
import 'post.dart';
import 'albums.dart';

class MyFriendScreen extends StatelessWidget{
  final int id;
  final String name;

  const MyFriendScreen({Key key, this.id, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ListView(
          children: <Widget>[
            Text(
              "$id : $name",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            ),
            RaisedButton(
              child: Text("TODOS"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return TodoScreen(id: this.id);
                }));
              },
            ),
            RaisedButton(
              child: Text("POST"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return PostScreen(id: this.id);
                }));
              },
            ),
            RaisedButton(
              child: Text("ALBUMS"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return AlbumsScreen(id: this.id);
                }));
              },
            ),
            RaisedButton(
              child: Text(
                "BACK",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}