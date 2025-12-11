import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/categories_screen.dart';
import 'providers/favorites_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Test to check whether firebase firestore db works. 
  //FirebaseFirestore.instance.collection('test').doc('check').set({
  //'connected': true,
  //'timestamp': DateTime.now(),
  //});

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
