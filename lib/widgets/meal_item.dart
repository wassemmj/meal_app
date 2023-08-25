import 'package:flutter/material.dart';
import 'package:meal/screens/meal_detail_screen.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../provider/language_provider.dart';

class MealItem extends StatelessWidget {
  final String id;
  final String imgURL;
  final String title;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;

  const MealItem({Key? key,
    required this.imgURL,
    required this.title,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.id,
  }) : super(key: key);

  String get complexityText {
    switch (complexity) {
      case Complexity.Simple:
        return "Simple";
      case Complexity.Challenging:
        return "Challenging";
      case Complexity.Hard:
        return "Hard";
      default:
        return "UNKnown";
    }
  }

  String get affordabilityText {
    switch (affordability) {
      case Affordability.Affordable:
        return "Affordable";
      case Affordability.Pricey:
        return "Pricey";
      case Affordability.Luxurious:
        return "Luxurious";
      default:
        return "UNKnown";
    }
  }

  void selectMeal(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      MealDetailScreen.routeName,
      arguments: id,
    ).then((result) {
     // if(result!=null) {
      //  removeItem(result);
      //}
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    var lan = Provider.of<LanguageProvider>(context,listen: true);
    return Directionality(
      textDirection: lan.isEn?TextDirection.ltr:TextDirection.rtl,
      child: InkWell(
        onTap: () => selectMeal(context),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Hero(
                      tag: id,
                      child: InteractiveViewer(
                        maxScale: 3,
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                          placeholder: const AssetImage('assets/images/a2.png'),
                          image: NetworkImage(
                            imgURL,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: Container(
                      width: 300,
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text(
                        lan.getText('meal-$id')as String,
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.schedule,color: Theme.of(context).splashColor),
                        const SizedBox(
                          width: 6,
                        ),
                        Text("$duration ${lan.getText('min')}"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.work,color: Theme.of(context).splashColor),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(lan.getText('$complexity')as String),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.attach_money,color: Theme.of(context).splashColor),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(lan.getText('$affordability')as String),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
