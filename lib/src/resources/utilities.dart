import 'package:dio/dio.dart';
import 'package:influx_io_bloc/src/models/user_settings.dart';
import 'dart:async';
import '../models/timezone.dart';

class Utilities {
  Dio _dio;
  Response _response;

  Utilities() {
    _dio = Dio();
  }

  String convertSecondsToHoursAndMinutes(int seconds) {
    String convertedString = seconds > 0 ? "UTC +" : "UTC ";
    final Duration duration = Duration(seconds: seconds);
    final int hours = duration.inHours;
    final int minutes =
        Duration(seconds: seconds - (hours * 3600)).inMinutes.abs();
    convertedString += hours == 0 && minutes == 0 ? " +" : "";
    return convertedString +=
        minutes < 10 ? '$hours:0$minutes' : '$hours:$minutes';
  }

  Future<List<Timezone>> getTimezones() async {
    print('Getting timezones');
    final List<Timezone> timezones = [];
    _response = await _dio.get(
        'http://api.timezonedb.com/v2.1/list-time-zone?key=Z7JJBD15FL9U&format=json');
    print(_response.data);
    for (var timezone in _response.data['zones']) {
      timezones.add(Timezone.fromJson(timezone));
    }

    timezones.sort((a, b) => a.gmtOffset.compareTo(b.gmtOffset));
    return timezones;
  }

  formatTime(String timeString, UserSettings settings) {
    if (settings == null) {
      return timeString;
    }
    try {
      DateTime time = DateTime.parse(timeString);
      time = time.add(Duration(seconds: settings.timezone.gmtOffset));
      return '${time.day}/${time.month}/${time.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
    } catch (err) {
      return timeString;
    }
  }
}

final Utilities utilities = Utilities();
