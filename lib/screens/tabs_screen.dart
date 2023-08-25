import 'package:flutter/material.dart';
import 'package:meal/provider/meal_provider.dart';
import 'package:meal/screens/categories_screen.dart';
import 'package:meal/screens/favorites_screen.dart';
import 'package:provider/provider.dart';

import '../provider/language_provider.dart';
import '../provider/theme_provider.dart';
import '../widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  static const routeName = 'tabs_screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map<String, Object>>  pages;

  int __selectPageIndex = 0;

  @override
  void initState() {
    Provider.of<MealProvider>(context,listen: false).getData();
    Provider.of<ThemeProvider>(context,listen: false).getThemeMode();
    Provider.of<ThemeProvider>(context,listen: false).getThemeColor();
    Provider.of<LanguageProvider>(context,listen: false).getLan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context,listen: true);
    pages =[
      {
        "page": const CategoriesScreen(),
        "title": lan.getText("categories")as String,
      },
      {
        "page": const FavoritesScreen(),
        "title": lan.getText('your_favorites')as String,
      },
    ];
    return Directionality(
      textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(pages[__selectPageIndex]["title"]as String),
        ),
        extendBody: true,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Colors.white,
          currentIndex: __selectPageIndex,
          onTap: _selectPage,
          items:  [
            BottomNavigationBarItem(
              icon: const Icon(Icons.category),
              label: lan.getText('categories')as String,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.star),
              label: lan.getText('your_favorites')as String,
            ),
          ],
        ),     body: pages[__selectPageIndex]["page"]as Widget,

        drawer: const MainDrawer(),
      ),
    );
  }

  void _selectPage(int value) {
    setState(() {
      __selectPageIndex = value;
    });
  }
}
