class ResultsModel {
  final bool isLoading;
  final String error;
  final List<SeriesModel> series;

  ResultsModel.fromJson(Map<String, dynamic> parsedJson)
      : isLoading = parsedJson['isLoading'] ?? false,
        error = parsedJson['error'] ?? '',
        series = parsedJson['series'] == null
            ? []
            : (parsedJson['series'] as List).map((i) => SeriesModel.fromJson(i)).toList();

  Map<String, dynamic> toMap() {
    return {"isLoading": isLoading, "error": error, "series": series};
  }
}

class SeriesModel {
  final String name;
  final List<dynamic> columns;
  final List<dynamic> values;

  SeriesModel.fromJson(Map<String, dynamic> parsedJson)
      : name = parsedJson['name'],
        columns = parsedJson['columns'] ?? [],
        values = parsedJson['values'] == null
            ? []
            : List<dynamic>.from(parsedJson['values']);
}
