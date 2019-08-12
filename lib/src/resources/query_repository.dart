import 'app_db_provider.dart';
import 'influx_api_provider.dart';
import '../models/user_settings.dart';
import '../models/results_model.dart';
import '../models/timezone.dart';
import 'dart:async';

class QueryRepository {
  InfluxApiProvider influxApiProvider = InfluxApiProvider();

  Future<bool> testConnection(UserSettings settings) {
    return influxApiProvider.testConnection(settings);
  }

  Future<ResultsModel> fetDatabases(UserSettings settings) {
    return influxApiProvider.getDatabases(settings);
  }

  Future<ResultsModel> executeQuery(UserSettings settings, String query) {
    return influxApiProvider.executeQuery(settings, query);
  }

  Future<UserSettings> fetchUserSettings() {
    return appDbProvider.fetchUserSettings();
  }

  Future<int> updateHost(String host) {
    return appDbProvider.updateHost(host);
  }

  Future<int> updatePort(int port) {
    return appDbProvider.updatePort(port);
  }

  Future<int> updateDbName(String dbName) {
    return appDbProvider.updateDbName(dbName);
  }

  Future<int> updateTimezone(Timezone timezone) {
    return appDbProvider.updateTimezone(timezone);
  }

  Future<int> clearSettings() {
    return appDbProvider.clearSettings();
  }
}
