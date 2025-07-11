import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

//Stateless car on a aura pas à gerer de state
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  //with sert à ajouter le comportement du mixin SingleTickerProviderState mixin a notre classe
  //un mixin est une classe speciale qui permet de partager du code entre plusieurs classes, sans créer une hierarchie complexe
  //notre classe _CategoriesScreenState herite des methodes et propriété de la mixin en plus de sa propre logique
  late AnimationController
  _animationController; //late pour dire qu'il n'est pas encore initié mais le sera au moment de l'utilisation

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      // lowerBound: 0,//qui est la valeur par defaut
      // upperBound: 1 //valeur par defaut aussi
    );
    _animationController.forward();
  }

  //pour liberer la memoire de notre _animationController
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) =>
            MealsScreen(title: category.title, meals: filteredMeals),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
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
                _selectCategory(context, category);
              },
            ),
        ],
      ),
      builder: (context, child) => Padding(
        padding: EdgeInsets.only(top: 100 - _animationController.value * 100),
        child: child,
      ),
    );
  }
}
