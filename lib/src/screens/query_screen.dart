import 'package:flutter/material.dart';
import '../blocs/query_provider.dart';
import '../models/results_model.dart';
import '../widgets/single_series_list_tile.dart';
import '../widgets/multiple_series_list_tile.dart';

class QueryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final QueryBloc queryBloc = QueryProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Query InfluxDB'),
        backgroundColor: Colors.brown,
        actions: <Widget>[
          buildHistoryActionButton(context, queryBloc),
          buildSettingsActionButton(context, queryBloc),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'scaffold_fab',
        child: Icon(Icons.send),
        onPressed: () {
          print('Execute Query Pressed!');
          submitQuery(context, queryBloc);
        },
        backgroundColor: Colors.brown,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            buildQueryInputField(queryBloc),
            buildResultsList(queryBloc),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsActionButton(
      BuildContext context, QueryBloc queryBloc) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        queryBloc.resetQueryLoader();
        Navigator.pushNamed(context, '/settings');
      },
    );
  }

  Widget buildHistoryActionButton(
      BuildContext context, QueryBloc queryBloc) {
    return IconButton(
      icon: Icon(Icons.history),
      onPressed: () {
        queryBloc.resetQueryLoader();
        Navigator.pushNamed(context, '/history');
      },
    );
  }

  Widget buildQueryInputField(QueryBloc queryBloc) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: StreamBuilder(
        stream: queryBloc.query,
        builder: (context, snapshot) {
          return TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'SELECT * from MEASUREMENT',
              labelText: 'Query',
              errorText: snapshot.error,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.brown,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
              ),
            ),
            onChanged: queryBloc.changeQuery,
          );
        },
      ),
    );
  }

  Widget buildResultsList(QueryBloc queryBloc) {
    return Expanded(
      child: StreamBuilder(
        stream: queryBloc.queryResults,
        builder: (BuildContext context, AsyncSnapshot<ResultsModel> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  value: null,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.brown,
                  ),
                ),
              );
            }

            if (snapshot.data.error != null && snapshot.data.error != '') {
              return ListTile(
                isThreeLine: true,
                title: Text(
                  'Error!',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.warning),
                subtitle: Text('${snapshot.data.error}'),
              );
            }

            if (snapshot.data.series.length == 1) {
              return ListView.builder(
                itemCount: snapshot.data.series[0].values.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleSeriesListTile(
                    columns: snapshot.data.series[0].columns,
                    values: snapshot.data.series[0].values[index],
                  );
                },
              );
            }

            return ListView.builder(
              itemCount: snapshot.data.series.length,
              itemBuilder: (BuildContext context, int index) {
                return MultipleSeriesListTile(
                  series: snapshot.data.series[index],
                );
              },
            );
          }
          return Text('');
        },
      ),
    );
  }

  submitQuery(BuildContext context, QueryBloc queryBloc) async {
    final validationResponse = queryBloc.examineQuery();
    print('$validationResponse');

    if (validationResponse['status'] == 'WARN') {
      final bool actionConfirmed = await showWarningDialog(context);
      print('Execute query $actionConfirmed');
      if (actionConfirmed) {
        queryBloc.executeQuery();
      }
    } else if (validationResponse['status'] == 'OK') {
      queryBloc.executeQuery();
    }
  }

  Future<bool> showWarningDialog(BuildContext context) async {
    final bool actionConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm perform action ?",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: Text(
              "You're about to execute a destructive query. This can not be undone."),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.brown,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            RaisedButton(
              color: Colors.brown,
              child: Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    print('Action confirmed $actionConfirmed');
    return actionConfirmed;
  }
}
