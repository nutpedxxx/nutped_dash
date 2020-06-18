import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class MemberPage extends StatefulWidget {
  MemberPage({Key key}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  _buildList(DocumentSnapshot document) {
    // get and set locale for timeago
    String locale = 'en';
    // time ago
    DateTime messageDate =
        new DateTime.fromMicrosecondsSinceEpoch(int.parse(document['timeStamp']));
    var dateString = timeago.format(messageDate, locale: locale);
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(document['userAvatarImageUrl']),
          ),
          title: Text(document['userName']),
          subtitle: Text(document['userInfo']),
          trailing: Text(dateString),
        ),
        Divider(thickness: 0.5)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection("users").orderBy("timeStamp", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildList(snapshot.data.documents[index]);
            },
          );
        }
        return Container();
      },
    );
  }
}
