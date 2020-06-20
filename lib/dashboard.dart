import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web/chart_widget.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    // get stats
    getMemberTotal();
    getPostTotal();
    getAdsTotal();
    getAdsPushTotal();
    getPushTotal();
  }

  int memberTotal = null;
  int postTotal = null;
  int adsPushTotal = null;
  int adsTotal = null;
  int pushTotal = null;
  double screenWidth = 0;

  List<UserData> chartMember = [];
  List<UserData> chartPost = [];
  List<UserData> chartPush = [];
  List<UserData> chartAds = [];

  getMemberTotal() {
    Stream<QuerySnapshot> snapshots = Firestore.instance.collection("users").snapshots();
    snapshots.listen((snapshot) {
      int typeMember = 0;
      int typeSponsor = 0;
      int typeAdmin = 0;
      setState(() {
        memberTotal = snapshot.documents.length;

        snapshot.documents.forEach((doc) {
          if ((doc['userType'] == 0) || (doc['userType'] == null)) {
            typeMember = typeMember + 1;
          }
          if (doc['userType'] == 1) {
            typeSponsor = typeSponsor + 1;
          }

          if (doc['userType'] == 2) {
            typeAdmin = typeAdmin + 1;
          }
        });
        chartMember = [];
        chartMember.add(new UserData("Member", typeMember));
        chartMember.add(new UserData("Advertisor", typeSponsor));
        chartMember.add(new UserData("Admin", typeAdmin));
      });
    });
  }

  getPostTotal() {
    Stream<QuerySnapshot> snapshots = Firestore.instance.collection("posts").snapshots();
    snapshots.listen((snapshot) {
      int typeText = 0;
      int typeImage = 0;

      setState(() {
        postTotal = snapshot.documents.length;

        snapshot.documents.forEach((doc) {
          if ((doc['postType'] == "t")) {
            typeText = typeText + 1;
          }
          if (doc['postType'] == "i") {
            typeImage = typeImage + 1;
          }
        });
        chartPost = [];
        chartPost.add(new UserData("Text", typeText));
        chartPost.add(new UserData("Image", typeImage));
      });
    });
  }

  getAdsPushTotal() {
    Stream<QuerySnapshot> snapshots = Firestore.instance.collection("ads_push").snapshots();
    snapshots.listen((value) {
      setState(() {
        adsPushTotal = value.documents.length;
      });
    });
  }

  getAdsTotal() {
    Stream<QuerySnapshot> snapshots = Firestore.instance.collection("ads").snapshots();
    Stream<QuerySnapshot> snapshots2 = Firestore.instance.collection("ads_push").snapshots();
    snapshots.listen((value) {
      setState(() {
        adsTotal = value.documents.length;
        if (chartAds.length > 1) {
          chartAds.removeAt(0);
        }
        chartAds.add(new UserData("Ads", adsTotal));
      });
    });

    snapshots2.listen((value) {
      setState(() {
        adsPushTotal = value.documents.length;
        if (chartAds.length > 1) {
          chartAds.removeAt(1);
        }
        chartAds.add(new UserData("Ads Push", adsPushTotal));
      });
    });
  }

  getPushTotal() {
    Stream<QuerySnapshot> snapshots = Firestore.instance.collection("ads_push").snapshots();
    Stream<QuerySnapshot> snapshots2 = Firestore.instance.collection("push").snapshots();

    snapshots.listen((value) {
      setState(() {
        adsTotal = value.documents.length;
        if (chartPush.length > 1) {
          chartPush.removeAt(0);
        }
        chartPush.add(new UserData("Ads Push", adsTotal));
      });
    });

    snapshots2.listen((value) {
      setState(() {
        pushTotal = value.documents.length;
        if (chartPush.length > 1) {
          chartPush.removeAt(1);
        }
        chartPush.add(new UserData("Push", pushTotal));
      });
    });
  }

  Widget cardBox(String title, IconData iconData, int value) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        width: (screenWidth > 1280)
            ? ((MediaQuery.of(context).size.width / 4) - (35))
            : (screenWidth > 960)
                ? ((MediaQuery.of(context).size.width / 2) - (65))
                : (screenWidth >= 768)
                    ? ((MediaQuery.of(context).size.width / 2) - 16)
                    : ((MediaQuery.of(context).size.width) - 16),
        height: 132,
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          Row(children: <Widget>[Icon(iconData), SizedBox(width: 8.0), Text(title)]),
          SizedBox(height: 16.0),
          (value != null)
              ? Text(
                  value.toString(),
                  style: TextStyle(fontSize: 36),
                )
              : CircularProgressIndicator(
                  strokeWidth: 6,
                ),
          SizedBox(height: 16.0),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime timeNow = new DateTime.now();
    String last30Minutes =
        timeNow.subtract(Duration(minutes: 30)).microsecondsSinceEpoch.toString();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          direction: Axis.vertical,
          children: [
            Wrap(
              children: [
                cardBox("Member", Icons.insert_chart, memberTotal),
                cardBox("Post", Icons.insert_chart, postTotal),
                cardBox("Ads", Icons.insert_chart, adsPushTotal),
                cardBox("Push", Icons.insert_chart, pushTotal),
                ChartBox("Member", Icons.insert_chart, chartMember),
                ChartBox("Post", Icons.insert_chart, chartPost),
                ChartBox("Ads & Ads Push", Icons.insert_chart, chartAds),
                ChartBox("Ads Push & Push", Icons.insert_chart, chartPush)
              ],
            ),
            Wrap(children: [
              StreamBuilder(
                stream: Firestore.instance
                    .collection("users")
                    .where("timeStamp", isGreaterThanOrEqualTo: last30Minutes)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Flex(direction: Axis.vertical, children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                            child: Row(children: <Widget>[
                              Icon(Icons.people),
                              SizedBox(width: 8.0),
                              Text("Users in last 30 minutes")
                            ]),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      snapshot.data.documents[index]['userAvatarImageUrl']),
                                ),
                                title: Text(snapshot.data.documents[index]['userName']),
                              );
                            },
                          ),
                        ]),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
