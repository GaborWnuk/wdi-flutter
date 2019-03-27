import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

const baseUrl = 'https://api.graph.cool';
class API {
  static Future getPosts() {
    var url = baseUrl + '/simple/v1/cjmauvhjv05wy0135z9z0cl7k';
    Map<String,String> headers = {
      'Content-type' : 'application/json', 
      'Accept': 'application/json',
    };
    return http.post(url,
                      body: json.encode({'query': '{allPosts{id avatarUri userName location imageUri text}}'}),
                      headers: headers);
  }
}


class Post {
  String id;
  String avatarUri;
  String userName;
  String location;
  String imageUri;
  String text;
  Post(String id, String avatarUri, String userName, String location, String imageUri, String text) {
    this.id = id;
    this.avatarUri = avatarUri;
    this.userName = userName;
    this.location = location;
    this.imageUri = imageUri;
    this.text = text;
  }
  Post.fromJson(Map json)
      : id = json['id'],
        avatarUri = json['avatarUri'],
        userName = json['userName'],
        location = json['location'],
        imageUri = json['imageUri'],
        text = json['text'];
  Map toJson() {
    return {'id': id, 'userName': userName, 'avatarUri': avatarUri, 'location': location, 'imageUri': imageUri, 'text': text};
  }
}

class PostCell extends StatelessWidget {
  PostCell({@required this.post});
  final Post post;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Row(
          children: <Widget>[
                  Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(post.avatarUri)
                            )
                        ),
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(post.userName, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("@" + post.location, style: TextStyle(fontWeight: FontWeight.w300)),
                    ])]
          )
        ),
      GestureDetector(
        child: Image.network(post.imageUri, fit: BoxFit.cover),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => DetailScreen(post: post))
          );
      }),
      Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text(post.text)],
            ),
          ),
        ],
      ),
      )],
    );
  }
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WDI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var posts = new List<Post>();
  _getPosts() {
    API.getPosts().then((response) {
      setState(() {
        Iterable list = json.decode(response.body)['data']['allPosts'];
        posts = list.map((model) => Post.fromJson(model)).toList();
      });
    });
  }
  @override
  initState() {
    super.initState();
    _getPosts();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostCell(post: posts[index]);
        },
      ),
      
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo
  final Post post;
  // In the constructor, require a Todo
  DetailScreen({Key key, @required this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Use the Todo to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Column(children: <Widget>[PostCell(post: post)]),
    );
  }
}
