import 'package:flutter/material.dart';
import 'package:recipe/favorite_recipes.dart';
import 'package:recipe/widgets/recipe_card.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favorites = FavoriteRecipes().favorites;

    return Scaffold(
      appBar: AppBar(title: Text("Омилени рецепти")),
      body: favorites.isEmpty
          ? Center(child: Text("Немате омилени рецепти"))
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final recipe = favorites[index];

                return RecipeCard(
                  recipe: recipe,
                  onTap: () {
                    // open recipe detail
                  },
                  isFavorite: true,
                  onFavoriteToggle: () {
                    setState(() {
                      FavoriteRecipes().toggleFavorite(recipe);
                    });
                  },
                );
              },
            ),
    );
  }
}
