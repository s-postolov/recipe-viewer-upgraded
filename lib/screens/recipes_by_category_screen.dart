import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/recipe_summary.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';
import '../favorite_recipes.dart';

class RecipesByCategoryScreen extends StatefulWidget {
  final String categoryName;
  RecipesByCategoryScreen({required this.categoryName});

  @override
  _RecipesByCategoryScreenState createState() => _RecipesByCategoryScreenState();
}

class _RecipesByCategoryScreenState extends State<RecipesByCategoryScreen> {
  final ApiService api = ApiService();
  List<RecipeSummary> _recipes = [];
  List<RecipeSummary> _display = [];
  bool _loading = true;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final recipes = await api.fetchRecipesByCategory(widget.categoryName);
      setState(() {
        _recipes = recipes;
        _display = recipes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading recipes: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _onSearch(String q) async {
    final query = q.trim();
    if (query.isEmpty) {
      setState(() => _display = _recipes);
      return;
    }
    
    setState(() => _loading = true);
    try {
      final results = await api.searchRecipes(query);
      final filtered = results.where((m) => m.strRecipe.isNotEmpty).toList();
    
      final idsInCategory = _recipes.map((m) => m.idRecipe).toSet();
      final inCategory = filtered.where((m) => idsInCategory.contains(m.idRecipe)).toList();
      setState(() => _display = inCategory);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Search failed: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Пребарај јадења (во категоријата)...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _display.isEmpty
              ? Center(child: Text('Нема резултати'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: _display.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final recipe = _display[index];
                      return RecipeCard(
                        recipe: recipe,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailScreen(recipeId: recipe.idRecipe),
                            ),
                          );
                        },

                        isFavorite: FavoriteRecipes().isFavorite(recipe.idRecipe),
                        onFavoriteToggle: () {
                          setState(() {
                            FavoriteRecipes().toggleFavorite(recipe);
                          });
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
