import 'package:flutter/material.dart';
import '../models/recipe_summary.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<RecipeSummary> _favorites = [];

  List<RecipeSummary> get favorites => _favorites;

  bool isFavorite(String id) {
    return _favorites.any((r) => r.idRecipe == id);
  }

  void toggleFavorite(RecipeSummary recipe) {
    if (isFavorite(recipe.idRecipe)) {
      _favorites.removeWhere((r) => r.idRecipe == recipe.idRecipe);
    } else {
      _favorites.add(recipe);
    }
    notifyListeners();
  }
}
