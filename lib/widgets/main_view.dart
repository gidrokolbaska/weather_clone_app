import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../views/city_view.dart';
import 'daily_weather_card.dart';
import 'hourly_weather_carousel.dart';
import 'todays_weather.dart';

class MainView extends StatelessWidget {
  const MainView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: controller.futureOfConnectivity.value,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Obx(
              () => controller.permission.value == LocationPermission.denied
                  ? Text('locationDenied'.tr)
                  : Column(
                      children: [
                        snapshot.data == ConnectivityResult.none &&
                                controller.weather.value != null
                            ? Obx(
                                () => Text(
                                  'lastUpdate'.tr +
                                      controller.timeDiff.value +
                                      ' ${controller.translationString.value.tr}',
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              )
                            : const SizedBox.shrink(),
                        snapshot.data == ConnectivityResult.none &&
                                controller.weather.value == null
                            ? const SizedBox.shrink()
                            : CupertinoSearchTextField(
                                autocorrect: false,
                                placeholder: 'citySearch'.tr,
                                onSubmitted: (value) async {
                                  await controller.getWeatherByCityName(value);
                                  Get.to(() => CityView());
                                },
                              ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Obx(
                                  () => controller.weather.value == null
                                      ? controller.prefs.value?.getString(
                                                  controller
                                                      .jsonWeatherKey.value) ==
                                              null
                                          ? Center(
                                              child: Text(
                                                'internet'.tr,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )
                                          : const SizedBox.shrink()
                                      : TodaysWeatherCard(
                                          controller: controller),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Obx(
                                  () => controller.forecast.value == null
                                      ? const SizedBox.shrink()
                                      : HourlyWeatherCarousel(
                                          controller: controller),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Obx(
                                  () => controller.forecastDaily.value == null
                                      ? const SizedBox.shrink()
                                      : DailyWeatherCard(
                                          controller: controller),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
