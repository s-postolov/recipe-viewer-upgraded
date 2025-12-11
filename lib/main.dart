import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/categories_screen.dart';
import 'providers/favorites_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: RecipeViewerApp(),
    ),
  );
}

class RecipeViewerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheMealDB Recipes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: CategoriesScreen(),
    );
  }
}
