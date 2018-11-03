import 'package:flutter/material.dart';
import 'launch_url.dart';

// Alert Dialog
void infoDialog(BuildContext context,{@required String appName}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(appName, style: Theme.of(context).textTheme.title),
        content: RichText(
          text: TextSpan(
            text:
                "This is a flutter equivalent of an app previously made with native android code. The native android version only fetched a json file and outputted it as a styled list of cards, this version has many more features.",
            style: Theme.of(context).textTheme.body1,
            /* children: <TextSpan>[
                TextSpan(
                  text: "http://androiddemos.britannio.com/anime.json",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline),
                )
              ], */
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("DISMISS"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("GITHUB"),
            onPressed: () {
              Navigator.of(context).pop();
              launchURL("https://github.com/britannio/Anime-Browser");
            },
          ),
        ],
      );
    },
  );
}
