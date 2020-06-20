import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class UserData {
  final String type;
  final int value;

  UserData(this.type, this.value);
}

class ChartBox extends StatelessWidget {
  final List<UserData> chartData;
  final IconData iconData;
  final String title;

  ChartBox(this.title, this.iconData, this.chartData, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<charts.Series<UserData, String>> seriesList = [
      new charts.Series<UserData, String>(
        id: 'Stats',
        domainFn: (UserData user, _) => user.type,
        measureFn: (UserData user, _) => user.value,
        data: chartData,
        labelAccessorFn: (UserData user, _) => '${user.type}: ${user.value}',
      )
    ];

    return Card(
      child: Container(
        width: (screenWidth > 1280)
            ? ((MediaQuery.of(context).size.width / 4) - (35))
            : (screenWidth > 960)
                ? ((MediaQuery.of(context).size.width / 2) - (65))
                : (screenWidth >= 768)
                    ? ((MediaQuery.of(context).size.width / 2) - 16)
                    : ((MediaQuery.of(context).size.width) - 16),
        height: (screenWidth > 1280)
            ? ((MediaQuery.of(context).size.width / 4) - (35) + 40)
            : (screenWidth > 960)
                ? ((MediaQuery.of(context).size.width / 2) - (65) + 40)
                : (screenWidth >= 768)
                    ? ((MediaQuery.of(context).size.width / 2) - 16 + 40)
                    : ((MediaQuery.of(context).size.width) - 16 + 40),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[Icon(iconData), SizedBox(width: 8.0), Text(title)]),
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: (screenWidth > 1280)
                  ? ((MediaQuery.of(context).size.width / 4) - (35))
                  : (screenWidth > 960)
                      ? ((MediaQuery.of(context).size.width / 2) - (65))
                      : (screenWidth >= 768)
                          ? ((MediaQuery.of(context).size.width / 2) - 16)
                          : ((MediaQuery.of(context).size.width) - 16),
              height: (screenWidth > 1280)
                  ? ((MediaQuery.of(context).size.width / 4) - (35))
                  : (screenWidth > 960)
                      ? ((MediaQuery.of(context).size.width / 2) - (65))
                      : (screenWidth >= 768)
                          ? ((MediaQuery.of(context).size.width / 2) - 16)
                          : ((MediaQuery.of(context).size.width) - 16),
              child: charts.PieChart(
                seriesList,
                animate: true,
                defaultRenderer: new charts.ArcRendererConfig(),
                behaviors: [
                  new charts.DatumLegend(
                    position: charts.BehaviorPosition.end,
                    cellPadding: new EdgeInsets.all(1),
                    legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                    showMeasures: true,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
