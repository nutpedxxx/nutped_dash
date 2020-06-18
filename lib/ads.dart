import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdsPage extends StatefulWidget {
  AdsPage({Key key}) : super(key: key);

  @override
  _AdsPageState createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  _buildList(DocumentSnapshot document) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        width: (screenWidth > 1280)
            ? ((MediaQuery.of(context).size.width / 4) - (35))
            : ((MediaQuery.of(context).size.width / 2) - 16),
        height: (screenWidth > 1280)
            ? ((MediaQuery.of(context).size.width / 4) - (35))
            : ((MediaQuery.of(context).size.width / 2) - 16),
        child: Column(children: <Widget>[
          Image.network(
            document['postImage'],
            fit: BoxFit.cover,
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream:
            Firestore.instance.collection("ads").orderBy("timeStamp", descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (screenWidth > 1024) ? 6 : (screenWidth > 640) ? 4 : 2),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildList(snapshot.data.documents[index]);
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
