import 'package:influx_io_bloc/src/models/user_settings.dart';
import 'package:influx_io_bloc/src/models/timezone.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';

class AppDbProvider {
  Database db;
  final _defaultSettings = {
    "id": 1,
    "host": "localhost",
    "port": 8086,
    "dbName": "_internal",
    "tz_countryName": "Burkina Faso",
    "tz_zoneName": "Africa\/Ouagadougou",
    "tz_gmtOffset": 0
  };

  AppDbProvider() {
    init();
  }

  Future<void> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "userdata.db");

    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute("""
          CREATE TABLE settings
          (
          id INTEGER PRIMARY KEY UNIQUE,
          host TEXT,
          port INTEGER,
          dbName TEXT,
          tz_countryName TEXT,
          tz_zoneName TEXT,
          tz_gmtOffset INTEGER
          )
        """);

      newDb.insert("settings", _defaultSettings);

      newDb.execute("""
          CREATE TABLE history
          (
          id INTEGER PRIMARY KEY UNIQUE AUTO_INCREMENT,
          host TEXT,
          port INTEGER,
          dbName TEXT,
          tz_countryName TEXT,
          tz_zoneName TEXT,
          tz_gmtOffset INTEGER
          )
        """);
    });
  }

  Future<UserSettings> fetchUserSettings() async {
    print('Fetching user settings');
    if (db != null) {
      print('Inside DB call');
      final maps = await db.query("settings", columns: null);

      if (maps.length > 0) {
        return UserSettings.fromDb(maps.first);
      }
      return UserSettings.fromDb(_defaultSettings);
    }
    return null;
  }

  Future<int> updateHost(String host) {
    return db.update("settings", {"host": host}, where: 'id = 1');
  }

  Future<int> updatePort(int port) {
    return db.update("settings", {"port": port}, where: 'id = 1');
  }

  Future<int> updateDbName(String dbName) {
    return db.update("settings", {"dbName": dbName}, where: 'id = 1');
  }

  Future<int> updateTimezone(Timezone timezone) {
    print('Updating timezone $timezone');
    final timezoneMap = Map<String, dynamic>.from({
      "tz_countryName": timezone.countryName,
      "tz_zoneName": timezone.zoneName,
      "tz_gmtOffset": timezone.gmtOffset
    });
    return db.update("settings", timezoneMap, where: 'id = 1');
  }

  Future<int> clearSettings() {
    return db.delete('settings');
  }
}

final AppDbProvider appDbProvider = AppDbProvider();
