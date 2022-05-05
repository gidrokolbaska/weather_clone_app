part of weather_library;

/// Custom Exception for the plugin,
/// Thrown whenever the API responds with an error and body could not be parsed.
class OpenWeatherAPIException implements Exception {
  final String _cause;

  OpenWeatherAPIException(this._cause);

  @override
  String toString() => '$runtimeType - $_cause';
}
