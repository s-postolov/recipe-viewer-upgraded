import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/recipe_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  RecipeDetailScreen({required this.recipeId});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final ApiService api = ApiService();
  RecipeDetail? _recipe;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final detail = await api.fetchRecipeDetail(widget.recipeId);
      setState(() => _recipe = detail);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading recipe: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _openYoutube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can't open url")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_recipe?.strRecipe ?? 'Рецепт'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _recipe == null
              ? Center(child: Text('Не може да се преземе рецептот'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: _recipe!.strRecipeThumb,
                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                        placeholder: (c, _) => Container(height: 240, child: Center(child: CircularProgressIndicator())),
                        errorWidget: (c, u, e) => Container(height: 240, child: Icon(Icons.error)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          _recipe!.strRecipe,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (_recipe!.strCategory.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text('Категорија: ${_recipe!.strCategory} • Област: ${_recipe!.strArea}'),
                        ),
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('Состојки:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _recipe!.ingredients.map((ing) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text('- ${ing['ingredient']}${ing['measure'] != null && ing['measure']!.isNotEmpty ? ' — ${ing['measure']}' : ''}'),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text('Инструкции:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(_recipe!.strInstructions),
                      ),
                      if (_recipe!.strYoutube != null && _recipe!.strYoutube!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.play_circle_fill),
                            label: Text('Отвори YouTube видео'),
                            onPressed: () => _openYoutube(_recipe!.strYoutube!),
                          ),
                        ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
    );
  }
}
