import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class DailyWeatherCard extends StatelessWidget {
  const DailyWeatherCard({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35))),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(
                  width: 10.0,
                ),
                Text('7days'.tr),
              ],
            ),
            const Divider(),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: 7,
              itemBuilder: (context, index) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        child: Text(
                          DateFormat('EE', Get.locale!.languageCode).format(
                              controller.forecastDaily.value![index].date!),
                        ),
                      ),
                      CachedNetworkImage(
                        imageUrl:
                            'http://openweathermap.org/img/wn/${controller.forecastDaily.value![index].weatherIcon}.png',
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      SizedBox(
                        width: 50,
                        child: Column(
                          children: [
                            Text('min'.tr),
                            Text(Get.locale!.languageCode == 'ru'
                                ? '${controller.forecastDaily.value![index].tempMin!.celsius!.round()} ' +
                                    'tempMeasurement'.tr
                                : '${controller.forecastDaily.value![index].tempMin!.fahrenheit!.round()} ' +
                                    'tempMeasurement'.tr),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Column(
                          children: [
                            Text('max'.tr),
                            Text(Get.locale!.languageCode == 'ru'
                                ? '${controller.forecastDaily.value![index].tempMax!.celsius!.round()} ' +
                                    'tempMeasurement'.tr
                                : '${controller.forecastDaily.value![index].tempMax!.fahrenheit!.round()} ' +
                                    'tempMeasurement'.tr)
                          ],
                        ),
                      ),
                    ]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ],
        ),
      ),
    );
  }
}
