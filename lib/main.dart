import 'package:flutter/material.dart';
import 'home.dart';
import 'favourites.dart';

/* 
TODO
 - Use slivers to create the collapsing toolbar effect for the description page
 - Make the hyperlink in the information dialog work 
 - Add shared element transitions to the anime image 
 - In the description page, after the description show a horizontal row of similar anime based on the category of the anime being viewed
 - Think about a dynamic homepage with more compact cards
 - Put the info dialog and theme change switch in a navigation drawer
 = Implement the favourites page feature

 DONE
 - Improve InkWell card press
 - Added a navigation drawer
 - Added tabs to the main page
 - Added a favourites page

 */

void main() => runApp(new MyApp());

const String appName = "Anime Catalog";

final ThemeData _darkTheme = ThemeData(
  backgroundColor: Color(0xFF141414),
  cardColor: Color(0xFF212121),
  accentColor: Colors.blue,
  primaryColor: Color(0xFF212121),
  textTheme: TextTheme(
      title: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
      subhead: TextStyle(color: Color(0xFF9E9E9E)),
      body1: TextStyle(color: Colors.white)),
);

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  bool _darkThemeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appName,
      theme: _darkThemeEnabled ? _darkTheme : ThemeData.light(),
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
                      icon: Icon(Icons.sort),
                      onPressed: () {
                        final snackBar = SnackBar(
                          content: Text("Feature unavailable"),
                          action: SnackBarAction(
                            label: "OKAY",
                            onPressed: () {},
                          ),
                        );

                        // Find the Scaffold in the Widget tree and use it to show a SnackBar
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        print("Snackbar pressed");
                      },
                    ),
                  ],
                ),
                TabBar(
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(text: "HOME"),
                    Tab(text: "FAVOURITES"),
                  ],
                ),
              ],
            ),
          ),
        ),
        drawer: Drawer(
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Center(
                      child: Text(appName,
                          style: Theme.of(context).textTheme.title)),
                  decoration:
                      BoxDecoration(color: Theme.of(context).accentColor),
                ),
                ListTile(
                  title: Text("Info", style: Theme.of(context).textTheme.title,),
                  onTap: () {
                    _infoDialog();
                    Navigator.pop(
                        context); // closes the drawer after this item is pressed
                  },
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            HomePage(),
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
          title: Text(appName),
          content: RichText(
            text: TextSpan(
                text:
                    "This is a flutter equivalent of an app previously made with native android code. It used a network request to fetch the following json file then outputted a styled equivalent.\nsrc:",
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "http://androiddemos.britannio.com/anime.json",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline),
                    //recognizer: TapGestureRecognizer()..onTap = (){}
                  )
                ]),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("DISMISS"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /* void _choiceAction(String choice) {
    if (choice == "Disable Dark Mode") {
      print("Dark Mode Disabled");
    }
  } */
}
