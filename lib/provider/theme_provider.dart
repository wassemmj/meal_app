import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  var primaryColor = Colors.pink;
  var accentColor = Colors.amber;

  var tm = ThemeMode.system;
  String themeText = 's';

  onChanged(color, n) async {
    n == 1
        ? primaryColor = _setMaterialColor(color.value)
        : accentColor = _setMaterialColor(color.value);
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('primary', primaryColor.value);
    prefs.setInt('accent', accentColor.value);
  }

  getThemeColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    primaryColor = _setMaterialColor(prefs.getInt('primary')??0xFFE91E63);
    accentColor = _setMaterialColor(prefs.getInt('accent')??0xFFFFC107);
    notifyListeners();
  }

  MaterialColor _setMaterialColor(colorVal) {
    return MaterialColor(
      colorVal,
      <int, Color>{
        50:const Color(0xfffce4ec),
        100:const Color(0xfff8bbd0),
        200:const Color(0xfff48fb1),
        300:const Color(0xfff06292),
        400:const Color(0xffec407a),
        500:Color(colorVal),
        600:const Color(0xffd81b60),
        700:const Color(0xffc2185b),
        800:const Color(0xffad1457),
        900:const Color(0xff880e4f),
      },
    );
  }

  void themeModeChanger(newThemeValue) async {
    tm = newThemeValue;
    getThemeText(tm);
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('themeText', themeText);
  }

  void getThemeText(ThemeMode tm) {
    if(tm==ThemeMode.dark) {
      themeText = 'd';
    } else if(tm==ThemeMode.light) {
      themeText = 'l';
    } else if(tm==ThemeMode.system) {
      themeText = 's';
    }
  }

  getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeText = prefs.getString('themeText')??'s';
    if(themeText == 'd') {
      tm = ThemeMode.dark;
    } else if(themeText == 'l') {
      tm = ThemeMode.light;
    } else if(themeText == 's') {
      tm = ThemeMode.system;
    }
    notifyListeners();
  }
}
