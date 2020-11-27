import 'package:flutter/material.dart';
import 'DonationPageForm.dart';
import 'model/DonationItem.dart';

class Donation extends StatefulWidget {
  @override
  _DonationState createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  Color yellow = Colors.yellow;
  Color gray = Colors.grey;

  Future<List<DonationItem>> getDonationList() async {
    List<DonationItem> donationList = [];
    donationList.add(DonationItem("1", "15", "Help 10+ Other People", "-You have access to all seasons digitally", "-You will help fund future content for this app", "-You gift access to this important content to 10+ other people around the world to watch for free"));
    donationList.add(DonationItem("2", "50", "Help 30+ Other People", "-You have access to all seasons digitally", "-You will help fund future content for this app", "-You gift access to this important content to 30+ other people around the world to watch for free and you gift them at least 30 episodes"));
    donationList.add(DonationItem("3", "150", "Help 250+ Other People", "-You have access to all seasons digitally", "-You will help fund future content for this app", "-You gift access to this important content to 250+ other people around the world to watch for free and you gift them at least 250 episodes"));
    donationList.add(DonationItem("4", "5000", "Help 5500+ Other People", "-You have access to all seasons digitally", "-You will help fund future content for this app", "-You gift access to this important content to 5500+ other people around the world to watch for free and you gift them at least 5500 episodes"));
    return donationList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getDonationList(),
        builder: (BuildContext context, AsyncSnapshot<List<DonationItem>> snapshot){
          if(snapshot.data == null){
            return Container(
              child: Center(
                child: Text("Loading..."),
              ),
            );
          }else{
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  DonationItem donationItem = snapshot.data[index];
                  return Container(
                    margin: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
                    color: gray,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(donationItem.price, style: TextStyle(fontSize: 30, color: yellow, fontWeight: FontWeight.bold),),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Divider(color: yellow,)
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(donationItem.title, style: TextStyle(fontSize: 20, color: yellow),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(donationItem.subTitle1, style: TextStyle(fontSize: 16, color: yellow),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(donationItem.subTitle2, style: TextStyle(fontSize: 16, color: yellow),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(donationItem.subTitle3, style: TextStyle(fontSize: 16, color: yellow),),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        FlatButton(
                            color: yellow,
                            onPressed: () {


                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => DonationPageForm(text: donationItem.price.toString(),packYype: donationItem.title.toString(), )));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "Select",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                        ),
                      ],
                    ),
                  );
                });
          }
        },

      ),
    );
  }
}
