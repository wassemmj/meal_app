import 'package:flutter/material.dart';
import 'package:meal/provider/theme_provider.dart';
import 'package:meal/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

import '../provider/language_provider.dart';
import '../provider/meal_provider.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = "filter_screen";

  final bool fromOnBoarding;

  const FiltersScreen({Key? key,  this.fromOnBoarding = false}) : super(key: key);

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, bool> currentFilters =
        Provider.of<MealProvider>(context, listen: true).filters;
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: widget.fromOnBoarding
            ? AppBar(
                backgroundColor: Theme.of(context).canvasColor, elevation: 0)
            : AppBar(
                title: Text('${lan.getText('filters_appBar_title')}'),
                actions: [
                  IconButton(
                    onPressed: () {
                      // او فينا نستدعي هاد السطر عند كل switch
                      Provider.of<MealProvider>(context, listen: false)
                          .setFilters();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    icon: const Icon(Icons.save),
                  ),
                ],
              ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                lan.getText("filters_screen_title") as String,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  buildSwitchListTile(
                    lan.getText("Gluten-free") as String,
                    lan.getText("Gluten-free-sub")as String,
                    currentFilters['gluten']!,
                    (newVal) => setState(
                      () {
                        currentFilters['gluten'] = newVal;
                      },
                    ),
                  ),
                  buildSwitchListTile(
                    lan.getText("Lactose-free")as String,
                    lan.getText("Lactose-free_sub")as String,
                    currentFilters['lactose']!,
                    (newVal) => setState(
                      () {
                        currentFilters['lactose'] = newVal;
                      },
                    ),
                  ),
                  buildSwitchListTile(
                    lan.getText("Vegan")as String,
                    lan.getText("Vegan-sub")as String,
                    currentFilters['vegan']!,
                    (newVal) => setState(
                      () {
                        currentFilters['vegan'] = newVal;
                      },
                    ),
                  ),
                  buildSwitchListTile(
                    lan.getText("Vegetarian")as String,
                    lan.getText("Vegetarian-sub")as String,
                    currentFilters['vegetarian']!,
                    (newVal) => setState(
                      () {
                        currentFilters['vegetarian'] = newVal;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: widget.fromOnBoarding? 80:0,),
          ],
        ),
        drawer: widget.fromOnBoarding? Container(): const MainDrawer(),
      ),
    );
  }

  SwitchListTile buildSwitchListTile(
      String title, String subTitle, bool value, Function(bool) updateVal) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      subtitle: Text(subTitle),
      onChanged: updateVal,
      inactiveTrackColor:
          Provider.of<ThemeProvider>(context, listen: true).tm ==
                  ThemeMode.light
              ? null
              : Colors.black,
    );
  }
}
