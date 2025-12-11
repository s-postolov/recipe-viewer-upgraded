import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:recipe/models/recipe_summary.dart';

class RecipeCard extends StatelessWidget {
  final RecipeSummary recipe;
  final VoidCallback onTap;

  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  RecipeCard({
    required this.recipe,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: recipe.strRecipeThumb,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (c, _) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (c, u, e) => Icon(Icons.error),
                    ),
                  ),

                  Positioned(
                    top: 6,
                    right: 6,
                    child: InkWell(
                      onTap: onFavoriteToggle,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white70,
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipe.strRecipe,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
