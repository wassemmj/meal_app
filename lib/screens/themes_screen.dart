import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:meal/provider/theme_provider.dart';
import 'package:meal/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

import '../provider/language_provider.dart';

class ThemeScreen extends StatelessWidget {
  final bool fromOnBoarding;

  const ThemeScreen({Key? key, this.fromOnBoarding = false}) : super(key: key);

  static const routeName = '/themes';

  Widget buildRadioListTile(
      ThemeMode themeVal, String txt, IconData icon, BuildContext ctx) {
    return RadioListTile(
        value: themeVal,
        title: Text(txt),
        secondary: Icon(
          icon,
          color: Theme.of(ctx).splashColor,
        ),
        groupValue: Provider.of<ThemeProvider>(ctx, listen: true).tm,
        onChanged: (newThemeVal) {
          Provider.of<ThemeProvider>(ctx, listen: false)
              .themeModeChanger(newThemeVal);
        });
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: fromOnBoarding
            ? AppBar(
                backgroundColor: Theme.of(context).canvasColor, elevation: 0)
            : AppBar(
                title: Text(lan.getText('theme_appBar_title')as String),
              ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                lan.getText('theme_screen_title')as String,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      lan.getText('theme_mode_title')as String,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  buildRadioListTile(ThemeMode.system,
                      lan.getText("System_default_theme")as String, Icons.system_update_tv, context),
                  buildRadioListTile(
                      ThemeMode.light,
                      lan.getText("light_theme")as String,
                      Icons.wb_sunny_outlined,
                      context),
                  buildRadioListTile(ThemeMode.dark, lan.getText("dark_theme")as String,
                      Icons.nights_stay_outlined, context),
                  buildListTile(context, "primary"),
                  buildListTile(context, "accent"),
                  SizedBox(height: fromOnBoarding? 80:0,),
                ],
              ),
            ),
          ],
        ),
        drawer: fromOnBoarding? null: const MainDrawer(),
      ),
    );
  }

  ListTile buildListTile(BuildContext context, String s) {
    var pr = Provider.of<ThemeProvider>(context, listen: true).primaryColor;
    var ac = Provider.of<ThemeProvider>(context, listen: true).accentColor;
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return ListTile(
      title: Text(
        "${lan.getText(s)}",
        style: Theme.of(context).textTheme.headline6,
      ),
      trailing: CircleAvatar(
        backgroundColor: s == 'accent' ? ac : pr,
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                elevation: 4,
                titlePadding: const EdgeInsets.all(0),
                contentPadding: const EdgeInsets.all(0),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: s == 'primary'
                        ? Provider.of<ThemeProvider>(ctx, listen: true)
                            .primaryColor
                        : Provider.of<ThemeProvider>(ctx, listen: true)
                            .accentColor,
                    onColorChanged: (newColor) {
                      Provider.of<ThemeProvider>(ctx, listen: false)
                          .onChanged(newColor, s == 'primary' ? 1 : 2);
                    },
                    colorPickerWidth: 300,
                    pickerAreaHeightPercent: 0.7,
                    enableAlpha: false,
                    displayThumbColor: true,
                    showLabel: false,
                  ),
                ),
              );
            });
      },
    );
  }
}
