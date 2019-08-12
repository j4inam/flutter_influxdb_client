import 'package:flutter/material.dart';
import '../resources/utilities.dart';
import '../blocs/query_provider.dart';

class SingleSeriesListTile extends StatelessWidget {
  final List<dynamic> columns;
  final List<dynamic> values;

  SingleSeriesListTile({this.columns, this.values});

  @override
  Widget build(BuildContext context) {
    final QueryBloc queryBloc = QueryProvider.of(context);
  
    if (columns.length == 1) {
      return Column(
        children: <Widget>[
          ListTile(
            title: Text('${values[0]}'),
          ),
          Divider(),
        ],
      );
    }

    List<Widget> children = values
        .asMap()
        .map(
          (i, value) => MapEntry(
            i,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${columns[i]}',
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

    return Card(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
