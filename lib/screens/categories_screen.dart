import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'recipes_by_category_screen.dart';
import 'recipe_detail_screen.dart';
import 'favorites_screen.dart';


class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService api = ApiService();
  List<Category> _all = [];
  List<Category> _filtered = [];
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
      final cats = await api.fetchCategories();
      setState(() {
        _all = cats;
        _filtered = cats;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading categories: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onSearch(String q) {
    final qq = q.toLowerCase();
    setState(() {
      _filtered = _all.where((c) =>
        c.strCategory.toLowerCase().contains(qq) ||
        c.strCategoryDescription.toLowerCase().contains(qq)
      ).toList();
    });
  }

  void _openRandom() async {
    try {
      final meal = await api.fetchRandomRecipe();
      Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipeId: meal.idRecipe)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch random recipe: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Категории'),
        actions: [
          TextButton(
            onPressed: _openRandom,
            child: Text(
              "Рандом рецепт",
            style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            tooltip: "Омилени рецепти",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FavoritesScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Пребарај категории...',
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
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: _filtered.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.78,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final c = _filtered[index];
                  return CategoryCard(
                    category: c,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => RecipesByCategoryScreen(categoryName: c.strCategory),
                      ));
                    },
                  );
                },
              ),
            ),
    );
  }
}
