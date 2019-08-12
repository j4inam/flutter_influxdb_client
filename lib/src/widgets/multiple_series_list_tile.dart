import 'package:flutter/material.dart';
import '../models/results_model.dart';
import '../resources/utilities.dart';
import '../blocs/query_provider.dart';

class MultipleSeriesListTile extends StatelessWidget {
  final SeriesModel series;

  MultipleSeriesListTile({this.series});

  @override
  Widget build(BuildContext context) {
    final QueryBloc queryBloc = QueryProvider.of(context);

    List<Widget> children = [
      Text(
        '${series.name}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      ),
    ];

    for (var valuesList in series.values) {
      children.add(buildValuesList(valuesList, queryBloc));
    }

    return Card(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget buildValuesList(List<dynamic> valuesList, QueryBloc queryBloc) {
    List<Widget> rowList = valuesList
        .asMap()
        .map(
          (i, value) => MapEntry(
            i,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${series.columns[i]}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${utilities.formatTime(value.toString(), queryBloc.userSettingsValue)}')
              ],
            ),
          ),
        )
        .values
        .toList();

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        children: rowList,
      ),
    );
  }
}
