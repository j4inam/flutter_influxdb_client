import 'package:rxdart/rxdart.dart';
import '../models/user_settings.dart';
import '../models/results_model.dart';
import '../resources/query_repository.dart';
import '../models/timezone.dart';
import 'validators.dart';

class QueryBloc with Validators {
  final _userSettings = BehaviorSubject<UserSettings>();
  final _queryController = BehaviorSubject<String>();
  final _results = BehaviorSubject<ResultsModel>();
  final _repository = QueryRepository();
  final _connectionController = PublishSubject<bool>();

  // Getters to Streams
  Observable<UserSettings> get userSettings => _userSettings.stream;
  UserSettings get userSettingsValue => _userSettings.value;
  Observable<String> get query =>
      _queryController.stream.transform(validateQuery);
  Observable<ResultsModel> get queryResults => _results.stream;
  Observable<bool> get isConnected => _connectionController.stream;

  // Add to stream
  Function(String) get changeQuery => _queryController.sink.add;

  fetchUserSettings() async {
    final UserSettings settings = await _repository.fetchUserSettings();
    _userSettings.sink.add(settings);
  }

  updateHost(String host) async {
    await _repository.updateHost(host);
    fetchUserSettings();
  }

  updatePort(int port) async {
    await _repository.updatePort(port);
    fetchUserSettings();
  }

  updateDbName(String dbName) async {
    await _repository.updateDbName(dbName);
    fetchUserSettings();
  }

  updateTimezone(Timezone timezone) async {
    await _repository.updateTimezone(timezone);
    fetchUserSettings();
  }

  testConnection() async {
    final UserSettings settings = _userSettings.value;
    final bool isConnected = await _repository.testConnection(settings);
    _connectionController.sink.add(isConnected);
  }

  fetchDatabases() async {
    print('Fetching dbases - bloc');
    final UserSettings settings = _userSettings.value;
    final ResultsModel results = await _repository.fetDatabases(settings);
    _results.sink.add(results);
  }

  Map<String, dynamic> examineQuery() {
    final String query = _queryController.value;
    print('Validating $query');
    if (query == null || query == '') {
      _queryController.sink.addError('Query is required!');
      return {"status": "ERR"};
    }

    if (query.toLowerCase().contains('delete') ||
        query.toLowerCase().contains('drop') ||
        query.toLowerCase().contains('alter') ||
        query.toLowerCase().contains('revoke') ||
        query.toLowerCase().contains('kill')) {
      return {"status": "WARN"};
    }

    return {"status": "OK"};
  }

  executeQuery() async {
    final UserSettings settings = _userSettings.value;
    final String query = _queryController.value;
    _results.sink.add(
        ResultsModel.fromJson(Map<String, dynamic>.from({"isLoading": true})));
    final ResultsModel queryResults =
        await _repository.executeQuery(settings, query);
    _results.sink.add(queryResults);
  }

  resetQueryLoader() {
    if (_results.value != null) {
      _results.sink.add(null);
    }
  }

  dispose() {
    _connectionController.close();
    _queryController.close();
    _results.close();
    _userSettings.close();
  }
}
