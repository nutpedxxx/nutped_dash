import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    getAdsPushTotal();
    getPushTotal();
  }

  int memberTotal = null;
  int postTotal = null;
  int adsPushTotal = null;
  int pushTotal = null;
  double screenWidth = 0;

  getMemberTotal() {
    Stream<QuerySnapshot> snapshots = Firestore.instance.collection("users").snapshots();
    snapshots.listen((value) {
      setState(() {
        memberTotal = value.documents.length;
      });
    });
  }

  getPostTotal() {
    Stream<QuerySnapshot> snapshots = Firestore.instance.collection("posts").snapshots();
    snapshots.listen((value) {
      setState(() {
        postTotal = value.documents.length;
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

  getPushTotal() {
    Stream<QuerySnapshot> snapshots = Firestore.instance.collection("push").snapshots();
    snapshots.listen((value) {
      setState(() {
        pushTotal = value.documents.length;
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
                    : ((MediaQuery.of(context).size.width / 2) - 16),
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
    double screenWidth = MediaQuery.of(context).size.width;
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
                cardBox("Push", Icons.insert_chart, pushTotal)
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
