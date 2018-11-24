import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'info_dialog.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

String appName = MyApp.appName;

String stringFromArray(List list, String separator) {
  String _output;
  int arrayLength = list.length;
  for (int i = 0; i < arrayLength; i++) {
    if (i == 0) {
      _output = "${list[i]}";
    } else {
      _output = "$_output$separator${list[i]}";
    }
  }
  return _output;
}

class DescriptionPage extends StatefulWidget {
  final String img;
  final String name;
  final String rating;
  final String rank;
  final String popularity;
  final String studio;
  final String description;
  final String duration;
  final String url;
  final String season;
  final String episodes;
  final String id;

  final List genre;
  final List producers;
  final List licensors;

  DescriptionPage(
      {@required this.img,
      @required this.name,
      @required this.genre,
      @required this.rating,
      @required this.studio,
      @required this.description,
      @required this.duration,
      @required this.licensors,
      @required this.popularity,
      @required this.producers,
      @required this.rank,
      @required this.season,
      @required this.episodes,
      @required this.url,
      @required this.id});

  @override
  _DescriptionPageState createState() {
    return new _DescriptionPageState();
  }
}

class _DescriptionPageState extends State<DescriptionPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var _saved = [];

  @override
  Widget build(BuildContext context) {
    final alreadySaved = _saved != null ? _saved.contains(widget.id) : false;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        title: Text(appName, style: Theme.of(context).accentTextTheme.title,),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColorLight,
        actions: <Widget>[
          IconButton(
            tooltip: "Info",
            icon: Icon(Icons.info_outline),
            onPressed: () {
              infoDialog(context, appName: appName);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Theme.of(context).backgroundColor,
            child: Material(
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: EdgeInsets.only(),
                /* padding: EdgeInsets.only(
                    bottom: 8.0, left: 24.0, right: 24.0, top: 8.0), */
                child: Column(
                  children: <Widget>[
                    Container(
                        color: Theme.of(context).primaryColorLight,
                        // One i'm working on
                        padding: EdgeInsets.only(
                            bottom: 8.0, left: 24.0, right: 24.0, top: 8.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 154.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 154.0,
                                    width: 99.0,
                                    child: CachedNetworkImage(
                                      // 9x14
                                      height: 154.0,
                                      width: 99.0,
                                      fit: BoxFit.fitHeight,
                                      imageUrl: widget.img,
                                      placeholder: Container(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                      errorWidget: Icon(Icons.error),
                                    ),
                                    /* Hero(
                              tag: "hero_tag",
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            widget.url))),
                              ),
                            ), */
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // Contains the name, genre, studio and rating,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                widget.name,
                                                style: Theme.of(context)
                                                    .accentTextTheme
                                                    .title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                stringFromArray(
                                                    widget.genre, " | "),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subhead
                                                    .copyWith(fontSize: 16.0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                widget.studio,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subhead
                                                    .copyWith(fontSize: 16.0),
                                              ),
                                              //SizedBox(height: 4.0),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            SizedBox(
                                              width: 2.0,
                                            ),
                                            Text(widget.rating,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0)),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            IconButton(
                                              //padding: EdgeInsets.zero,
                                              icon: Icon(
                                                alreadySaved
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  if (alreadySaved) {
                                                    //_saved.remove(widget.id);
                                                    changeFavourites(
                                                        malId: widget.id,
                                                        add: false);
                                                    print(widget.name +
                                                        " removed from favourites");
                                                  } else {
                                                    //_saved.add(widget.id);
                                                    changeFavourites(
                                                        malId: widget.id,
                                                        add: true);
                                                    print(widget.name +
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
                            SizedBox(
                              height: 12.0,
                            ),
                            Text(
                              "${widget.season} · ${widget.episodes} episodes · ${widget.duration} minutes",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline
                                  .copyWith(
                                      fontSize: 18.0, color: Colors.white),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        )),
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 8.0, left: 24.0, right: 24.0, top: 8.0),
                      child: Column(
                        children: <Widget>[
                          Divider(
                            color: Theme.of(context).dividerColor,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          DescriptionTextWidget(
                            text: widget.description,
                            licensors: widget.licensors,
                            producers: widget.producers,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  onPressed: () {
                                    _launchURL(widget.url);
                                  },
                                  child: Text(
                                    "VISIT SITE",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Theme.of(context).accentColor,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 200.0,
          ),
        ],
      ),
    );
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

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // Will run before anything is rendered on the screen
    this.getFavourites();
    super.initState();
  }

 
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;
  final List producers;
  final List licensors;

  DescriptionTextWidget(
      {@required this.text,
      @required this.producers,
      @required this.licensors});

  @override
  _DescriptionTextWidgetState createState() =>
      new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf;
  String secondHalf;
  final int startLength = 350;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > startLength) {
      firstHalf = widget.text.substring(0, startLength);
      secondHalf = widget.text.substring(startLength, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      //padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  firstHalf,
                  style: Theme.of(context).textTheme.body1,
                ),
                SizedBox(
                  height: 16.0,
                ),
                RichText(
                  text: TextSpan(
                      text: "Produced by ",
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 16.0),
                      children: <TextSpan>[
                        TextSpan(
                            text: stringFromArray(widget.producers, ", "),
                            style: Theme.of(context).textTheme.body1),
                        TextSpan(
                            text: "\n\nLicensed by",
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(fontSize: 16.0)),
                        TextSpan(
                            text: stringFromArray(widget.licensors, ", "),
                            style: Theme.of(context).textTheme.body1),
                      ]),
                )
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                  style: Theme.of(context).textTheme.body1,
                ),
                Container(
                    child: !flag
                        ? Column(
                            children: <Widget>[
                              SizedBox(
                                height: 16.0,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Produced by ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(fontSize: 16.0),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: stringFromArray(
                                              widget.producers, ", "),
                                          style: Theme.of(context)
                                              .textTheme
                                              .body1),
                                      TextSpan(
                                          text: "\n\nLicensed by ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .title
                                              .copyWith(fontSize: 16.0)),
                                      TextSpan(
                                          text: stringFromArray(
                                              widget.licensors, ", "),
                                          style: Theme.of(context)
                                              .textTheme
                                              .body1),
                                    ]),
                              )
                            ],
                          )
                        : null),
                new InkWell(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.blue,
                        child: Text(
                          flag ? "show more" : "show less",
                        ),
                        onPressed: () {
                          setState(() {
                            flag = !flag;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
