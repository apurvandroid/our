import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import 'package:media_app/main2.dart';
import 'package:media_app/model/VideoModel.dart';


import 'package:media_app/signin/signin.dart';
import 'package:media_app/videos/player.dart';
import 'package:media_app/videos/suggestion.dart';
import 'package:media_app/videos/trailers.dart';
import '../donation.dart';
import 'books_videos.dart';

import 'package:http/http.dart' as http;


class books_cat_ extends StatefulWidget {
  var text;


  books_cat_({Key key, @required this.text}) : super(key: key);

  @override
  _books_cat_State createState() => _books_cat_State();
}

bool _allow = true;

class _books_cat_State extends State<books_cat_> {
  var videoAbout = "", about = "", thumb = "", videoUrl = "",type = "";

  List<Pdf> pdfList = List<Pdf>();
  Future<List<Pdf>> updateCart() async {
    final String url = 'http://3.6.183.65/App/book_data';


    var map = new Map<String, dynamic>();
    map['book_id'] = widget.text.toString();


    http.Response response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: map,
    );


    var notesJson = json.decode(response.body)["data"]["pdf"].toString();
    debugPrint("notesJson"+notesJson);
    //var notesJson = json.decode(response.body)["data"]["pdf"].toString();

    videoAbout =
        json.decode(response.body)["data"]["video"][0]["title"].toString();
    about = json.decode(response.body)["data"]["video"][0]["dis"].toString();
    thumb = json.decode(response.body)["data"]["video"][0]["thumb"].toString();
    videoUrl = json.decode(response.body)["data"]["video"][0]["video"].toString();
    type = json.decode(response.body)["data"]["video"][0]["type"].toString();

    debugPrint("demo  $type");
    var notes = List<Pdf>();


    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body)["data"]["pdf"];
      for (var noteJson in notesJson) {
        notes.add(Pdf.fromJson(noteJson));
      }
      return notes;

    }
  }

  @override
  void initState() {
    updateCart().then((value) {
      setState(() {});
      pdfList.addAll(value);

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   debugPrint("book"+pdfList.length.toString());
    return WillPopScope(
        onWillPop: () {
          return Future.value(_allow); // if true allow back else block it
        },
        child: Scaffold(extendBodyBehindAppBar: true,backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.transparent,
            elevation: 30.0,
          ),
          body: DefaultTabController(
            length: 4,
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(automaticallyImplyLeading: false,
                    forceElevated: innerBoxIsScrolled,
                    expandedHeight: 300.0,
                    floating: true,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                        title: Container(alignment:Alignment.center, padding: EdgeInsets.fromLTRB(0, 60, 30, 0),
                            child: FlatButton(onPressed: (){
                              if(type.toString() == "1"){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => player(
                                          text:
                                          videoUrl.toString(),
                                        )));
                              }else{
                                debugPrint("demo 2" +type);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => player(
                                          text:
                                          "http://3.6.183.65/uploads/"+videoUrl.toString(),
                                        )));
                              }

                            },
                                child:Container(
                                    child: Icon(Icons.play_arrow,size: 50,)))),
                        background: Image.network("http://3.6.183.65/thumbnail/$thumb", fit: BoxFit.cover,filterQuality: FilterQuality.high),

                        ),bottom: PreferredSize(
                        preferredSize: Size.fromHeight(170), child: Container(alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child:
                        Column(children: [Row(
                          children: [
                            Container( width: MediaQuery
                            .of(context)
                            .size
                            .width,padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                                child: Text(videoAbout,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),)),
                          ],
                        ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("2h 30m",style: TextStyle(color: Colors.yellowAccent),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Genre: Religious",style: TextStyle(color: Colors.green),),
                              )
                            ],
                          ),
                          Container(color: Colors.black,height: 140,padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child:Column(children:[
                                Row(
                                  children: [
                                    Expanded(
                                    child:
                                      Text("ABOUT :-",style: TextStyle(color: Colors.white,fontSize: 10),textAlign: TextAlign.left),
                                    )
                                  ],
                                ),
                                Expanded(
                                  //isme data a rha
                                  child: SingleChildScrollView(
                                    child: Text(about,style: TextStyle(color: Colors.white60,fontSize: 12),),
                                  ),
                                ),
                              ])
                          )],))),
                  ),
                  Container(
                    child: SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(indicatorColor: Colors.white,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.white,
                            tabs: [
                              Tab(text: "Episodes"),
                              Tab(text: "Trailers & more"),
                              Tab(text:"Suggestions",),
                              Tab(text:"Donate",)

                            ]),
                      ),
                      pinned: false,
                    ),
                  ),
                ];
              },
              //)
              //];
              //},
              body:
              TabBarView(children: [
                books_videos(text:  pdfList,),
                trailers(),
                suggestion(),
                Donation()
              ],
              ),
            ),
          ),)
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(color: Color(0xff1c2a35),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}