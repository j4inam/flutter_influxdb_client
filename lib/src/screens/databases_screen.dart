import 'package:flutter/material.dart';
import '../blocs/query_provider.dart';
import '../models/results_model.dart';

class DatabasesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final QueryBloc queryBloc = QueryProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Database'),
        backgroundColor: Colors.brown,
      ),
      body: SafeArea(
        child: buildDbList(queryBloc),
      ),
    );
  }

  Widget buildDbList(QueryBloc queryBloc) {
    print('Fetching building - bloc');

    return StreamBuilder(
      stream: queryBloc.queryResults,
      builder: (BuildContext context, AsyncSnapshot<ResultsModel> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              value: null,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.brown,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data.series[0].values.length,
          itemBuilder: (context, int index) {
            return Column(
              children: <Widget>[
                ListTile(
                  title: Text('${snapshot.data.series[0].values[index][0]}'),
                  onTap: () {
                    print('DB tapped ${snapshot.data.series[0].values[index][0]}');
                    Navigator.pop(
                        context, snapshot.data.series[0].values[index][0].toString());
                  },
                ),
                Divider()
              ],
            );
          },
        );
      },
    );
  }
}
