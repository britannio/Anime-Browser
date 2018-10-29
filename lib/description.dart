import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              primary: true,
              backgroundColor: Theme.of(context).backgroundColor,
              floating: false,
              pinned: true,
              flexibleSpace: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: FlexibleSpaceBar(
                            title: Text(name),
                            collapseMode: CollapseMode.none,
                            background: CachedNetworkImage(imageUrl: "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                            fit: BoxFit.fitWidth),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
              child: Text(
                description,
                style:
                    Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text("Similar Content",
                  style: Theme.of(context).textTheme.subhead.copyWith(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 16.0,
                ),
                _buildContent2(
                    context,
                    "https://myanimelist.cdn-dena.com/r/108x163/s/common/store/cover/974/85b97a507be316ff690d728b22a9c0cbeac36161057e9b8a7fb0612df2e53d98/l.jpg?s=31aae211ae94d9b5aa7d14160e7aa6dd",
                    "7.5"),
                _buildContent2(
                    context,
                    "https://myanimelist.cdn-dena.com/s/common/store/cover/960/d12a3c79c4d0d46235c4bd35a1cc30664f818c4f15d34ea13dc328ab80f42ba6/l.jpg",
                    "7.6"),
                _buildContent2(
                    context,
                    "https://myanimelist.cdn-dena.com/s/common/store/cover/1367/0a8f4f9e7cbdfa6a3f5ca40e471df8a00ae3963a1b3894ea5a23d2a83f6ed9cd/l.jpg",
                    "8.0"),
                SizedBox(
                  width: 16.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
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
        ],
      ),
    );
  }

  Widget _buildContent2(BuildContext context, String imageUrl, String rating) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: () {},
        child: Container(
            width: 100.0,
            height: 160.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
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
            )),
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
