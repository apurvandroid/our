import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:media_app/books/travelsam.dart';
import 'package:media_app/download.dart';
import 'package:media_app/more.dart';
import 'package:media_app/profile.dart';
import 'package:media_app/quotes.dart';
import 'package:media_app/search/search_page.dart';
import 'package:media_app/videos/books_cat_.dart';
import 'package:media_app/videos/chapter_details_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/HomeData.dart';

class Person {
  final String name;

  Person(
    this.name,
  );
}

class HomeScreen extends StatefulWidget {
  var text;

  HomeScreen({Key key, @required this.text}) : super(key: key);

  @override
  _HomeScreenPage createState() => _HomeScreenPage();
}

class _HomeScreenPage extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  String title = "";
  String _message = '';
  FlutterLocalNotificationsPlugin fltrNotification;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _registerOnFirebase() {
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging
        .getToken()
        .then((token) => debugPrint("TAG " + token.toString()));

    getMessage();
  }

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 6, vsync: this);
    _registerOnFirebase();

  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('received message');
          debugPrint("TAG"+message.toString());
          setState(() => _message = message["notification"]["body"]);
        }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["body"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["body"]);
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
            onWillPop: () {
              return showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        "Confirm Exit",
                      ),
                      content: Text(
                        "Are you sure you want to exit?",
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("YES"),
                          onPressed: () {
                            //  offline();
                            exit(0);
                          },
                        ),
                        FlatButton(
                          child: Text("NO"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            },
            child: new Scaffold(
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Opacity(
                  opacity: 1,
                  child: AppBar(
                    flexibleSpace: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
                          height: 100,
                          width: 40,
                          child: Image(
                            image:
                                AssetImage("assets/our-redx-transparent.png"),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                            child: FlatButton(
                              child: Text(
                                "Home",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                            child: FlatButton(
                              child: Text(
                                "Travel Samaritan",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => travel()));
                              },
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                            child: FlatButton(
                              child: Text(
                                "Shop",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                /*    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => grid()));*/
                              },
                            ))
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  FirstTab(),
                  searchPage(),
                  quotes(),
                  ProfilePage(),
                  download(),
                  more()
                ],
// if you want yo disable swiping in tab the use below code
//            physics: NeverScrollableScrollPhysics(),
                controller: tabController,
              ),
              bottomNavigationBar: SizedBox(
                height: 60,
                child: TabBar(
                  onTap: (index) {
                    if (index == 0) {
                      setState(() {
                        title = "Home";
                      });
                    } else if (index == 1) {
                      setState(() {
                        title = "Page";
                      });
                    } else if (index == 2) {
                      setState(() {
                        title = "Page";
                      });
                    } else if (index == 3) {
                      setState(() {
                        title = "profile";
                      });
                    } else if (index == 4) {
                      setState(() {
                        title = "page";
                      });
                    } else if (index == 5) {
                      setState(() {
                        title = "Page";
                      });
                    }
                  },
                  indicatorColor: Colors.transparent,
                  unselectedLabelColor: Colors.white60,
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(
                        Icons.home,
                        size: 18,
                      ),
                      child: Text(
                        "Home",
                        style: TextStyle(fontSize: 9),
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.search,
                        size: 18,
                      ),
                      child: Text(
                        "Search",
                        style: TextStyle(fontSize: 9),
                        maxLines: 1,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.image,
                        size: 18,
                      ),
                      child: Text(
                        "Quotes",
                        style: TextStyle(fontSize: 9),
                        maxLines: 1,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.perm_identity,
                        size: 18,
                      ),
                      child: Text(
                        "Profile",
                        style: TextStyle(fontSize: 9),
                        maxLines: 1,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.cloud_download,
                        size: 18,
                      ),
                      child: Text(
                        "Download",
                        style: TextStyle(fontSize: 9),
                        maxLines: 1,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.menu,
                        size: 18,
                      ),
                      child: Text(
                        "More",
                        style: TextStyle(fontSize: 9),
                        maxLines: 1,
                      ),
                    ),
                  ],
                  controller: tabController,
                ),
              ),
            )));
  }
}

