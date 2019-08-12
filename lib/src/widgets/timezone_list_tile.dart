import 'package:flutter/material.dart';
import '../models/timezone.dart';
import '../resources/utilities.dart';

class TimezoneListTile extends StatelessWidget {
  final Timezone timezone;

  TimezoneListTile({this.timezone});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('${timezone.zoneName}'),
          subtitle: Text('${timezone.countryName} (${utilities.convertSecondsToHoursAndMinutes(timezone.gmtOffset)})'),
          onTap: () {
            print('Time tapped ${timezone.zoneName}');
            Navigator.pop(context, timezone);
          },
        ),
        Divider(),
      ],
    );
  }
}
