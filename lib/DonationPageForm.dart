import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:media_app/pages/home.dart';
import 'package:media_app/services/payment-service.dart';
import 'package:media_app/videos/chapter_details_page.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'main2.dart';

class DonationPageForm extends StatefulWidget {
  var text;
  var packYype;

  DonationPageForm({Key key, @required this.text,@required this.packYype}) : super(key: key);

  @override
  _DonationPageFormState createState() => _DonationPageFormState();
}

class _DonationPageFormState extends State<DonationPageForm> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController edFirstNAme = new TextEditingController();
  TextEditingController edLastName = new TextEditingController();
  final userauth = GlobalKey<FormState>();

  bool isDonationPageForm = false;

  @override
  void initState() {
    super.initState();
    StripeService.init();
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
                  "  Donation Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(
                width: 0,
              ),
            ],
          ),
        ),
        body: isDonationPageForm
            ? Container(child: Center(child: Text("Loading")))
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "DONATE TODAY",
                            style: TextStyle(
                                fontSize: 30, color: Colors.grey[200]),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                              child: Text(
                                "Personal Info",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))
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
                                    controller: edFirstNAme,
                                    decoration: InputDecoration(
                                        hintText: "First Name",
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
                                    controller: edLastName,
                                    decoration: InputDecoration(
                                        hintText: " Last Name",
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
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(width: 1.0, color: Colors.red[600]),
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
                              hintStyle: TextStyle(color: Colors.black),
                              fillColor: Colors.black,
                              border: InputBorder.none,
                              focusColor: Colors.white),
                        ),
                      ),
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
                              int amountFinal;
                              int chargeKm = int.tryParse(widget.text);
                              amountFinal = chargeKm * 100;
                              payViaNewCard(context, amountFinal.toString());

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

  payViaNewCard(BuildContext context, String amt) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        amount: amt.toString(), currency: 'USD');

    await dialog.hide();
    /*  Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => subs3()));*/
    var value = response.id.toString();
    var type;
    debugPrint("TAG "+response.message);
    if (response.message == "Transaction successful") {

      final uri = 'http://3.6.183.65/App/donate';
      var map = new Map<String, dynamic>();
      map['fname'] = edFirstNAme.text.toString();
      map['trans_id'] = value;
      map['amount'] = amt.toString();
      map["package_name"] = widget.packYype.toString();
      map["lname"] = edLastName.text.toString();
      map["email"] = emailEditingController.text.toString();


      http.Response response1 = await http.post(
        uri,
        headers: {"Accept": "application/json"},
        body: map,
      );

      Map<String, dynamic> responseJson = json.decode(response1.body);

      var message = responseJson['message'];
      var status = responseJson['status'];

      debugPrint("TAG"+status);

      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1
      );

      if(status == "success"){
        /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => chapter_details_page()));*/
      }
    }

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }
}