class FirstTab extends StatefulWidget {
  final String link = "http://www.africau.edu/images/default/sample.pdf";

  @override
  FirstTabState createState() => FirstTabState();
}

class FirstTabState extends State<FirstTab> {
  String imagePath;

  urllauncher(String link) async {
    var url = link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'ORI',
        text: 'ORI ORI',
        linkUrl: '',
        chooserTitle: 'Share video');
  }

  List<Data> _notes = List<Data>();

  var image;

  Future<List<Data>> updateCart() async {
    final String url = 'http://3.6.183.65/App/home_data';
    final client = new http.Client();
    final response = await client.put(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    //trendingProducts = json.decode(response.body)['data'];

    var notes = List<Data>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body)["data"];
      for (var noteJson in notesJson) {
        notes.add(Data.fromJson(noteJson));
      }
      return notes;
    }
  }

  List b = [
    "assets/25 lamentations.png",
    "assets/26 ezekiel.png",
    "assets/28 hosea.png",
    "assets/29 joel.png",
    "assets/30 obadiah.png",
    "assets/32 micah.png",
    "assets/28 hosea.png",
  ];

  @override
  void initState() {
    updateCart().then((value) {
      setState(() {
        _notes.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //fetchNotes();
    return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/IMG-20201024-WA0010.jpg"),
                            fit: BoxFit.cover)),
                    child: Container(
                        padding: EdgeInsets.fromLTRB(80, 30, 0, 0),
                        child: Text(""))),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    urllauncher(widget.link);
                  },
                  child: Icon(
                    Icons.cloud_download,
                    color: Colors.white70,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 0,
                ),
                FlatButton(
                  onPressed: () {
                    /*  Navigator.push(context,
                        MaterialPageRoute(builder: (context) => player()));*/
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                          size: 30,
                        ),
                        Text(
                          "  Play ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )
                      ],
                    ),
                    height: 35,
                    width: 80,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                FlatButton(
                    onPressed: share,
                    child: Icon(
                      Icons.share,
                      color: Colors.white70,
                      size: 26,
                    ))
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 15),
                    child: Text(
                      "Travel Samaritan",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    )),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: MediaQuery.of(context).size.height * 0.18,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: b.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle),
                          child: FlatButton(
                            onPressed: () {
                              /*            Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => travel()));*/

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => books_cat_()));
                            },
                            color: Colors.transparent,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(b[index]),
                              radius: 48,
                              backgroundColor: Colors.grey,
                            ),
                          ));
                    }),
              ),
            ),
            Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: _notes.length,
                    itemBuilder: (BuildContext context, int indx) {
                      List<Chapter> _chp = List<Chapter>();
                      _chp = _notes[indx].chapter;
                      return Column(children: [
                        Container(
                            width: 320,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => books_cat_(
                                              text: _notes[indx]
                                                  .book_id
                                                  .toString(),
                                            )));
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.network(
                                      "http://3.6.183.65/books/" +
                                          _notes[indx].bookImage.toString(),
                                      fit: BoxFit.fitWidth),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 200,
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _chp.length,
                                          itemBuilder:
                                              (BuildContext context, int data) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 140,
                                                  height: 170,
                                                  child: Card(
                                                    child: FlatButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        chapter_details_page(
                                                                          text: _chp[data]
                                                                              .chapterId
                                                                              .toString(),
                                                                        )));

                                                        debugPrint("id" +
                                                            _chp[data]
                                                                .chapterId
                                                                .toString());

                                                        /* debugPrint("id"+_chp[data].chapterId.toString());*/
                                                      },
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Image.network(
                                                                  "http://3.6.183.65/chapter/" +
                                                                      _chp[data]
                                                                          .image,
                                                                  fit: BoxFit
                                                                      .fitHeight),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ]);
                    })),
          ],
        ));
  }
}
