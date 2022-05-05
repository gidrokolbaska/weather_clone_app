import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather_clone/controllers/home_controller.dart';
import 'package:weather_clone/translations/translations.dart';
import 'package:weather_clone/views/city_view.dart';
import 'package:weather_clone/widgets/main_view.dart';
import 'bindings/home_binding.dart';

void main() {
  initializeDateFormatting(Platform.localeName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      translations: TranslationsManager(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        primarySwatch: Colors.blue,
      ),
      locale: Locale(Platform.localeName),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const MyHomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/searchedLocation',
          page: () => CityView(),
        ),
      ],
    );
  }
}

class MyHomePage extends GetView<HomeController> {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('appName'.tr),
        leading: IconButton(
          icon: const Icon(Icons.translate),
          onPressed: () {
            controller.switchLanguage();
          },
        ),
      ),
      body: MainView(
        controller: controller,
      ),
    );
  }
}
