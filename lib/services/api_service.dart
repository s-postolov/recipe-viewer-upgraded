import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/recipe_summary.dart';
import '../models/recipe_detail.dart';

class ApiService {
  static const base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$base/categories.php');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final List categories = json['categories'] ?? [];
      return categories.map((c) => Category.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<RecipeSummary>> fetchRecipesByCategory(String category) async {
    final url = Uri.parse('$base/filter.php?c=${Uri.encodeComponent(category)}');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final List recipes = json['meals'] ?? [];
      return recipes.map((m) => RecipeSummary.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load recipes for category $category');
    }
  }

  // search globally by name (returns meals that match the query)
  Future<List<RecipeSummary>> searchRecipes(String query) async {
    final url = Uri.parse('$base/search.php?s=${Uri.encodeComponent(query)}');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final List? recipes = json['meals'];
      if (recipes == null) return [];
      return recipes.map((m) => RecipeSummary.fromJson(m)).toList();
    } else {
      throw Exception('Failed to search recipes');
    }
  }

  Future<RecipeDetail> fetchRecipeDetail(String id) async {
    final url = Uri.parse('$base/lookup.php?i=${Uri.encodeComponent(id)}');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final List recipes = json['meals'] ?? [];
      if (recipes.isEmpty) throw Exception('Recipe not found');
      return RecipeDetail.fromJson(recipes[0]);
    } else {
      throw Exception('Failed to load recipe detail for $id');
    }
  }

  Future<RecipeDetail> fetchRandomRecipe() async {
    final url = Uri.parse('$base/random.php');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final List recipes = json['meals'] ?? [];
      if (recipes.isEmpty) throw Exception('No random recipe returned');
      return RecipeDetail.fromJson(recipes[0]);
    } else {
      throw Exception('Failed to fetch random recipe');
    }
  }
}
