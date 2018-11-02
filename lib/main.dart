import 'package:flutter/material.dart';
import 'home.dart';
import 'favourites.dart';
import 'package:url_launcher/url_launcher.dart';
import 'appearance.dart';

/* 
TODO
 - Implement the dark theme toggle
 - Implement the favourites page feature
 - Add all data to the description page
 - Add shared element transitions to the anime image for the description page
 - Add a splash screen on Android and IOS
 - Establish themes
 - Add a scroll bar

CONSIDER for v2+
 - Use SQL or firebase to store item information
 - Think about a dynamic homepage with more compact cards
 - In the description page, after the description show a horizontal row of similar anime based on the category of the anime being viewed
 - Add an app icon
 - Adding search
 - Add accent color changing
 
 
 - Add sorting by popularity
 */

void main() => runApp(new MyApp());

const String appName = "Anime Browser";

final ThemeData _baseDarkTheme = ThemeData(primaryColor: Color(0xFF212121));

final ThemeData _darkTheme = ThemeData(
  canvasColor: _baseDarkTheme.primaryColor,
  backgroundColor: Color(0xFF141414),
  cardColor: _baseDarkTheme.primaryColor,
  accentColor: Colors.blue,
  primaryColor: _baseDarkTheme.primaryColor,
  primaryColorLight: Color(0xFF484848),
  textTheme: TextTheme(
    title: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    subhead: TextStyle(color: Color(0xFF9E9E9E)),
    headline: TextStyle(color: Color(0xFF9E9E9E)),
    body1: TextStyle(color: Colors.white),
  ),
  dialogBackgroundColor: _baseDarkTheme.primaryColor,
  dividerColor: Color(0xFF9E9E9E),
);

final ThemeData _lightTheme = ThemeData();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appName,
      theme: _darkTheme,
      home: new MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  // Equivalent to taking a bool parameter
  //var _darkTheme;
  //HomePage(this._darkTheme);

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _darkThemeEnabled = true;
  int dropDownValue = 0;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    // Scaffold key is required to refer to the context of the scaffold before it's context is available i.e. in the appbar
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(104.0),
          child: new AppBar(
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppBar(
                  elevation: 0.0,
                  title: new Text(appName),
                  actions: <Widget>[
                    IconButton(
                      tooltip: "Info",
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        /* final snackBar = SnackBar(
                          content: Text("Feature unavailable"),
                          action: SnackBarAction(
                            label: "OKAY",
                            onPressed: () {},
                          ),
                        );

                        // Find the Scaffold in the Widget tree and use it to show a SnackBar
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        print("Snackbar pressed"); */
                        _infoDialog();
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    TabBar(
                      isScrollable: true,
                      tabs: <Widget>[
                        Tab(text: "HOME"),
                        Tab(text: "FAVOURITES"),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    DropdownButton(
                      style: Theme.of(context).textTheme.subhead,
                      value: dropDownValue,
                      onChanged: (int) {
                        setState(() {
                          dropDownValue = int;
                        });
                      },
                      items: <DropdownMenuItem>[
                        DropdownMenuItem(
                          value: 0,
                          child: Text(
                            "Top Rated",
                            //style: Theme.of(context).textTheme.subhead,
                          ),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text(
                            "Most Popular",
                            //style: Theme.of(context).textTheme.subhead,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 24.0,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        drawer: Drawer(
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: ListView(
              padding: EdgeInsets.zero, // Removes padding
              children: <Widget>[
                DrawerHeader(
                  child: Center(
                      child: Text(appName,
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(fontSize: 32.0))),
                  decoration:
                      BoxDecoration(color: Theme.of(context).accentColor),
                ),
                SwitchListTile(
                  title: Text(
                    "Dark Mode",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 16.0),
                  ),
                  value: _darkThemeEnabled,
                  onChanged: (bool value) {
                    print(value);
                    _darkThemeEnabled = value;
                  },
                ),
                /* ListTile(
                  title: Text(
                    "Appearance",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppearancePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "App Info",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 16.0),
                  ),
                  onTap: () {
                    Navigator.pop(
                        context); // closes the drawer after this item is pressed
                    _infoDialog();
                  },
                ), */
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            HomePage(dropDownValue),
            FavouritesPage(),
          ],
        ),
      ),
    );
  }

  // Alert Dialog
  void _infoDialog() {
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
                _launchURL("https://github.com/britannio/Anime-Browser");
              },
            ),
          ],
        );
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

  /* void _choiceAction(String choice) {
    if (choice == "Disable Dark Mode") {
      print("Dark Mode Disabled");
    }
  } */
}

/* class _LinkTextSpan extends TextSpan {

  // Beware!
  //
  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.

  _LinkTextSpan({ TextStyle style, String url, String text }) : super(
    style: style,
    text: text ?? url,
    recognizer: TapGestureRecognizer()..onTap = () {
      launch(url, forceSafariVC: false);
    }
  );
} */
