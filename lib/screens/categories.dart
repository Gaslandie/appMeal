import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

//Stateless car on a aura pas à gerer de state
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  //au clic envoyé vers le contenu de la categorie cliquée
  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(title: category.title, meals: filteredMeals),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick your category')),
      //pour afficher une grille d'element
      body: GridView(
        padding: const EdgeInsets.all(24),
        //pour dire qu'on veut deux colonnes
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              2, // Nombre de colonnes dans la grille (ici 2 colonnes)
          childAspectRatio:
              3 /
              2, // Ratio largeur/hauteur de chaque cellule (ici, chaque cellule est 1,5 fois plus large que haute)
          crossAxisSpacing:
              20, // Espace horizontal entre les colonnes (20 pixels)
          mainAxisSpacing: 20, // Espace vertical entre les lignes (20 pixels)
        ),
        children: [
          //afficher nos categorie via les données du dummy data et avec l'aide de
          //notre CategoryGridItem
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context,category);
              },
            ),
        ],
      ),
    );
  }
}
