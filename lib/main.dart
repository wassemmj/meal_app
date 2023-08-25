import 'package:flutter/material.dart';
import 'package:meal/provider/language_provider.dart';
import 'package:meal/provider/meal_provider.dart';
import 'package:meal/provider/theme_provider.dart';
import 'package:meal/screens/category_meals_screen.dart';
import 'package:meal/screens/filters_screen.dart';
import 'package:meal/screens/meal_detail_screen.dart';
import 'package:meal/screens/on_boarding_screen.dart';
import 'package:meal/screens/tabs_screen.dart';
import 'package:meal/screens/themes_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Widget homeScreen = prefs.getBool('watched')??false ? const TabsScreen():const OnBoardingScreen();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MealProvider>(
          create: (ctx) => MealProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (ctx) => ThemeProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (ctx) => LanguageProvider(),
        ),
      ],
      child:  MyApp(homeScreen),
    ),
   );
}

class MyApp extends StatelessWidget {
  final Widget mainScreen;
  const MyApp(this.mainScreen,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pr = Provider.of<ThemeProvider>(context,listen: true).primaryColor;
    var ac = Provider.of<ThemeProvider>(context,listen: true).accentColor;
    var tm = Provider.of<ThemeProvider>(context,listen: true).tm;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meal App',
      themeMode: tm,
      theme: ThemeData(
        splashColor: Colors.black87,
        shadowColor: Colors.white60,
        cardColor: Colors.white,
        unselectedWidgetColor: Colors.black,
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: const TextStyle(
              color: Color.fromRGBO(20, 50, 50, 1),
            ),
            headline6: const TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontFamily: "RobotoCondensed",
            )), colorScheme: ColorScheme.fromSwatch(primarySwatch: pr).copyWith(secondary: ac),
      ),
      darkTheme: ThemeData(
        splashColor: Colors.white70,
        shadowColor: Colors.white60,
        cardColor: const Color.fromRGBO(35, 34, 39, 1),
        canvasColor: const Color.fromRGBO(14, 22, 33, 1),
        unselectedWidgetColor: Colors.white70,
        textTheme: ThemeData.dark().textTheme.copyWith(
            bodyText1: const TextStyle(
              color: Colors.white60,
            ),
            headline6: const TextStyle(
              fontSize: 20,
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontFamily: "RobotoCondensed",
            )), colorScheme: ColorScheme.fromSwatch(primarySwatch: pr).copyWith(secondary: ac),
      ),
      routes: {
        '/': (context) => mainScreen,
        TabsScreen.routeName: (context) => const TabsScreen(),
        CategoryMealsScreen.routeName: (context) => const CategoryMealsScreen(),
        MealDetailScreen.routeName: (context) => const MealDetailScreen(),
        FiltersScreen.routeName: (context) => const FiltersScreen(),
        ThemeScreen.routeName: (context) => const ThemeScreen(),
      },
    );
  }
}
