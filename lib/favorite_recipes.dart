import 'package:recipe/models/recipe_summary.dart';

class FavoriteRecipes {
  static final FavoriteRecipes _instance = FavoriteRecipes._internal();

  factory FavoriteRecipes() => _instance;

  FavoriteRecipes._internal();

  final List<RecipeSummary> favorites = [];

  void toggleFavorite(RecipeSummary recipe) {
    if (favorites.any((r) => r.idRecipe == recipe.idRecipe)) {
      favorites.removeWhere((r) => r.idRecipe == recipe.idRecipe);
    } else {
      favorites.add(recipe);
    }
  }

  bool isFavorite(String id) {
    return favorites.any((r) => r.idRecipe == id);
  }
}
