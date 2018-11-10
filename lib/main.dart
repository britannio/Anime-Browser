import 'package:flutter/material.dart';
import 'home.dart';
import 'favourites.dart';
import 'package:url_launcher/url_launcher.dart';
import 'appearance.dart';
import 'info_dialog.dart';
import 'description.dart';

/* 
TODO
 - Implement the dark theme toggle
 - Implement the favourites page feature
 - Add all data to the description page
 - Add shared element transitions to the anime image for the description page
 - Establish themes
 - Add a scroll bar
 - Use a cached image network widget to create a shimmer effect for the loading images
 - Create an individual json file for each anime item

CONSIDER for v2+
 - Use SQL or firebase to store item information
 - Think about a dynamic homepage with more compact cards
 - In the description page, after the description show a horizontal row of similar anime based on the category of the anime being viewed
 - Add an app icon
 - Adding search
 - Add accent color changing


 */

void main() => runApp(new MyApp());

const String _appName = "Anime Browser";

final ThemeData _baseDarkTheme = ThemeData(primaryColor: Color(0xFF212121));
final ThemeData _baseLightTheme = ThemeData(primaryColor: Colors.white);

final ThemeData _darkTheme = ThemeData(
  canvasColor: _baseDarkTheme.primaryColor,
  backgroundColor: Color(0xFF141414),
  cardColor: _baseDarkTheme.primaryColor,
  accentColor: Colors.blue,
  primaryColor: _baseDarkTheme.primaryColor,
  //primaryColorLight: Color(0xFF484848),
  primaryColorLight: Color(0xFF141414),
  primaryColorDark: Color(0xFF090909),
  textTheme: TextTheme(
    title: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    subhead: TextStyle(color: Color(0xFF9E9E9E)),
    headline: TextStyle(color: Color(0xFF9E9E9E)),
    body1: TextStyle(color: Color(0xFF9E9E9E), fontSize: 16.0),
  ),
  accentTextTheme: TextTheme(
    title: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
  ),
  dialogBackgroundColor: _baseDarkTheme.primaryColor,
  dividerColor: Color(0xFF9E9E9E),
);

final ThemeData _lightTheme = ThemeData(
  //brightness: Brightness.light,
  canvasColor: _baseLightTheme.primaryColor,
  backgroundColor: Colors.white,
  cardColor: _baseLightTheme.primaryColor,
  accentColor: Colors.blue,
  primaryColor: _baseLightTheme.primaryColor,
  //primaryColorLight: Color(0xFF484848),
  primaryColorLight: Colors.blue,
  primaryColorDark: Colors.white,
  textTheme: TextTheme(
    title: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    subhead: TextStyle(color: Color(0xFF9E9E9E)),
    headline: TextStyle(color: Color(0xFF9E9E9E)),
    body1: TextStyle(color: Color(0xFF9E9E9E), fontSize: 16.0),
  ),
  accentTextTheme: TextTheme(
      title: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  )),
  dialogBackgroundColor: _baseLightTheme.primaryColor,
  dividerColor: Colors.white,
);

class MyApp extends StatelessWidget {
  static String appName = _appName;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: _appName,
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

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin<MainPage> {
  bool _darkThemeEnabled = true;
  int dropDownValue = 0;

  //@overrride
  bool get wantKeepAlive => true;

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
            //backgroundColor: Theme.of(context).accentColor,
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppBar(
                  //backgroundColor: Theme.of(context).accentColor,
                  elevation: 0.0,
                  title: new Text(_appName),
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
                        infoDialog(context, appName: _appName);
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
                        if (int != dropDownValue) {
                          setState(() {
                            dropDownValue = int;
                          });
                        }
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
                      width: 16.0,
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
                      child: Text(_appName,
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(fontSize: 32.0, color: Colors.white))),
                  decoration:
                      BoxDecoration(color: Theme.of(context).accentColor),
                ),
                ListTile(
                  title: Text("Made by Britannio",
                      style: Theme.of(context).textTheme.title),
                  trailing: IconButton(
                    icon: Icon(Icons.open_in_new, color: Colors.white,),
                    onPressed: () {
                      Navigator.pop(
                        context);
                      _launchURL("https://github.com/britannio/Anime-Browser");
                    },
                  ),
                ),
                /* SwitchListTile(
                  title: Text(
                    "Dark Mode",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .cop
                        yWith(fontSize: 16.0),
                  ),
                  value: _darkThemeEnabled,
                  onChanged: (bool value) {
                    print(value);
                    _darkThemeEnabled = value;
                  },
                ), */
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
