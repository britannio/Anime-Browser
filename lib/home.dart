import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'description.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:shimmer/shimmer.dart';

const String appName = "Anime Catalog";
const String rating_url =
    "http://apps.britannio.com/anime_browser/v1/content/top_rated.json";
const String popularity_url =
    "http://apps.britannio.com/anime_browser/v1/content/most_popular.json";
const String kDarkMode = "dark_mode";
const String fav_id_key = "fav_item_key";

class HomePage extends StatefulWidget {
  final int dropDownValue;

  HomePage(this.dropDownValue);

  _HomePageState createState() => _HomePageState(dropDownValue);
}

class _HomePageState extends State<HomePage> {
  final int dropDownValue;

  _HomePageState(this.dropDownValue);

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

  var _saved = [];

  /* _saveIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _saved = (prefs.getStringList("saved_index"));
  } */

  String stringFromArray(List list, String separator) {
    String _output;
    int arrayLength = list.length;
    for (int i = 0; i < arrayLength; i++) {
      if (i == 0) {
        _output = "${list[i]}";
      } else {
        _output = "$_output $separator ${list[i]}";
      }
    }
    return _output;
  }

  Future<Null> changeFavourites({String malId, bool add}) async {
    final SharedPreferences prefs = await _prefs;

    var oldList = prefs.getStringList(fav_id_key);
    print("before change - $oldList");

    if (add) {
      // Add id to the string array
      if (oldList == null) {
        prefs.setStringList(fav_id_key, [malId]);
      } else {
        oldList.add(malId);
        prefs.setStringList(fav_id_key, oldList);
      }
    } else {
      // Remove id from the string array
      oldList.remove(malId);
      prefs.setStringList(fav_id_key, oldList);
    }
    _saved = oldList;
    print("after change - $_saved");
  }

  Future<Null> getFavourites() async {
    final SharedPreferences prefs = await _prefs;
    var favourites = prefs.getStringList(fav_id_key);
    print("pref - $favourites");
    this.setState(
      () {
        if (favourites != null) {
          _saved = favourites;
        } else {
          _saved = [];
        }
      },
    );
  }

  Widget _buildCard(int index) {
    final alreadySaved =
        _saved != null ? _saved.contains(data[index]["id"]) : false;
    return Container(
      height: 160.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        color: Theme.of(context).cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0), // BR of the splash
          enableFeedback: true,
          onTap: () {
            // Go to the description page
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DescriptionPage(
                        img: data[index]["img"],
                        name: data[index]["name"],
                        genre: data[index]["genres"],
                        rating: data[index]["rating"],
                        studio: data[index]["studio"],
                        description: data[index]["description"],
                        duration: data[index]["duration"],
                        licensors: data[index]["licensors"],
                        popularity: data[index]["popularity"],
                        producers: data[index]["producers"],
                        rank: data[index]["rank"],
                        season: data[index]["season"],
                        url: data[index]["url"],
                        episodes: data[index]["episodes"],
                        id: data[index]["id"],
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
                child:
                    /* DecoratedBox(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                data[index]["img"]))),
                  ) */
                    Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      bottomLeft: Radius.circular(4.0),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        data[index]["img"],
                        errorListener: () {
                          print("Image failed to load");
                        },
                      ), //NetworkImage(data[index]["img"]),
                      fit: BoxFit.fill,
                    ),
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
                    SizedBox(height: 8.0),
                    Container(
                      margin: EdgeInsets.only(right: 12.0),
                      child: Text(
                        data[index]["name"],
                        style: Theme.of(context).textTheme.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    //SizedBox(height: 10.0),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              stringFromArray(data[index]["genres"], "|"),
                              style: Theme.of(context)
                                  .textTheme
                                  .subhead
                                  .copyWith(fontSize: 16.0),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              data[index]["studio"],
                              style: Theme.of(context)
                                  .textTheme
                                  .subhead
                                  .copyWith(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      // Rating graphic, episodes and favourite button
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            //shape: BoxShape.rectangle,
                            color: Theme.of(context).accentColor,
                          ),
                          padding: EdgeInsets.symmetric(
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
                              Text(
                                data[index]["rating"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${data[index]["episodes"]} eps · ${data[index]["duration"]} mins",
                            style: Theme.of(context)
                                .textTheme
                                .subhead
                                .copyWith(fontSize: 16.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            alreadySaved
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            setState(() {
                              if (alreadySaved) {
                                _saved.remove(data[index]["id"]);
                                changeFavourites(
                                    malId: data[index]["id"], add: false);
                                print(data[index]["name"] +
                                    " removed from favourites");
                              } else {
                                _saved.add(data[index]["id"]);
                                changeFavourites(
                                    malId: data[index]["id"], add: true);
                                print(data[index]["name"] +
                                    " added to favourites");
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
      ),
    );
  }

  List data; // Holds json data

  // Retreives json data
  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull(dropDownValue == 0 ? rating_url : popularity_url),
        headers: {"Accept": "application/json"});

    if (this.mounted) {
      this.setState(() {
        // Calls the build method which re-renders the listview
        data = json.decode(response.body);
        //print(data);
      });
    }

    return "Success!";
  }

  @override
  void initState() {
    // Will run before anything is rendered on the screen
    this.getFavourites();
    this.getData();
    super.initState();
  }
}
