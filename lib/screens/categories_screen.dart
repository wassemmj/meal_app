import 'package:flutter/material.dart';
import 'package:meal/provider/meal_provider.dart';
import 'package:meal/widgets/category_item.dart';
import 'package:provider/provider.dart';

import '../provider/language_provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context,listen: true);
    return Directionality(
      textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        body: GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          padding: const EdgeInsets.all(25),
          children: Provider.of<MealProvider>(context,listen: true).availableCategory.map((catData) =>
              CategoryItem(catData.id, catData.title, catData.color),
          ).toList(),
        ),
      ),
    );
  }
}
