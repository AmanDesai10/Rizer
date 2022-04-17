import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StudentAnalyticsView extends StatefulWidget {
  const StudentAnalyticsView(
      {Key? key, required this.rizerAnalytics, required this.quizName})
      : super(key: key);
  final Map<String, dynamic> rizerAnalytics;
  final String quizName;
  @override
  _StudentAnalyticsViewState createState() => _StudentAnalyticsViewState();
}

class _StudentAnalyticsViewState extends State<StudentAnalyticsView> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left_outlined,
              color: Colors.black,
              size: 28.0,
            ),
          ),
          title: Text(
            widget.quizName,
            style: theme.textTheme.headline6,
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(bottom: 32.0),
            child: SfCircularChart(
              palette: [
                Color.fromRGBO(255, 99, 132, 0.1),
                Color.fromRGBO(54, 162, 235, 0.1),
                Color.fromRGBO(255, 206, 86, 1),
                Color.fromRGBO(75, 192, 192, 1),
                Color.fromRGBO(153, 102, 255, 1)
              ],
              title:
                  ChartTitle(textStyle: TextStyle(fontWeight: FontWeight.bold)),
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              series: _getDefaultPieSeries(widget.rizerAnalytics),
            ),
          ),
        ),
      ),
    );
  }

  List<PieSeries<FeedbackQueAndResponse, String>> _getDefaultPieSeries(
      Map<String, dynamic> analytic) {
    List<FeedbackQueAndResponse> pieData = [];

    analytic.forEach((key, value) {
      pieData.add(FeedbackQueAndResponse(
          option: key, shortOption: '', response: value));
    });

    // <FeedbackQueAndResponse>[
    //   FeedbackQueAndResponse(
    //       option: 'Completely Agree',
    //       response: analytic.keys,
    //       shortOption: 'C. Agree'),
    //   FeedbackQueAndResponse(
    //     option: 'Agree',
    //     shortOption: 'Agree',
    //     response: analytic['2'],
    //   ),
    //   FeedbackQueAndResponse(
    //     option: 'Neutral',
    //     shortOption: 'Neutral',
    //     response: analytic['3'],
    //   ),
    //   FeedbackQueAndResponse(
    //     option: 'Disagree',
    //     shortOption: 'Disagree',
    //     response: analytic['4'],
    //   ),
    //   FeedbackQueAndResponse(
    //     option: 'Completely Disagree',
    //     shortOption: 'C. Disagree',
    //     response: analytic['5'],
    //   ),
    // ];
    return <PieSeries<FeedbackQueAndResponse, String>>[
      PieSeries<FeedbackQueAndResponse, String>(
          explode: false,
          explodeIndex: 0,
          explodeOffset: '10%',
          dataSource: pieData,
          xValueMapper: (FeedbackQueAndResponse data, _) =>
              data.option as String,
          yValueMapper: (FeedbackQueAndResponse data, _) => data.response,
          dataLabelMapper: (FeedbackQueAndResponse data, _) =>
              '${data.shortOption} ${data.response.toString()}',
          startAngle: 90,
          endAngle: 90,
          radius: '100%',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            showZeroValue: false,
          )),
    ];
  }
}

class FeedbackQueAndResponse {
  final String? option;
  final int? response;
  final String? shortOption;

  const FeedbackQueAndResponse(
      {required this.option,
      required this.shortOption,
      required this.response});
}
