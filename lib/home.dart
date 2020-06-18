import 'package:flutter/material.dart';
import 'package:web/ads.dart';
import 'package:web/dashboard.dart';
import 'package:web/member.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<String> pageTitle = ["Dashboard", "Member", "Advertisment", "Push"];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width < 960) {
      return Scaffold(
        appBar: AppBar(
          title: Text(pageTitle[_currentIndex]),
          elevation: 1,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            DashboardPage(),
            MemberPage(),
            AdsPage(),
            Container(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), title: Text("Dashboard")),
            BottomNavigationBarItem(icon: Icon(Icons.people), title: Text("Member")),
            BottomNavigationBarItem(icon: Icon(Icons.live_tv), title: Text("Advertise")),
            BottomNavigationBarItem(icon: Icon(Icons.message), title: Text("Push"))
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(pageTitle[_currentIndex]),
          elevation: 1,
        ),
        body: Row(
          children: [
            NavigationRail(
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text("Dashboard")),
                NavigationRailDestination(icon: Icon(Icons.people), label: Text("Member")),
                NavigationRailDestination(icon: Icon(Icons.live_tv), label: Text("Advertise")),
                NavigationRailDestination(icon: Icon(Icons.message), label: Text("Push"))
              ],
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            VerticalDivider(width: 1.0, thickness: 2.0, indent: 1.0),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: <Widget>[
                  DashboardPage(),
                  MemberPage(),
                  AdsPage(),
                  Container(),
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}
