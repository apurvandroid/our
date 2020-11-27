import 'package:media_app/books/pdfview.dart';
import 'package:media_app/model/ChapterListModel.dart';

import '../main.dart';
import 'package:flutter/material.dart';
class episodes extends StatefulWidget {
  List<Pdf> text;

  episodes({Key key, @required this.text}) : super(key: key);

  @override
  _episodesState createState() => _episodesState();
}

class _episodesState extends State<episodes> {


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
                        MaterialPageRoute(builder: (context) => pdfview(title: widget.text[indx].title,pdf: widget.text[indx].pdf), ));
                  },
                  child:  Card(color: Colors.white,
                    child: Container(height: 150,
                      child:Row(
                        children: [
                          Container(width: 100,padding: EdgeInsets.fromLTRB(20, 20, 0, 0),alignment:Alignment.center,
                              child: Image.network("http://3.6.183.65/thumbnail/"+widget.text[indx].thumb,fit: BoxFit.fill)),
                          Column(
                            children: [
                              Container(padding: EdgeInsets.fromLTRB(20, 20, 0, 0),alignment: Alignment.center,
                                child:Text(widget.text[indx].title,style: TextStyle(fontSize: 20)),),
                              Container(height: 100,width: 200,alignment: Alignment.center,
                                child: Text(widget.text[indx].dis,style: TextStyle(color: Colors.green),maxLines: 100,
                                ),)
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
