import 'package:flutter/material.dart';
import 'package:meal/provider/meal_provider.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../provider/language_provider.dart';
import '../widgets/meal_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context,listen: true);
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    double dw = MediaQuery.of(context).size.width;
    final List<Meal> fav = Provider.of<MealProvider>(context,listen: true).favoriteMeal;
    if (fav.isEmpty) {
      return Directionality(
        textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
        child:  Center(
          child: Text(lan.getText('favorites_text')as String),
        ),
      );
    } else {
      return Directionality(
        textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: dw<=400?400:500,
              childAspectRatio: isLandscape? dw / (dw*0.8): dw/(dw*0.75),
              crossAxisSpacing: 0 ,
              mainAxisSpacing: 0,
            ),
            itemCount: fav.length,
            itemBuilder: (ctx, index) {
              return MealItem(
                id: fav[index].id,
                imgURL: fav[index].imageUrl,
                title: fav[index].title,
                duration: fav[index].duration,
                complexity: fav[index].complexity,
                affordability: fav[index].affordability,
              );
            }),
      );
    }
  }
}
