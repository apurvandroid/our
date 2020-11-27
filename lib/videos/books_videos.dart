import 'dart:convert';

import 'package:media_app/books/pdfview.dart';
import 'package:media_app/model/VideoModel.dart';

import '../main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'chapter_details_page.dart';
class books_videos extends StatefulWidget {
  List<Pdf> text;

  books_videos({Key key, @required this.text}) : super(key: key);

  @override
  _books_videosState createState() => _books_videosState();


}

class _books_videosState extends State<books_videos> {

  List<Pdf> pdfList = [];
  Future<List<Pdf>>  updateCart() async {
     final String url = 'http://3.6.183.65/App/book_data';

     var map = new Map<String, dynamic>();
     map['book_id'] = widget.text;

     final client = new http.Client();
     final response = await client.put(
       url,
       body: map,
       headers: {"Accept": "application/json"},
     );
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

    return  Center(child:ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.text.length,
        itemBuilder: (BuildContext context, int indx){
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                  onPressed: (){
                    /////you can link card to the player from this button
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) =>
                        chapter_details_page(
                            text: widget.text[indx].chapterId.toString())));



                    },
                  child:  Card(color: Colors.white,
                    child: Container(height: 150,
                      child:Row(
                        children: [
                          Container(width: 100,padding: EdgeInsets.fromLTRB(20, 20, 0, 0),alignment:Alignment.center,
                              child: Image.network("http://3.6.183.65/chapter/"+widget.text[indx].image,fit: BoxFit.fill)),
                          Column(
                            children: [
                              Container(padding: EdgeInsets.fromLTRB(20, 20, 0, 0),alignment: Alignment.center,
                                child:Text(widget.text[indx].name,style: TextStyle(fontSize: 20)),),
                    /*          Container(height: 100,width: 200,alignment: Alignment.center,
                                child: Text(widget.text[indx].,style: TextStyle(color: Colors.green),maxLines: 100,
                                ),)*/
                            ],
                          ),

                        ],
                      ),

                    ),
                  )
              ),

            ],
          );
        }
    ));
  }
}
