import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:media_app/pages/home.dart';
import 'package:media_app/signin/signin.dart';



import 'help.dart';

//lobalKey userauth = GlobalKey();
class signup extends StatefulWidget {
  var text;

  signup({Key key, @required this.text}) : super(key: key);

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  final userauth = GlobalKey<FormState>();

  bool issignup = false;
  var TokenUser;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _registerOnFirebase() {
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging
        .getToken()
        .then((token) => TokenUser= token.toString());


  }

  @override
  void initState() {
    super.initState();
    _registerOnFirebase();

  }



  signup() async {
    if (userauth.currentState.validate()) {
      setState(() {
        issignup = true;
      });

      debugPrint("TAG" +TokenUser.toString());

     /* Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => subs3(text: widget.text)));*/
      final uri = 'http://3.6.183.65/App/user_signup';
      var map = new Map<String, dynamic>();
      map['mobile'] = emailEditingController.text.toString();
      map['password'] = passwordEditingController.text.toString();
      map['token'] = TokenUser.toString();


      http.Response response = await http.post(
        uri,
        headers: {"Accept": "application/json"},
        body: map,
      );

      debugPrint("demo parsedJson "+response.body.toString());
      Map<String, dynamic> responseJson = json.decode(response.body);



      var message = responseJson['message'];
      var status = responseJson['status'];

      if(status=="success"){
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1
        );


        var amount="16";
        if(widget.text.toString() =="4"){
          amount="16";
        }else if(widget.text.toString() =="3"){
          amount="14";
        }else if(widget.text.toString() =="2"){
          amount="10";
        }else if(widget.text.toString() =="1"){
          amount="7";
        }

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(text: amount,id:responseJson["data"][0]["signup_id"].toString())));
      }else{
        setState(() {});
      }


    } else {
      print("something wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  "  OUR",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(
                width: 0,
              ),
              FlatButton(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => signin()));
                },
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => help()));
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      "HELP",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ))
            ],
          ),
        ),
        body: issignup
            ? Container(child: Center(child: Text("Loading")))
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "STEP 2 of 3",
                            style: TextStyle(color: Colors.grey[200]),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                              child: Text(
                                "Sign-up to start your free month.",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Just two more steps and you are done!",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(height: 80),
                      Form(
                          key: userauth,
                          child: Column(children: [
                            Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1.0, color: Colors.red[600]),
                                  ),
                                  child: TextFormField(
                                    validator: (val) {
                                      return RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(val)
                                          ? null
                                          : "Please Enter Correct Email";
                                    },
                                    controller: emailEditingController,
                                    decoration: InputDecoration(
                                        hintText: "Email or phone number",
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        fillColor: Colors.black,
                                        border: InputBorder.none,
                                        focusColor: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1.0, color: Colors.red[600]),
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (val) {
                                      return val.length > 6
                                          ? null
                                          : "Password must have 6 character";
                                    },
                                    controller: passwordEditingController,
                                    decoration: InputDecoration(
                                        hintText: " Set Password",
                                        border: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        fillColor: Colors.black,
                                        focusColor: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ])),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonTheme(
                          minWidth: 400.0,
                          height: 40.0,
                          child: RaisedButton(
                            child: Text('CONTINUE',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            color: Colors.red,
                            onPressed: () {
                              debugPrint("data");
                              if (userauth.currentState.validate()) {
                                signup();

                                /*      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => subs3()));*/
                              /*  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomePage()));*/
                              }
                            },
                          )),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ));
  }

}