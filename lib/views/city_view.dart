import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_clone/controllers/home_controller.dart';

class CityView extends StatelessWidget {
  CityView({Key? key}) : super(key: key);
  final HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(homeController.weatherByCity.value!.areaName!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${homeController.weatherByCity.value!.temperature!.celsius!.round().toString()} ℃',
              style: const TextStyle(color: Colors.black, fontSize: 50),
            ),
            CachedNetworkImage(
              imageUrl:
                  'http://openweathermap.org/img/wn/${homeController.weatherByCity.value!.weatherIcon}@4x.png',
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Text(
              homeController.weatherByCity.value!.weatherDescription!
                  .toUpperCase(),
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
