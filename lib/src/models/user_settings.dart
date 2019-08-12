import 'timezone.dart';

class UserSettings {
  int id;
  String host;
  int port;
  String dbName;
  Timezone timezone;

  UserSettings.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        host = parsedJson['host'] ?? "localhost",
        port = parsedJson['port'] ?? 8086,
        dbName = parsedJson['dbName'] ?? "_internal",
        timezone = Timezone.fromJson(
            Map<String, dynamic>.from(parsedJson['timezone']));

  UserSettings.fromDb(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        host = parsedJson['host'] ?? 'localhost',
        port = parsedJson['port'] ?? 8086,
        dbName = parsedJson['dbName'] ?? "_internal",
        timezone = Timezone.fromJson(
          Map<String, dynamic>.from({
            "countryName": parsedJson['tz_countryName'],
            "zoneName": parsedJson['tz_zoneName'],
            "gmtOffset": parsedJson['tz_gmtOffset'],
          }),
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "host": host,
      "port": port,
      "dbName": dbName,
      "timezone": timezone.toMap()
    };
  }
}
