import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import 'package:media_app/main2.dart';
import 'package:media_app/model/ChapterListModel.dart';

import 'package:media_app/signin/signin.dart';
import 'package:media_app/videos/player.dart';
import 'episodes.dart';
import 'package:http/http.dart' as http;


class chapter_details_page extends StatefulWidget {
  var text;


  chapter_details_page({Key key, @required this.text}) : super(key: key);

  @override
  _chapter_details_pageState createState() => _chapter_details_pageState();
}

bool _allow = true;

class _chapter_details_pageState extends State<chapter_details_page> {
  var videoAbout = "", about = "", thumb = "", videoUrl = "",type="";

  List<Pdf> pdfList = List<Pdf>();
  Future<List<Pdf>> updateCart() async {
    final String url = 'http://3.6.183.65/App/chapter_data';

    var map = new Map<String, dynamic>();
    map['chapter_id'] = widget.text;


    http.Response response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: map,
    );
    var resposnse = json.decode(response.body).toString();

    debugPrint("demo"+resposnse);
    videoAbout =
        json.decode(response.body)["data"]["video"][0]["title"].toString();
    about = json.decode(response.body)["data"]["video"][0]["dis"].toString();
    thumb = json.decode(response.body)["data"]["video"][0]["thumb"].toString();
    videoUrl = json.decode(response.body)["data"]["video"][0]["video"].toString();
    type = json.decode(response.body)["data"]["video"][0]["type"].toString();
    //   pdfList=json.decode(response.body)["data"]["pdf"];
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
    debugPrint("demo "+widget.text);
    return WillPopScope(
      onWillPop: () {
        return Future.value(_allow); // if true allow back else block it
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 30.0,
        ),
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(

            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[

                SliverAppBar(

                  automaticallyImplyLeading: false,
                  forceElevated: innerBoxIsScrolled,
                  expandedHeight: 300.0,
                  floating: true,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Container(
                        alignment: Alignment.center,
                        child: FlatButton(
                            onPressed: () {
                           if(type.toString() == "1"){
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => player(
                                       text:
                                       videoUrl.toString(),
                                     )));
                           }else{
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => player(
                                       text:
                                       "http://3.6.183.65/uploads/"+videoUrl.toString(),
                                     )));
                           }
                            },
                            child: Container(
                               // alignment: Alignment.center,
                                child: Icon(
                              Icons.play_arrow,
                              size: 50,
                            ))

                        )),
                    background: Image.network(
                      "http://3.6.183.65/thumbnail/$thumb",
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  bottom: PreferredSize(
                      preferredSize: Size.fromHeight(170),
                      child: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 0, 10),
                                      child: Text(
                                        videoAbout,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "2h 30m",
                                      style:
                                          TextStyle(color: Colors.yellowAccent),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Genre: Religious",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                  color: Colors.black,
                                  height: 140,
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
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
                                  ]))
                            ],
                          ))),
                ),
              ];
            },
            body: episodes(text: pdfList),
          ),
        ),
      ),
    );
  }
}
