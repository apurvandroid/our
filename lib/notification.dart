import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/NotificationModel.dart';
class notification extends StatefulWidget {
  @override
  _notificationState createState() => _notificationState();
}

class _notificationState extends State<notification> {


  List<DataNotification> _notes = List<DataNotification>();

  var image;

  Future<List<DataNotification>> updateCart() async {
    final String url = 'http://3.6.183.65/App/notification';
    final client = new http.Client();
    final response = await client.put(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    //trendingProducts = json.decode(response.body)['data'];

    var notes = List<DataNotification>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body)["data"];
      for (var noteJson in notesJson) {
        notes.add(DataNotification.fromJson(noteJson));
      }
      return notes;
    }
  }

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
    return Scaffold(backgroundColor: Colors.black,
      appBar: AppBar(
        leading: BackButton(
            color: Colors.black),
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("NOTIFICATION",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          Icon(Icons.notifications_active,color: Colors.black,)
        ],
      ),
        backgroundColor: Colors.grey,
      ),
      body:
          Container(padding: EdgeInsets.only(top: 20),
            child: Container(
              child: ListView.builder(
              itemCount: _notes.length,
                itemBuilder: (context, index) {

                  return Container(
                    margin: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(_notes[index].title.toString()),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(_notes[index].createdOn.toString(), textAlign: TextAlign.right,)
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(_notes[index].dis.toString())
                      ],
                    ),
                  );
                  /* return ListTile(
                    title: Container(color: Colors.white,height: 60,padding: EdgeInsets.all(8),alignment: Alignment.centerLeft,
                        child: Text(_notes[index].title.toString(),style: TextStyle(color: Colors.black),)
                    ),
                  );*/
                },
              ),
            ),
          ),
    );
  }
}
