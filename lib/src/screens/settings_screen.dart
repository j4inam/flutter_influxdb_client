import 'package:flutter/material.dart';
import '../blocs/query_provider.dart';
import '../models/user_settings.dart';
import '../resources/utilities.dart';
import '../models/timezone.dart';
import '../screens/timezones_screen.dart';
import '../screens/databases_screen.dart';

class SettingsScreen extends StatelessWidget {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final QueryBloc queryBloc = QueryProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.brown,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'scaffold_fab',
        label: Text('Test Connection'),
        icon: Icon(Icons.link),
        onPressed: () {
          print('Test Connection Pressed!');
          queryBloc.testConnection();
        },
        backgroundColor: Colors.brown,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: buildSettingsList(queryBloc),
      ),
    );
  }

  Widget buildSettingsList(QueryBloc queryBloc) {
    return StreamBuilder(
      stream: queryBloc.userSettings,
      builder: (BuildContext context, AsyncSnapshot<UserSettings> snapshot) {
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

        return ListView(
          children: <Widget>[
            ListTile(
              title: Text('Database Host'),
              subtitle: Text('${snapshot.data.host}'),
              trailing: Icon(Icons.edit),
              onTap: () {
                showEditHostDialog(context, queryBloc);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Port'),
              subtitle: Text('${snapshot.data.port}'),
              trailing: Icon(Icons.edit),
              onTap: () {
                showEditPortDialog(context, queryBloc);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Timezone'),
              subtitle: Text(
                  '${snapshot.data.timezone.zoneName} (${utilities.convertSecondsToHoursAndMinutes(snapshot.data.timezone.gmtOffset)})'),
              trailing: Icon(Icons.edit),
              onTap: () {
                showTimezoneSelectionDialog(context, queryBloc);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Database Name'),
              subtitle:
                  snapshot.data.dbName == null || snapshot.data.dbName == ""
                      ? Text(
                          "No Database Selected",
                          style: TextStyle(
                            color: Colors.brown,
                          ),
                        )
                      : Text('${snapshot.data.dbName}'),
              trailing: Icon(Icons.edit),
              onTap: () {
                showDatabaseSelectionDialog(context, queryBloc);
              },
            ),
            Divider(),
          ],
        );
      },
    );
  }

  showEditHostDialog(BuildContext context, QueryBloc queryBloc) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set InfluxDB Host'),
          content: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _textFieldController,
            decoration: InputDecoration(
              labelText: "Enter Host",
              hintText: "127.0.0.1",
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
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );

    String host = _textFieldController.value.text;
    if (host != null && host != "") {
      print('Set Host $host');
      queryBloc.updateHost(host);
    }
  }

  showEditPortDialog(BuildContext context, QueryBloc queryBloc) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set InfluxDB Port'),
          content: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _textFieldController,
            decoration: InputDecoration(
              labelText: "Enter Port",
              hintText: "8086",
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
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );

    int port = int.parse(_textFieldController.value.text);
    if (port != null && port > 0) {
      print('Set port $port');
      queryBloc.updatePort(port);
    }
  }

  showTimezoneSelectionDialog(
      BuildContext context, QueryBloc queryBloc) async {
    Timezone timezone = await Navigator.of(context).push(
      new MaterialPageRoute<Timezone>(
        builder: (BuildContext context) {
          return TimezonesScreen();
        },
        fullscreenDialog: true,
      ),
    );

    if (timezone != null) {
      print("Timezone $timezone");
      queryBloc.updateTimezone(timezone);
    }
  }

  showDatabaseSelectionDialog(
      BuildContext context, QueryBloc queryBloc) async {
    queryBloc.fetchDatabases();
    String dbName = await Navigator.of(context).push(
      new MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return DatabasesScreen();
        },
        fullscreenDialog: true,
      ),
    );

    if (dbName != null) {
      print("Database Selected $dbName");
      queryBloc.updateDbName(dbName);
    }
    queryBloc.resetQueryLoader();
  }
}
