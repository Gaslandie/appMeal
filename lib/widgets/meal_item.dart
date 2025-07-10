import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal, required this.onSelectMeal});

  final Meal meal;
  final void Function(Meal meal) onSelectMeal;

  String get complexityText {
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(1);
  }

  String get affordabilityText {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip
          .hardEdge, //coupe le contenu de la carte pour qu'il ne deborde pas des bords arondis
      elevation: 2,
      child: InkWell(
        //permet de detecter les interaction tactiles
        onTap: () {
          onSelectMeal(meal);
        }, //action à effectuer lors du clic sur la Card
        child: Stack(
          //Stack permet de superposer plusieurs widgets les uns sur les autres
          children: [
            FadeInImage(
              //Affiche une image avec un effet de fondu lors du chargement
              placeholder: MemoryImage(
                kTransparentImage,
              ), //image transparente affichée en attendant le chargement
              image: NetworkImage(
                meal.imageUrl,
              ), //Image principale chargée depuis une Url
              fit: BoxFit
                  .cover, //l'image est agrandie pour couvrir tout l'espace disponible,quitte à etre coupée si necessaire
              height: 200,
              width: double.infinity,
            ),
            //pour positionner un widget à un endroit precis dans la stack
            //place le widget en bas, etendu de gauche à droite
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 44,
                ),
                child: Column(
                  children: [
                    Text(
                      meal.title, //affiche le titre du plat
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true, //permet le retour à la ligne automatique
                      overflow: TextOverflow
                          .ellipsis, //ajoute ... si le texte est trop long
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MealItemTrait(
                          icon: Icons.schedule,
                          label: '${meal.duration} min',
                        ),
                        const SizedBox(width: 12),
                        MealItemTrait(icon: Icons.work, label: complexityText),
                        const SizedBox(width: 12),
                        MealItemTrait(
                          icon: Icons.attach_money,
                          label: affordabilityText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
