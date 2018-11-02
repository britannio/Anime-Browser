import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

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

class DescriptionPage extends StatelessWidget {
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
      @required this.url});

  @override
  Widget build(BuildContext context) {
    final alreadySaved = false;

    return Scaffold(
        backgroundColor: Color(0xFF090909),
        appBar: AppBar(
          title: Text(""),
          elevation: 0.0,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 380.0, // Temporary
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 160.0,
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CachedNetworkImage(
                          width: 100.0,
                          fit: BoxFit.fitHeight,
                          imageUrl: img,
                          placeholder: Container(
                            color: Theme.of(context).primaryColorLight,
                          ),
                          errorWidget: Icon(Icons.error),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Column(
                          // Contains the category, rating and studio
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 12.0,
                            ),
                            Text(
                              name,
                              style: Theme.of(context).textTheme.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Text(stringFromArray(genre, "|"),
                                style: Theme.of(context)
                                    .textTheme
                                    .subhead
                                    .copyWith(fontSize: 16.0)),
                            SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              studio,
                              style: Theme.of(context)
                                  .textTheme
                                  .subhead
                                  .copyWith(fontSize: 16.0),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                    SizedBox(
                                      width: 2.0,
                                    ),
                                    Text(rating,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0)),
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                IconButton(
                                  icon: Icon(
                                    alreadySaved
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            _launchURL(img); // Will be the url
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
        ));
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildHeaderContent(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 48.0),
      margin: EdgeInsets.only(top: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                width: 100.0,
                height: 160.0,
                fit: BoxFit.fitHeight,
                imageUrl: img,
                placeholder: Container(
                  color: Theme.of(context).primaryColorLight,
                ),
                errorWidget: Icon(Icons.error),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                // Wrapped in an Expanded widget to prevent text cutoff
                child: Column(
                  // Contains the category, rating and studio
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 32.0),
                    Text(stringFromArray(genre, "|"),
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(fontSize: 16.0)),
                    SizedBox(height: 16.0),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        SizedBox(
                          width: 2.0,
                        ),
                        Text(rating,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0)),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      studio,
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent2(
      BuildContext context, String imageUrl, String rating, String name) {
    return Material(
      color: Color(0xFF090909),
      child: Card(
        color: Theme.of(context).cardColor,
        child: Container(
          width: 112.0,
          height: 224.0,
          child: InkWell(
              borderRadius: BorderRadius.circular(4.0),
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 112.0,
                    height: 160.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0)),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: CachedNetworkImageProvider(imageUrl),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        margin: EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: 2.0,
                            ),
                            Text(
                              rating,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: Theme.of(context).accentColor),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(name,
                        maxLines: 3,
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontSize: 14.0)),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildContent1(BuildContext context) {
    return Container(
      height: 160.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(
            width: 24.0,
          ),
          Container(
            width: 220.0,
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(4.0)),
            child: InkWell(
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // Contains the image
                    width: 100.0,
                    height: 160.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          bottomLeft: Radius.circular(4.0)),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(img),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(height: 16.0),
                        Text(
                          name,
                          style: Theme.of(context).textTheme.title,
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                shape: BoxShape.rectangle,
                                color: Theme.of(context).accentColor,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  SizedBox(
                                    width: 2.0,
                                  ),
                                  Text(rating,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
