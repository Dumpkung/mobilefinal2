import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'comment.dart';

class PostScreen extends StatelessWidget{
  final int id;

  const PostScreen({Key key, this.id}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: RaisedButton(
                child: Text('Back'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ),
          ),
          FutureBuilder(
            future: this.fetchPost(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData){
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Post post = snapshot.data[index];
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        child: Card(
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: ListTile(
                                title: Text('${post.id} : ${post.title}'),
                                subtitle: Text('${post.body}'),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                return CommentScreen(post: post);
                              }));
                            },
                          )
                        )
                      );
                    }
                  )
                );
              } else if (snapshot.hasError){
                return Text('${snapshot.error}');
              }
              return CircularProgressIndicator();
            },
          ),
        ]
      ),
    );
  }

  Future<List<Post>> fetchPost() async {
    final response = await http.get('https://jsonplaceholder.typicode.com/users/$id/posts');
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<Post> posts = json.decode(response.body).map<Post>((post) => Post.fromJson(post)).toList();
      return posts;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load posts');
    }
  }
}

class Post {
  final int id;
  final String title;
  final String body;

  Post({this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body']
    );
  }
}