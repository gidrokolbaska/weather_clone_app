// import 'package:geolocator/geolocator.dart';

import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../weather api/weather.dart';

class HomeController extends GetxController {
  Rxn<Position> position = Rxn();
  Rxn<LocationPermission> permission = Rxn();

  var apiKey = '63d34f5db3e1ffff24b4a2f3ea037fbe'.obs;

  Rxn<Weather> weather = Rxn();
  Rxn<List<Weather>> forecast = Rxn();
  Rxn<List<Weather>> forecastDaily = Rxn();
  Rxn<Weather> weatherByCity = Rxn();
  late Rxn<WeatherFactory> wf = Rxn();
  var language = false.obs;

  final jsonWeatherKey = 'json_weather'.obs;
  final jsonHourlyForecastKey = 'json_Hourlyweather'.obs;
  final jsonDailyForecastKey = 'json_Dailyweather'.obs;

  late Rxn<SharedPreferences> prefs = Rxn();
  Rxn<ConnectivityResult> connectivityResult = Rxn();
  Rxn<Future<ConnectivityResult>> futureOfConnectivity = Rxn();

  RxString timeDiff = ''.obs;
  RxString translationString = ''.obs;
  late Duration diff;
  @override
  void onInit() async {
    futureOfConnectivity.value = Connectivity().checkConnectivity();
    super.onInit();
    prefs.value = await SharedPreferences.getInstance();
    connectivityResult.value = await futureOfConnectivity.value;

    position.value = await _determinePosition();

    diff = DateTime.now().difference(position.value!.timestamp!);
//Oh yeah, tons of "if's", that's what I like, xD
//Basically the "interval logic" from step 7
    if (diff.inDays < 1 &&
        diff.inHours.remainder(24) < 24 &&
        diff.inMinutes.remainder(60) < 1) {
      timeDiff.value = diff.inSeconds.remainder(60).toString();
      translationString.value = 'seconds';
    } else if (diff.inDays < 1 &&
        diff.inHours.remainder(24) < 1 &&
        diff.inMinutes.remainder(60) >= 1 &&
        diff.inMinutes.remainder(60) < 60) {
      timeDiff.value = diff.inMinutes.remainder(60).toString();
      translationString.value = 'minutes';
    } else if (diff.inDays < 1 &&
        diff.inHours.remainder(24) < 24 &&
        diff.inHours.remainder(24) >= 1) {
      timeDiff.value = diff.inHours.remainder(60).toString();
      translationString.value = 'hours';
    } else if (diff.inDays >= 1) {
      translationString.value = 'moreThanOneDay';
      timeDiff.value = translationString.value;
    }

    wf.value = WeatherFactory(apiKey.value,
        language: Get.locale!.languageCode == 'ru'
            ? Language.RUSSIAN
            : Language.ENGLISH);

    if (position.value != null) {
      weather.value = await wf.value!.currentWeatherByLocation(
          position.value!.latitude,
          position.value!.longitude,
          connectivityResult.value!);

      forecast.value = await wf.value!.hourlyForecastByLocation(
          position.value!.latitude,
          position.value!.longitude,
          connectivityResult.value!);
      forecastDaily.value = await wf.value!.dailyForecastByLocation(
          position.value!.latitude,
          position.value!.longitude,
          connectivityResult.value!);
    }
  }

  Future getWeatherByCityName(String cityName) async {
    weatherByCity.value = await wf.value!.currentWeatherByCityName(cityName);
    return weatherByCity.value;
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return Future.error('Location services are disabled.');
    }

    permission.value = await Geolocator.checkPermission();

    if (permission.value == LocationPermission.denied) {
      permission.value = await Geolocator.requestPermission();
      if (permission.value == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return Future.error('Location permissions are denied');
      }
    }

    if (permission.value == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    if (connectivityResult.value == ConnectivityResult.none) {
      return await Geolocator.getLastKnownPosition();
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
  }

  void switchLanguage() {
    language.value = !language.value;
    var locale =
        language.value ? const Locale('en', 'US') : const Locale('ru', 'RU');
    Get.updateLocale(locale);
    wf.value = WeatherFactory(apiKey.value,
        language: Get.locale!.languageCode == 'ru'
            ? Language.RUSSIAN
            : Language.ENGLISH);
  }
}
