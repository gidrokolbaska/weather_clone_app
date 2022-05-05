import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class TodaysWeatherCard extends StatelessWidget {
  const TodaysWeatherCard({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              controller.weather.value!.areaName!.toUpperCase(),
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              DateFormat.MMMMEEEEd(Get.locale!.languageCode)
                  .format(controller.weather.value!.date!),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      controller.weather.value!.weatherDescription!
                          .toUpperCase(),
                    ),
                    Text(
                      Get.locale!.languageCode == 'ru'
                          ? '${controller.weather.value!.temperature!.celsius!.round()} ' +
                              'tempMeasurement'.tr
                          : '${controller.weather.value!.temperature!.fahrenheit!.round()} ' +
                              'tempMeasurement'.tr,
                      style: const TextStyle(fontSize: 35),
                    ),
                  ],
                ),
                Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          'http://openweathermap.org/img/wn/${controller.weather.value!.weatherIcon!}@4x.png',
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      width: 90,
                      height: 90,
                    ),
                    Text('wind'.tr +
                        ' ${controller.weather.value!.windSpeed} ' +
                        'windspeed'.tr),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
