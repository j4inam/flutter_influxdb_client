import 'package:flutter/material.dart';
import 'screens/settings_screen.dart';
import 'screens/query_screen.dart';
import 'screens/history_screen.dart';
import 'blocs/query_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QueryProvider(
      child: MaterialApp(
        title: 'InfluxDB I/O',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primaryColor: Colors.brown,
          brightness: Brightness.light,
        ),
        onGenerateRoute: routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/history') {
      return MaterialPageRoute(builder: (context) {
        return HistoryScreen();
      });
    }

    if (settings.name == '/settings') {
      return MaterialPageRoute(builder: (context) {
        final QueryBloc queryBloc = QueryProvider.of(context);
        queryBloc.fetchUserSettings();

        return SettingsScreen();
      });
    }

    if (settings.name == '/') {
      return MaterialPageRoute(builder: (context) {
        final QueryBloc queryBloc = QueryProvider.of(context);
        queryBloc.fetchUserSettings();

        return QueryScreen();
      });
    }

    return null;
  }
}
