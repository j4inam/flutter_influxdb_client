import 'package:flutter/material.dart';
import '../models/timezone.dart';
import '../resources/utilities.dart';
import '../widgets/timezone_list_tile.dart';

class TimezonesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Timezone'),
        backgroundColor: Colors.brown,
      ),
      body: buildTimezonesList(),
    );
  }

  buildTimezonesList() {
    return FutureBuilder(
      future: utilities.getTimezones(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Timezone>> itemSnapshot) {
        if (!itemSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              value: null,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 26, 179, 148),
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: itemSnapshot.data.length,
          itemBuilder: (context, int index) {
            return TimezoneListTile(timezone: itemSnapshot.data[index]);
          },
        );
      },
    );
  }
}
