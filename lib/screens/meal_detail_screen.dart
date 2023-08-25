import 'package:flutter/material.dart';
import 'package:meal/dummy_data.dart';
import 'package:meal/provider/meal_provider.dart';
import 'package:provider/provider.dart';

import '../provider/language_provider.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = "meal_detail";

  const MealDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context)!.settings.arguments as String;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => mealId == meal.id);
    var accentColor = Theme.of(context).colorScheme.secondary;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var lan = Provider.of<LanguageProvider>(context, listen: true);
    var ingLi = lan.getText("ingredients-$mealId") as List<String>;
    var stLi = lan.getText("steps-$mealId") as List<String>;
    return Directionality(
      textDirection: lan.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(lan.getText('meal-$mealId')as String),
                background: Hero(
                  tag: mealId,
                  child: InteractiveViewer(
                    maxScale: 3,
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: const AssetImage('assets/images/a2.png'),
                      image: NetworkImage(
                        selectedMeal.imageUrl,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  isLandscape
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          buildSectionTitle(context, "Ingredients"),
                          buildContainer(
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: selectedMeal.ingredients.length,
                                itemBuilder: (ctx, index) {
                                  return Card(
                                    color: accentColor,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                        ingLi[index],
                                        style: const TextStyle(
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              context),
                        ],
                      ),
                      Column(
                        children: [
                          buildSectionTitle(context, "Steps"),
                          buildContainer(ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: selectedMeal.steps.length,
                                itemBuilder: (ctx, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          child: Text("#${index + 1}"),
                                        ),
                                        title: Text(
                                          stLi[index],
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                      selectedMeal.steps.length - 1 == index
                                          ? const Text("The End")
                                          : const Divider(),
                                    ],
                                  );
                                },
                              ), context),
                        ],
                      )
                    ],
                  )
                      : Column(
                    children: [
                      buildSectionTitle(context, "Ingredients"),
                      buildContainer(
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: selectedMeal.ingredients.length,
                            itemBuilder: (ctx, index) {
                              return Card(
                                color: accentColor,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    ingLi[index],
                                    style: const TextStyle(
                                        color: Colors.blueGrey),
                                  ),
                                ),
                              );
                            },
                          ),
                          context),
                      buildSectionTitle(context, "Steps"),
                      buildContainer(
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: selectedMeal.steps.length,
                            itemBuilder: (ctx, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      child: Text("#${index + 1}"),
                                    ),
                                    title: Text(
                                      stLi[index],
                                      style: const TextStyle(
                                          color: Colors.black),
                                    ),
                                  ),
                                  selectedMeal.steps.length - 1 == index
                                      ? const Text("The End")
                                      : const Divider(),
                                ],
                              );
                            },
                          ),
                          context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<MealProvider>(context, listen: false)
                .toggleFavorites(mealId);
          },
          child: Icon(Provider.of<MealProvider>(context, listen: true)
                  .isMealFavorites(mealId)
              ? Icons.star
              : Icons.star_border),
        ),
      ),
    );
  }

  Container buildContainer(Widget child, BuildContext ctx) {
    bool isLandscape = MediaQuery.of(ctx).orientation == Orientation.landscape;
    double dw = MediaQuery.of(ctx).size.width;
    double dh = MediaQuery.of(ctx).size.height;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: isLandscape ? dh * 0.5 : dh * 0.25,
      width: isLandscape ? (dw * 0.5 - 30) : dw,
      child: child,
    );
  }

  Container buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        Provider.of<LanguageProvider>(context).getText(text)as String,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    );
  }
}
