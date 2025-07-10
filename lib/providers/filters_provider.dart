import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
    : super({
        Filter.glutenFree: false,
        Filter.lactoseFree: false,
        Filter.vegetarian: false,
        Filter.vegan: false,
      });
  void setFilter(Filter filter, bool isActive) {
    // state[filter] = isActive; //not allowed! => mutation state(not allowed)
    state = {...state, filter: isActive};
  }

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
      (ref) => FiltersNotifier(),
    );


// provider qui depend d'autre provider
final filterdMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((meal) {
    // Si le filtre "sans gluten" est activé et que le plat n'est pas sans gluten, on l'exclut
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    // Si le filtre "sans lactose" est activé et que le plat n'est pas sans lactose, on l'exclut
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    // Si le filtre "végétarien" est activé et que le plat n'est pas végétarien, on l'exclut
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    // Si le filtre "vegan" est activé et que le plat n'est pas vegan, on l'exclut
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    // Si aucun des filtres n'exclut ce plat, on le garde
    return true;
  }).toList(); // On convertit le résultat en liste
});
