import 'package:flutter/material.dart';
// import 'package:meals/main.dart';
// import 'package:meals/screens/tabs.dart';
// import 'package:meals/widgets/main_drawer.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});
  @override
  State<FiltersScreen> createState() {
    return _FiltersScreenState();
  }
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutenFreeFilterSet = false;
  var _lactoseFreeFilterSet = false;
  var _vegetarianFilterSet = false;
  var _veganFilterSet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Filters')),
      // drawer: MainDrawer(
      //   onselectScreen: (identifier) {
      //     Navigator.of(context).pop();
      //     if (identifier == 'meals') {
      //       Navigator.of(
      //         context,
      //       ).pushReplacement(MaterialPageRoute(builder: (ctx) => TabsScreen()));
      //     }
      //   },
      // ),
      body: PopScope(
        canPop:
            false, // Empêche l'utilisateur de revenir en arrière automatiquement (par exemple, avec le bouton retour)
        // Fonction appelée quand l'utilisateur tente de quitter l'écran (pop)
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          // didPop : true si le pop a déjà eu lieu, false sinon
          // result : valeur retournée par un pop précédent (pas utilisé ici)
          if (didPop) return; // Si le pop a déjà eu lieu, on ne fait rien

          // Si l'utilisateur quitte l'écran, on retourne les filtres sélectionnés à l'écran précédent
          Navigator.of(context).pop({
            Filter.glutenFree: _glutenFreeFilterSet,
            Filter.lactoseFree: _lactoseFreeFilterSet,
            Filter.vegetarian: _vegetarianFilterSet,
            Filter.vegan: _veganFilterSet,
          });
        },
        child: Column(
          children: [
            SwitchListTile(
              value:
                  _glutenFreeFilterSet, //l'etat actuel de l'interrupteur(boolean)
              onChanged: (isChecked) {
                setState(() {
                  _glutenFreeFilterSet = isChecked;
                });
              }, //fonction appélée quand le user change l'etat du switch
              title: Text(
                'Gluten-free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                //sous titre explicatif sous le titre
                'Only include gluten-free meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              //couleur du switch lorsqu'il est activé
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value:
                  _lactoseFreeFilterSet, //l'etat actuel de l'interrupteur(boolean)
              onChanged: (isChecked) {
                setState(() {
                  _lactoseFreeFilterSet = isChecked;
                });
              }, //fonction appélée quand le user change l'etat du switch
              title: Text(
                'lactose-free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                //sous titre explicatif sous le titre
                'Only include lactose-free meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              //couleur du switch lorsqu'il est activé
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value:
                  _vegetarianFilterSet, //l'etat actuel de l'interrupteur(boolean)
              onChanged: (isChecked) {
                setState(() {
                  _vegetarianFilterSet = isChecked;
                });
              }, //fonction appélée quand le user change l'etat du switch
              title: Text(
                'Vegetarian',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                //sous titre explicatif sous le titre
                'Only include vegetarian meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              //couleur du switch lorsqu'il est activé
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _veganFilterSet, //l'etat actuel de l'interrupteur(boolean)
              onChanged: (isChecked) {
                setState(() {
                  _veganFilterSet = isChecked;
                });
              }, //fonction appélée quand le user change l'etat du switch
              title: Text(
                'Vegan',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                //sous titre explicatif sous le titre
                'Only include vegan meals.',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              //couleur du switch lorsqu'il est activé
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
          ],
        ),
      ),
    );
  }
}
