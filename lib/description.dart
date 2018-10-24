import 'package:flutter/material.dart';

class DescriptionPage extends StatelessWidget {
  final String img;
  final String name;
  final String category;
  final String rating;
  final String studio;
  final String description;

  DescriptionPage(this.img, this.name, this.category, this.rating, this.studio,
      this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Theme.of(context).backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      // Image
                      width: 100.0,
                      height: 160.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(img),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
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
                          Text(category,
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
                SizedBox(
                  height: 24.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 32.0,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
            child: Column(
              children: <Widget>[
                Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(fontSize: 16.0),
                ),
                Container(
                  /* child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 64.0,
                        height: 64.0,
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).dividerColor)
                        ),
                      )
                    ],), */
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
