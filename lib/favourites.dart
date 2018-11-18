import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:convert'; // for json
import 'package:http/http.dart' as http;
import 'description.dart';
import 'package:url_launcher/url_launcher.dart';

class FavouritesPage extends StatefulWidget {
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> with AutomaticKeepAliveClientMixin<FavouritesPage>{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _saved = [];
  //List<Widget> idTextList = _saved.map((item) => new Text(map)).toList());

  List<Container> _cards = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListView.builder(
        itemCount: _cards == null ? 0 : _cards.length,
        itemBuilder: (BuildContext context, int index) {
          return _cards[index]; //_buildCard(index));
        },
      ),
    );
  }

  Future<Null> getFavourites() async {
    final SharedPreferences prefs = await _prefs;
    var favourites = prefs.getStringList("fav_item_key") != null
        ? prefs.getStringList("fav_item_key")
        : List<String>();
    print("pref - $favourites");

    int cardIndex = 0;

    for (var id in favourites) {
      var response = await http.get(
          Uri.encodeFull(
              "http://apps.britannio.com/anime_browser/v1/items/$id.json"),
          headers: {"Accept": "application/json"});

      var data = json.decode(response.body);

      //_cards = [];
      _cards.add(_buildCard(data, cardIndex));
      cardIndex++;
    }

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

  Future<Null> changeFavourites({String malId, bool add}) async {
    // add functionality required to undo changes
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

  @override
  void initState() {
    // Will run before anything is rendered on the screen
    this.getFavourites();
    super.initState();
    print("favourites.dart: initState invoked");
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildCard(var data, var cardIndex) {
    // use http://apps.britannio.com/anime_browser/v1/items/{ITEM_ID}.json
    // to retrieve json
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
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
                        img: data["img"],
                        name: data["name"],
                        genre: data["genres"],
                        rating: data["rating"],
                        studio: data["studio"],
                        description: data["description"],
                        duration: data["duration"],
                        licensors: data["licensors"],
                        popularity: data["popularity"],
                        producers: data["producers"],
                        rank: data["rank"],
                        season: data["season"],
                        url: data["url"],
                        episodes: data["episodes"],
                        id: data["id"],
                      )
                  // Fat arrow notation so context is an argument and DescriptionPage is the function being invoked
                  ),
            );
            print(data["name"] + " selected");
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
                                data["img"]))),
                  ) */
                    Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      bottomLeft: Radius.circular(4.0),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        data["img"],
                        errorListener: () {
                          print("Image failed to load");
                        },
                      ), //NetworkImage(data["img"]),
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
                        data["name"],
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
                              data["season"],
                              //stringFromArray(data["genres"], "|"),
                              style: Theme.of(context)
                                  .textTheme
                                  .subhead
                                  .copyWith(fontSize: 16.0),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${data["episodes"]} eps · ${data["duration"]} mins",
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
                                data["rating"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            child: Text(
                              "VISIT SITE",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              _launchURL(data["url"]);
                            },
                          ),
                        ),
                        /* Expanded(
                          child: Text(
                            "${data["episodes"]} eps · ${data["duration"]} mins",
                            style: Theme.of(context)
                                .textTheme
                                .subhead
                                .copyWith(fontSize: 16.0),
                            textAlign: TextAlign.center,
                          ),
                        ), */
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _saved.remove(data["id"]);
                              _cards[cardIndex] = null;
                              //_cards.removeAt(cardIndex);
                              changeFavourites(malId: data["id"], add: false);
                              print(data["name"] + " removed from favourites");
                              print("debug $_saved");
                              print("debug $_cards");
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
}
