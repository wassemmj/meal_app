import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dummy_data.dart';
import '../models/category.dart';
import '../models/meal.dart';

class MealProvider with ChangeNotifier {
  Map<String, bool> filters = {
    "gluten": false,
    "lactose": false,
    "vegan": false,
    "vegetarian": false,
  };

  List<Meal> availableMeal = DUMMY_MEALS;
  List<Meal> favoriteMeal = [];
  List<String> prefsMealId = [];
  List<Category> availableCategory = DUMMY_CATEGORIES;

  void setFilters()  async {
    availableMeal = DUMMY_MEALS.where((meal) {
      if (filters["gluten"]! && !meal.isGlutenFree) {
        return false;
      }
      if (filters["lactose"]! && !meal.isLactoseFree) {
        return false;
      }
      if (filters["vegan"]! && !meal.isVegan) {
        return false;
      }
      if (filters["vegetarian"]! && !meal.isVegetarian) {
        return false;
      }
      return true;
    }).toList();
    List<Category> ac = [];
    for (var meal in availableMeal) {
      for (var catId in meal.categories) {
        for (var cat in DUMMY_CATEGORIES) {
          if(cat.id==catId){
            if(!ac.any((cat) => cat.id == catId)) {
              ac.add(cat);
            }
          }
        }
      }
    }
    availableCategory = ac;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('gluten', filters['gluten']!);
    prefs.setBool('lactose', filters['lactose']!);
    prefs.setBool('vegan', filters['vegan']!);
    prefs.setBool('vegetarian', filters['vegetarian']!);
  }

  void getData() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    filters['gluten'] = p.getBool('gluten')?? false;
    filters['lactose'] = p.getBool('lactose')?? false;
    filters['vegan'] = p.getBool('vegan')?? false;
    filters['vegetarian'] = p.getBool('vegetarian')?? false;
    prefsMealId = p.getStringList('prefsID')?? [];
    for(var mealId in prefsMealId) {
      final ex = favoriteMeal.indexWhere((meal) => mealId == meal.id);
      if(ex<0) {
        favoriteMeal.add(DUMMY_MEALS.firstWhere((meal) => mealId == meal.id));
      }
    }
    List<Meal> fm = [];
    favoriteMeal.forEach((favMeal) {
      availableMeal.forEach((avMeals) {
        if(favMeal.id == avMeals.id) {
          fm.add(favMeal);
        }
      });
    });
    favoriteMeal = fm;
    notifyListeners();
  }

  void toggleFavorites(String mealId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final exIndex = favoriteMeal.indexWhere((meal) => mealId == meal.id);
    if (exIndex >= 0) {
        favoriteMeal.removeAt(exIndex);
        prefsMealId.remove(mealId);
    } else {
        favoriteMeal.add(DUMMY_MEALS.firstWhere((meal) => mealId == meal.id));
        prefsMealId.add(mealId);
    }
    prefs.setStringList('prefsID', prefsMealId);
    notifyListeners();
  }

  bool isMealFavorites(String id) {
    return favoriteMeal.any((meal) => id == meal.id);
  }
}
