import 'package:flutter/material.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:meals/providers/filters_provider.dart';

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
      await Navigator.of(
        context,
        //pushReplacement different de push car , il remplace le sceen precedent au lieu de l'ajouter dans la pile de screens
      ).push<Map<Filter, bool>>(
        MaterialPageRoute(builder: (ctx) => const FiltersScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filterdMealsProvider);

    //Determine la page à afficher selon l'onglet séléctionné
    Widget activePage = CategoriesScreen(availableMeals: availableMeals);
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      //si l'onglet 'Favorites" est selectionné,, on affiche la liste des favoris
      activePage = MealsScreen(meals: favoriteMeals);
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
