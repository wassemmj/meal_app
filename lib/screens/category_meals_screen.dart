import 'package:flutter/material.dart';
import 'package:meal/models/meal.dart';
import 'package:meal/provider/meal_provider.dart';
import 'package:meal/widgets/meal_item.dart';
import 'package:provider/provider.dart';

import '../provider/language_provider.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = "category_meals";

  const CategoryMealsScreen({Key? key}) : super(key: key);

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  late String categoryTitle;
  late List<Meal> displayMeals;

  // تتنفذ بكل مرة يتم فيها تغيير الحالة
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final List<Meal> avaMeal = Provider.of<MealProvider>(context).availableMeal;
    final routeArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final categoryId = routeArg["id"];
    categoryTitle = routeArg["title"]!;
    displayMeals = avaMeal.where((meal) {
      return meal.categories.contains(categoryId);
    }).toList();
  }

  void removeMeal(String mealId) {
    setState(() {
      displayMeals.removeWhere((meal) => meal.id == mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    double dw = MediaQuery.of(context).size.width;
    var lan = Provider.of<LanguageProvider>(context,listen: true);
    final routeArg =
    ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return Directionality(
      textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(lan.getText('cat-${routeArg["id"]}') as String),
        ),
        body: GridView.builder(
          itemCount: displayMeals.length,
          itemBuilder: (ctx, index) {
            return MealItem(
              id: displayMeals[index].id,
              imgURL: displayMeals[index].imageUrl,
              title: displayMeals[index].title,
              duration: displayMeals[index].duration,
              complexity: displayMeals[index].complexity,
              affordability: displayMeals[index].affordability,
            );
          },
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: dw<=400?400:500,
            childAspectRatio: isLandscape? dw / (dw*0.8): dw/(dw*0.75),
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
        ),
      ),
    );
  }
}
