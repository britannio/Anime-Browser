import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'description.dart';

/* 
TODO
-Add theme changing
-Use slivers to create the collapsing toolbar effect for the description page
-Make the hyperlink in the information dialog work  
 */

void main() => runApp(new MyApp());

const String appName = "Anime Catalog";
const String animeUrl = "http://androiddemos.britannio.com/anime.json";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appName,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data;

  Future<String> getData() async {
    var response = await http
        .get(Uri.encodeFull(animeUrl), headers: {"Accept": "application/json"});

    this.setState(() {
      // Calls the build method which re-renders the listview
      data = json.decode(response.body);
    });

    return "Success!";
  }

  @override
  void initState() {
    // Will run before anything is rendered on the screen
    this.getData();
    super.initState();
  }

  void _infoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appName),
          content: RichText(
            text: TextSpan(
                text:
                    "This is a flutter equivalent of an app previously made with native android code. It used a network request to fetch the following json file then outputted a styled equivalent.\nsrc:",
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "http://androiddemos.britannio.com/anime.json",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline),
                    //recognizer: TapGestureRecognizer()..onTap = (){}
                  )
                ]),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("DISMISS"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(appName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _infoDialog();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
            child: InkWell(
              enableFeedback: true,
              onTap: () {
                // Go to the description page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DescriptionPage(data[index]["img"],data[index]["name"],data[index]["category"],data[index]["Rating"],data[index]["studio"],data[index]["description"],)
                    // Fat arrow notation so context is an argument and DescriptionPage is the function being invoked
                  ),
                );

                print(data[index]["name"] + " selected");
              },
              child: Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100.0,
                      height: 160.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(data[index]["img"]),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Text(
                          data[index]["name"],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.grey.shade600),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          data[index]["category"],
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey.shade600),
                        ),
                        SizedBox(height: 10.0),
                        DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                                Text(data[index]["Rating"],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          data[index]["studio"],
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
