import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'description.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

const String appName = "Anime Catalog";
const String animeUrl = "http://androiddemos.britannio.com/anime.json";
const String kDarkMode = "dark_mode";

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
              child: _buildCard(index));
        },
      ),
    );
  }

  var _saved = Set<int>();

  /* _saveIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _saved = (prefs.getStringList("saved_index"));
  } */

  Widget _buildCard(int index) {
    final alreadySaved = _saved.contains(index);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      color: Theme.of(context).cardColor,
      child: InkWell(
        enableFeedback: true,
        onTap: () {
          // Go to the description page
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DescriptionPage(
                      data[index]["img"],
                      data[index]["name"],
                      data[index]["category"],
                      data[index]["Rating"],
                      data[index]["studio"],
                      data[index]["description"],
                    )
                // Fat arrow notation so context is an argument and DescriptionPage is the function being invoked
                ),
          );
          print(data[index]["name"] + " selected");
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 100.0,
              height: 160.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    bottomLeft: Radius.circular(4.0)),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(data[index]["img"],
                      errorListener: () {
                    print("Image failed to load");
                  }), //NetworkImage(data[index]["img"]),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Text(
                    data[index]["name"],
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: 10.0),
                  Text(data[index]["category"],
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(fontSize: 16.0)),
                  SizedBox(height: 10.0),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
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
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          data[index]["studio"],
                          style: Theme.of(context)
                              .textTheme
                              .subhead
                              .copyWith(fontSize: 16.0),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          alreadySaved ? Icons.favorite : Icons.favorite_border,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          setState(() {
                            if (alreadySaved) {
                              _saved.remove(index);
                              print(data[index]["name"] +
                                  " removed from favourites");
                            } else {
                              _saved.add(index);
                              print(
                                  data[index]["name"] + " added to favourites");
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List data; // Holds json data

  // Retreives json data
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
}
