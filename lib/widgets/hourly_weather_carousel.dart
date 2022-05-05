import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HourlyWeatherCarousel extends StatelessWidget {
  const HourlyWeatherCarousel({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          height: 100.0, viewportFraction: 0.355, initialPage: 1),
      items: [0, 1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return SizedBox(
              width: 100,
              child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          Get.locale!.languageCode == 'ru'
                              ? DateFormat('HH', Get.locale!.languageCode)
                                  .format(controller.forecast.value![i].date!)
                              : DateFormat.jm(Get.locale!.languageCode)
                                  .format(controller.forecast.value![i].date!),
                          style: const TextStyle(fontSize: 15.0),
                        ),
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl:
                                'http://openweathermap.org/img/wn/${controller.forecast.value![i].weatherIcon}.png',
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Text(Get.locale!.languageCode == 'ru'
                            ? '${controller.forecast.value![i].temperature!.celsius!.round()} ' +
                                'tempMeasurement'.tr
                            : '${controller.forecast.value![i].temperature!.fahrenheit!.round()} ' +
                                'tempMeasurement'.tr),
                      ],
                    ),
                  )),
            );
          },
        );
      }).toList(),
    );
  }
}
