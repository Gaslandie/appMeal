import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() {
    return _TabsScreen();
  }
}

class _TabsScreen extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];

  //afficher message quand on ajoute ou retire un plat des favoris
  void _showInfoMessage(String message) {
    //faire disparaitre un snackbar existant pour eviter superposition
    ScaffoldMessenger.of(context).clearSnackBars();
    //notre snackBar
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

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  //fonction pour naviguer vers nos screens depuis le drawer
  void _setScreen(String indentifier) {
    Navigator.of(context).pop();
    if (indentifier == 'filters') {
      Navigator.of(
        context,
        //pushReplacement different de push car , il remplace le sceen precedent au lieu de l'ajouter dans la pile de screens
      ).push(MaterialPageRoute(builder: (ctx) => FiltersScreen()));
    } else {
      //si on clique sur meals et qu'on a ouvert le drawer depuis meal on ne navigue pas mais juste fermer le drawer
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }
    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      drawer: MainDrawer(onselectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
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
