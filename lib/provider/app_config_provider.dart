import 'package:flutter/material.dart';
import 'package:islamiapplication/main/my_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class appconfigprocider extends ChangeNotifier {
  String applang = 'en';
  ThemeMode appTheme = ThemeMode.light;

  Future<void> chanelang(String newlang) async {
    if (applang == newlang) {
      return;
    }
    applang = newlang;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', newlang);
    notifyListeners();
  }

  Future<void> changetheme(ThemeMode newmode) async {
    if (appTheme == newmode) {
      return;
    }
    appTheme = newmode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', newmode==MyTheme.lighttheme?'light':'dark');
    notifyListeners();
  }
}
