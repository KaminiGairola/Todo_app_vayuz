import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';

class ThemeController extends GetxController {

  RxBool isDark = false.obs;

  final settingsBox = Hive.box('settings');

  @override
  void onInit() {
    isDark.value =
        settingsBox.get('isDark', defaultValue: false);

    super.onInit();
  }

  void toggleTheme() {
    isDark.value = !isDark.value;

    settingsBox.put('isDark', isDark.value);

    Get.changeThemeMode(
      isDark.value
          ? ThemeMode.dark
          : ThemeMode.light,
    );
  }
}