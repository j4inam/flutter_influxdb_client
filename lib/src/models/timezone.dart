class Timezone {
  final String countryName;
  final String zoneName;
  final int gmtOffset;

  Timezone.fromJson(Map<String, dynamic> parsedJson)
      : countryName = parsedJson['countryName'],
        zoneName = parsedJson['zoneName'],
        gmtOffset = parsedJson['gmtOffset'];

  Map<String, dynamic> toMap() {
    return {
      "countryName": countryName,
      "zoneName": zoneName,
      "gmtOffset": gmtOffset
    };
  }
}
