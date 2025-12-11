class RecipeDetail {
  final String idRecipe;
  final String strRecipe;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strRecipeThumb;
  final String? strYoutube;
  final List<Map<String, String>> ingredients;

  RecipeDetail({
    required this.idRecipe,
    required this.strRecipe,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strRecipeThumb,
    required this.ingredients,
    this.strYoutube,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> ingr = [];
    for (int i = 1; i <= 20; i++) {
      final ingrKey = 'strIngredient$i';
      final measureKey = 'strMeasure$i';
      final ing = (json[ingrKey] ?? '').toString().trim();
      final measure = (json[measureKey] ?? '').toString().trim();
      if (ing.isNotEmpty) {
        if (measure.isNotEmpty) {
          ingr.add({ 'ingredient': ing, 'measure': measure });
        } else {
          ingr.add({ 'ingredient': ing, 'measure': '' });
        }
      }
    }

    return RecipeDetail(
      idRecipe: json['idMeal'] ?? '',
      strRecipe: json['strMeal'] ?? '',
      strCategory: json['strCategory'] ?? '',
      strArea: json['strArea'] ?? '',
      strInstructions: json['strInstructions'] ?? '',
      strRecipeThumb: json['strMealThumb'] ?? '',
      strYoutube: json['strYoutube'],
      ingredients: ingr,
    );
  }
}
