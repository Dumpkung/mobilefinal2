import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class PhotosScreen extends StatelessWidget{
  final int id;

  const PhotosScreen({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Photos'),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: this.fetchPhotos(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData){
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Photo photo = snapshot.data[index];
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text('${photo.id}'),
                                Text('${photo.title}'),
                                Image.network(
                                  '${photo.thumbnailUrl}',
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  )
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return CircularProgressIndicator();
            },
          )
        ]
      ),
    );
  }

  Future<List<Photo>> fetchPhotos() async {
    final response = await http.get('https://jsonplaceholder.typicode.com/albums/$id/photos');
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<Photo> photos = json.decode(response.body).map<Photo>((photo) => Photo.fromJson(photo)).toList();
      return photos;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load posts');
    }
  }
}

class Photo{
  final int id;
  final String title;
  final String thumbnailUrl;

  Photo({this.id, this.title, this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json){
    return Photo(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl']
    );
  }
}