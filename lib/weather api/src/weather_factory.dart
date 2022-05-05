// ignore_for_file: constant_identifier_names

part of weather_library;

/// Plugin for fetching weather data in JSON.
class WeatherFactory {
  final HomeController homeController = Get.find();
  final String _apiKey;
  late Language language;
  static const String FIVE_DAY_FORECAST = 'forecast';
  static const String CURRENT_WEATHER = 'weather';
  static const String ONE_CALL_FORECAST = 'onecall';
  static const int STATUS_OK = 200;

  late http.Client _httpClient;

  WeatherFactory(this._apiKey, {this.language = Language.ENGLISH}) {
    _httpClient = http.Client();
  }

  /// Fetch current weather based on geographical coordinates
  /// Result is JSON.
  /// For API documentation, see: https://openweathermap.org/current
  Future<Weather?> currentWeatherByLocation(double latitude, double longitude,
      ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
      String? weatherJson = homeController.prefs.value!
          .getString(homeController.jsonWeatherKey.value);
      if (weatherJson == null) {
        return null;
      }
      Map<String, dynamic> map = jsonDecode(weatherJson);

      return Weather(map);
    } else {
      Map<String, dynamic>? jsonResponse = await _sendRequest(CURRENT_WEATHER,
          lat: latitude, lon: longitude, showHourly: false, showDaily: false);

      String weatherJson = jsonEncode(jsonResponse);
      await homeController.prefs.value!
          .setString(homeController.jsonWeatherKey.value, weatherJson);
      return Weather(jsonResponse!);
    }
  }

  /// Fetch current weather based on city name
  /// Result is JSON.
  /// For API documentation, see: https://openweathermap.org/current
  Future<Weather> currentWeatherByCityName(String cityName) async {
    Map<String, dynamic>? jsonResponse = await _sendRequest(CURRENT_WEATHER,
        cityName: cityName, showHourly: false, showDaily: false);
    return Weather(jsonResponse!);
  }

  /// Fetch current weather based on geographical coordinates.
  /// Result is JSON.
  /// For API documentation, see: https://openweathermap.org/forecast5
  Future<List<Weather>> fiveDayForecastByLocation(
      double latitude, double longitude) async {
    Map<String, dynamic>? jsonResponse = await _sendRequest(FIVE_DAY_FORECAST,
        lat: latitude, lon: longitude, showHourly: false, showDaily: false);
    List<Weather> forecast = _parseForecast(jsonResponse!);
    return forecast;
  }

  /// Fetch current weather based on geographical coordinates.
  /// Result is JSON.
  /// For API documentation, see: https://openweathermap.org/forecast5
  Future<List<Weather>> fiveDayForecastByCityName(String cityName) async {
    Map<String, dynamic>? jsonForecast = await _sendRequest(FIVE_DAY_FORECAST,
        cityName: cityName, showHourly: false, showDaily: false);
    List<Weather> forecasts = _parseForecast(jsonForecast!);
    return forecasts;
  }

  Future<List<Weather>?> hourlyForecastByLocation(double latitude,
      double longitude, ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
      String? weatherHourlyJson = homeController.prefs.value!
          .getString(homeController.jsonHourlyForecastKey.value);
      if (weatherHourlyJson == null) {
        return null;
      }
      Map<String, dynamic> map = await jsonDecode(
        weatherHourlyJson,
      );

      List<Weather> forecast = _parseHourlyForecast(map);

      return forecast;
    } else {
      Map<String, dynamic>? jsonResponse = await _sendRequest(ONE_CALL_FORECAST,
          lat: latitude, lon: longitude, showHourly: true, showDaily: false);

      String weatherHourlyJson = jsonEncode(jsonResponse);
      await homeController.prefs.value!.setString(
          homeController.jsonHourlyForecastKey.value, weatherHourlyJson);
      List<Weather> forecast = _parseHourlyForecast(jsonResponse!);

      return forecast;
    }
  }

  Future<List<Weather>?> dailyForecastByLocation(double latitude,
      double longitude, ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
      String? weatherDailyJson = homeController.prefs.value!
          .getString(homeController.jsonDailyForecastKey.value);
      if (weatherDailyJson == null) {
        return null;
      }
      Map<String, dynamic> map = await jsonDecode(weatherDailyJson);
      List<Weather> forecast = _parseDailyForecast(map);
      return forecast;
    } else {
      Map<String, dynamic>? jsonResponse = await _sendRequest(ONE_CALL_FORECAST,
          lat: latitude, lon: longitude, showHourly: false, showDaily: true);
      String weatherDailyJson = jsonEncode(jsonResponse);
      await homeController.prefs.value!.setString(
          homeController.jsonDailyForecastKey.value, weatherDailyJson);
      List<Weather> forecast = _parseDailyForecast(jsonResponse!);

      return forecast;
    }
  }

  Future<Map<String, dynamic>?> _sendRequest(String tag,
      {double? lat,
      double? lon,
      String? cityName,
      required bool showHourly,
      required bool showDaily}) async {
    /// Build HTTP get url by passing the required parameters
    String url = _buildUrl(tag, cityName, lat, lon, showHourly, showDaily);

    /// Send HTTP get response with the url
    http.Response response = await _httpClient.get(Uri.parse(url));

    /// Perform error checking on response:
    /// Status code 200 means everything went well
    if (response.statusCode == STATUS_OK) {
      Map<String, dynamic>? jsonBody = json.decode(response.body);

      return jsonBody;
    }

    /// The API key is invalid, the API may be down
    /// or some other unspecified error could occur.
    /// The concrete error should be clear from the HTTP response body.
    else {
      throw OpenWeatherAPIException(
          "The API threw an exception: ${response.body}");
    }
  }

  String _buildUrl(String tag, String? cityName, double? lat, double? lon,
      bool? showHourly, bool? showWeekly) {
    String url = 'https://api.openweathermap.org/data/2.5/$tag?';

    if (cityName != null) {
      url += 'q=$cityName&';
    } else {
      url += 'lat=$lat&lon=$lon&';
    }
    if (showHourly!) {
      url += 'exclude=current,minutely,daily,alerts&';
    }
    if (showWeekly!) {
      url += 'exclude=current,minutely,hourly,alerts&';
    }

    url += 'appid=$_apiKey&';
    url += 'lang=${_languageCode[language]}';

    return url;
  }
}
