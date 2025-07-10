import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class FavoritesMealsNotifier extends StateNotifier<List<Meal>> {
  FavoritesMealsNotifier()
    : super([]); //le constructeur initialise la liste des favoris à vide

  //methode pourajouter our retirer un plat des favoris
  bool toggleMealFavoritesStatus(Meal meal) {
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      //on utilise where pour creer une nouvelle liste sans ce plat
      // on ne peut pas utiliser .remove car state doit etre immutable
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      //sinon on ajoute le plat à la liste des favoris
      //on crée une nouvelle liste avec tous les favoris plus le nouveau plat
      state = [...state, meal];
      return true;
    }
  }
}

// StateNotifierProvider est utilisé pour gérer des données dynamiques et modifiables
// Ici, il expose une instance de FavoritesMealsNotifier et la liste des favoris (List<Meal>)
final favoriteMealsProvider =
    StateNotifierProvider<FavoritesMealsNotifier, List<Meal>>((ref) {
      return FavoritesMealsNotifier();
    });
