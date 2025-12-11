class RecipeSummary {
  final String idRecipe;
  final String strRecipe;
  final String strRecipeThumb;

  RecipeSummary({
    required this.idRecipe,
    required this.strRecipe,
    required this.strRecipeThumb,
  });

  factory RecipeSummary.fromJson(Map<String, dynamic> json) => RecipeSummary(
        idRecipe: json['idMeal'] ?? '',
        strRecipe: json['strMeal'] ?? '',
        strRecipeThumb: json['strMealThumb'] ?? '',
      );
}
