import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/providers/meals_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//valeurs initiales des filtres(tous desactivés)
const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

//on remplace StatefulWidget par ConsumerStatefulWidget pour utiliser notre provider(riverpod)
// et ça serait ConsumerWidget pour remplacer un StatelessWidget
class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreen();
  }
}

class _TabsScreen extends ConsumerState<TabsScreen> {
  //et ici ConsumerState au lieu de State pour l'utilisation de notre provider
  int _selectedPageIndex =
      0; //index de la page selectionnée dans la barre de navigation du bas
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters =
      kInitialFilters; //filtres selectionnés par l'utilisateur

  //afficher message quand on ajoute ou retire un plat des favoris à l'aide de Snackbar
  void _showInfoMessage(String message) {
    //faire disparaitre un snackbar existant pour eviter superposition
    ScaffoldMessenger.of(context).clearSnackBars();
    //notre snackBar avec le message passé en paramètre
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  //fonction pour retirer ou ajouter un plat dans favoris en appuyant le button star
  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting) {
      //on le retire sil est deja favoris
      setState(() {
        _favoriteMeals.remove(meal);
        _showInfoMessage('Meal is no longer a favorite');
      });
    } else {
      //on l'ajoute s'il ne l'est pas
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage('Marked as a favorite');
      });
    }
  }

  //change la page affichée en fonction de ce qui est cliqué dans la barre du bas
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  //fonction pour naviguer vers nos screens depuis le drawer
  void _setScreen(String indentifier) async {
    Navigator.of(context).pop();
    if (indentifier == 'filters') {
      final result =
          await Navigator.of(
            context,
            //pushReplacement different de push car , il remplace le sceen precedent au lieu de l'ajouter dans la pile de screens
          ).push<Map<Filter, bool>>(
            MaterialPageRoute(
              builder: (ctx) => FiltersScreen(currentFilters: _selectedFilters),
            ),
          );
      setState(() {
        // on prend result s'il est non null sinon on a _selectedFilters = kInitialFilters;
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider); // ref watch pour observer notre mealsProvider et le mettre à jour dès quil ya changement
    //filtre la liste des plats selon les filtres selectionné
    final availableMeals = meals.where((meal) {
      // Si le filtre "sans gluten" est activé et que le plat n'est pas sans gluten, on l'exclut
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      // Si le filtre "sans lactose" est activé et que le plat n'est pas sans lactose, on l'exclut
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      // Si le filtre "végétarien" est activé et que le plat n'est pas végétarien, on l'exclut
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      // Si le filtre "vegan" est activé et que le plat n'est pas vegan, on l'exclut
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      // Si aucun des filtres n'exclut ce plat, on le garde
      return true;
    }).toList(); // On convertit le résultat en liste

    //Determine la page à afficher selon l'onglet séléctionné
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      //si l'onglet 'Favorites" est selectionné,, on affiche la liste des favoris
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }
    // Structure principale de la page avec AppBar, Drawer, contenu et barre de navigation du bas
    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      drawer: MainDrawer(onselectScreen: _setScreen), //menu lateral
      body: activePage, //Contenu principal(liste des categories ou favoris)
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage, //Change l'onglet sélectionné
        currentIndex: _selectedPageIndex, //Onglet actuellement sélectionné
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
