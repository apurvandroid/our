import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:media_app/services/payment-service.dart';
import 'package:media_app/signin/subs3.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  var text, id;


//  HomePage({Key key}) : super(key: key);

  HomePage({Key key, @required this.text, this.id}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int amountFinal;

  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        payViaNewCard(context);
        int chargeKm = int.tryParse(widget.text);
         amountFinal=chargeKm * 100;
        break;
      case 1:
        Navigator.pushNamed(context, '/existing-cards');
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response =
    await StripeService.payWithNewCard(amount: amountFinal.toString(), currency: 'USD');

    await dialog.hide();
    /*  Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => subs3()));*/
    var value = response.id.toString();
    var type;
    if (response.message == "Transaction successful") {

      if(widget.text.toString() == "1"){
        type="MOBILE";
      }else if(widget.text.toString() == "2"){
        type="BASICS";
      }else if(widget.text.toString() == "3"){
        type="STANDARD";
      }else{
        type="PREMIUM";
      }

      final uri = 'http://3.6.183.65/App/payment';
      var map = new Map<String, dynamic>();
      map['signup_id'] = widget.id.toString();
      map['trans_id'] =value;
      map['amount'] = amountFinal.toString();
      map["package_name"]=type;

      http.Response response1 = await http.post(
        uri,
        headers: {"Accept": "application/json"},
        body: map,
      );

/*      Map<String, dynamic> responseJson = json.decode(response1.body);
      debugPrint("TAG" +json.decode(responseJson.toString()));

      var parsedJson = json.decode(response1.body);
      debugPrint("TAG" +parsedJson);*/

      /*
      debugPrint("TAG" +widget.id.toString());*/
      /*  var parsedJson = json.decode(response1.body);
      debugPrint("TAG" +parsedJson);
      debugPrint("TAG" +json.decode(response1.body));*/


        Map<String, dynamic> responseJson = json.decode(response1.body);

      if(responseJson["status"] == "success"){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => subs3()));
      }
      }

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
      new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Icon icon;
              Text text;

              switch (index) {
                case 0:
                  icon = Icon(Icons.add_circle, color: theme.primaryColor);
                  text = Text('Pay via new card');
                  break;
                case 1:
                  icon = Icon(Icons.credit_card, color: theme.primaryColor);
                  text = Text('Pay via existing card');
                  break;
              }

              return InkWell(
                onTap: () {
                  onItemPress(context, index);
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );
            },
            separatorBuilder: (context, index) =>
                Divider(
                  color: theme.primaryColor,
                ),
            itemCount: 2),
      ),
    );
    ;
  }
}
