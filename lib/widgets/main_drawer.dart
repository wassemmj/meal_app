import 'package:flutter/material.dart';
import 'package:meal/screens/tabs_screen.dart';
import 'package:provider/provider.dart';

import '../provider/language_provider.dart';
import '../screens/filters_screen.dart';
import '../screens/themes_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  Widget buildListTile(String title, IconData icon, Function() function,
      BuildContext ctx) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: Theme
            .of(ctx)
            .splashColor,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 24,
            color: Theme
                .of(ctx)
                .textTheme
                .bodyText1
                ?.color,
            fontFamily: "RobotoCondensed",
            fontWeight: FontWeight.bold),
      ),
      onTap: function,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context,listen: true);
    return Directionality(
      textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
      child: Drawer(
        child: Column(
          children: [
            Container(
              alignment: lan.isEn? Alignment.centerLeft:Alignment.centerRight,
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Theme
                  .of(context)
                  .colorScheme.secondary,
              child: Text(
                lan.getText('drawer_name')as String,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Theme
                      .of(context)
                      .colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildListTile(
              lan.getText('drawer_item1')as String,
              Icons.restaurant,
                  () => Navigator.of(context).pushReplacementNamed(TabsScreen.routeName),
              context,
            ),
            buildListTile(
              lan.getText('drawer_item2')as String,
              Icons.settings,
                  () =>
                  Navigator.of(context)
                      .pushReplacementNamed(FiltersScreen.routeName),
              context,
            ),
            buildListTile(
              lan.getText('drawer_item3')as String,
              Icons.color_lens,
                  () =>
                  Navigator.of(context)
                      .pushReplacementNamed(ThemeScreen.routeName),
              context,
            ),
            const Divider(height: 10, color: Colors.black),
            Container(
              alignment: lan.isEn? Alignment.centerLeft:Alignment.centerRight,
              padding: const EdgeInsets.only(top: 10, right: 22),
              child: Text(lan.getText('drawer_switch_title')as String, style: Theme
                  .of(context)
                  .textTheme
                  .headline6,),
            ),
            Padding(padding: EdgeInsets.only(
                right: (lan.isEn ? 0 : 20), left: (lan.isEn ? 20 : 0), bottom:20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(lan.getText('drawer_switch_item2')as String, style: Theme
                      .of(context)
                      .textTheme
                      .headline6,),
                  Switch(
                    value: Provider
                        .of<LanguageProvider>(context, listen: true)
                        .isEn,
                    onChanged: (newLan) {
                      Provider.of<LanguageProvider>(context, listen: false)
                          .changeLan(newLan);
                      Navigator.of(context).pop();
                    },
                    inactiveTrackColor: Provider.of<LanguageProvider>(context, listen: true).isEn? Colors.white:Colors.grey,
                  ),
                  Text(lan.getText('drawer_switch_item1')as String, style: Theme
                      .of(context)
                      .textTheme
                      .headline6,),
                ],
              ),
            ),
            const Divider(height: 10, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
