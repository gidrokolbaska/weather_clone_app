import 'package:get/get.dart';

class TranslationsManager extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'wind': 'Wind',
          'windspeed': 'm/s',
          '7days': '7 DAYS FORECAST',
          'min': 'min',
          'max': 'max',
          'citySearch': 'Enter city name',
          'tempMeasurement': '°F',
          'internet':
              'No Internet connection and no weather data available in memory',
          'lastUpdate': 'Last update: ',
          'minutes': 'minute(s) ago',
          'hours': 'hour(s) ago',
          'seconds': 'seconds ago',
          'moreThanOneDay': 'more than 1 day ago',
          'appName': 'Weather App',
          'locationDenied': 'Location permissions have not been granted yet'
        },
        'ru_RU': {
          'wind': 'Ветер',
          'windspeed': 'м/с',
          '7days': 'ПРОГНОЗ НА 7 ДНЕЙ',
          'min': 'мин',
          'max': 'макс',
          'citySearch': 'Введите название города',
          'tempMeasurement': '℃',
          'internet': 'Нет доступа к интернету и нет данных о погоде в памяти',
          'lastUpdate': 'Последнее обновление: ',
          'minutes': 'минут(у) назад',
          'hours': 'час(ов) назад',
          'seconds': 'секунд назад',
          'moreThanOneDay': 'более 1 дня назад',
          'appName': 'Приложение Погода',
          'locationDenied':
              'Разрешения на определение геолокации еще не были предоставлены'
        }
      };
}
