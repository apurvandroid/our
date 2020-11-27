
import 'dart:io';

import "package:flutter/material.dart";
import 'package:media_app/signin/Homescreen.dart';


import "dart:async";

import 'package:media_app/signin/signup.dart';
import 'package:media_app/signin/subscription.dart';

import 'main2.dart';
import 'package:http/http.dart' as http;


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Our());
}

class Our extends StatefulWidget {
  @override
  _OurState createState() => _OurState();
}

class _OurState extends State<Our> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Our",
      //home:Homescreen(),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  //  updateCart();
    Timer(
      Duration(seconds:7),
          () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>firstscreen(),
            ));
    /*   Navigator.push(
       context,
       MaterialPageRoute(
       builder: (context) =>HomeScreen(),
       ));*/
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body:
        Stack(children: <Widget>[
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  fit: BoxFit.none,
                  image: AssetImage(
                    'assets/ezgif.com-gif-maker (1).gif',
                  ),
                ),
              ),
              height: 500,
            ),
          ),
        ]),
    );
  }


  updateCart() async {
    final String url = 'http://3.6.183.65/App/home_data';
    final client = new http.Client();
    final response = await client.put(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},

    );

    Timer(
      Duration(seconds:7),
          () {
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>HomeScreen(text: response.body.toString()),
            ));
      },
    );
  }
}
