import 'package:dio/dio.dart';
import 'dart:async';
import '../models/user_settings.dart';
import '../models/results_model.dart';

class InfluxApiProvider {
  Dio _dio;
  Response _response;

  InfluxApiProvider() {
    _dio = Dio();
  }

  Future<bool> testConnection(UserSettings settings) async {
    _response = await _dio.get('//${settings.host}:${settings.port}/ping');
    print("Ping ${_response.statusCode}");

    return _response.statusCode == 204;
  }

  Future<ResultsModel> getDatabases(UserSettings settings) async {
    ResultsModel results;
    if (settings.host != null && settings.port != null) {
      print('Getting databases ${settings.host}:${settings.port}');
      try {
        _response = await _dio.get(
            'http://${settings.host}:${settings.port}/query?q=show+databases');
        print("Parsed Json ${_response.data['results'][0]['series'][0]}");
        results = ResultsModel.fromJson(
            {"series": _response.data['results'][0]['series']});
      } on DioError catch (err) {
        print('$err');
        if (err.response != null) {
          print(err.response.headers["x-influxdb-error"][0]);
          results = ResultsModel.fromJson(
              {"error": '${err.response.headers["x-influxdb-error"][0]}'});
        } else {
          results = ResultsModel.fromJson(
              {"error": 'Something went wrong. Try again!'});
        }
      }
    }
    print("Series ${results.toMap()}");
    return results;
  }

  Future<ResultsModel> executeQuery(UserSettings settings, String query) async {
    print(
        "Executing $query ${settings.host}:${settings.port}/${settings.dbName}");
    ResultsModel results;
    String formattedQuery = query.replaceAll(' ', '+');
    try {
      if (getVerb(query) == 'GET') {
        _response = await _dio.get(
            'http://${settings.host}:${settings.port}/query?q=$formattedQuery&db=${settings.dbName}');
      } else if (getVerb(query) == 'POST') {
        _response = await _dio.post(
            'http://${settings.host}:${settings.port}/query?q=$formattedQuery&db=${settings.dbName}',
            data: null);
      }
    } on DioError catch (err) {
      print('$err');
      if (err.response != null) {
        print(err.response.headers["x-influxdb-error"][0]);
        results = ResultsModel.fromJson(
            {"error": '${err.response.headers["x-influxdb-error"][0]}'});
      } else {
        results = ResultsModel.fromJson(
            {"error": 'Something went wrong. Try again!'});
      }
      return results;
    }

    print("Response ${_response.data}");
    results = ResultsModel.fromJson(
        {"series": _response.data['results'][0]['series']});
    print("Results ${results.toMap()}");

    return results;
  }

  String getVerb(String query) {
    String verb = '';

    if (query.toLowerCase().startsWith('select *')) {
      if (query.toLowerCase().contains('into')) {
        verb = 'POST';
      }
      verb = 'GET';
    } else if (query.toLowerCase().startsWith('show')) {
      verb = 'GET';
    } else {
      verb = 'POST';
    }
    print('Verb $verb');
    return verb;
  }
}
