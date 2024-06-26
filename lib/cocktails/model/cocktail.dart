class Cocktail {
  final String name;
  final String description;
  final Map<String, String>? recipe;

  Cocktail({
    required this.name,
    required this.description,
    required this.recipe,
  });

  String? recipeDisplayString() {
    if (recipe == null) return null;
    return recipe!.entries.map((entry) => '${entry.key}(${toRecipeAmountDisplayString(entry.value)})').join(' + ');
  }

  factory Cocktail.fromGoogleSheetRow(List<dynamic> row) {
    String? recipeRawString = (row.length >= 3) ? row[2].toString() : null;
    Map<String, String>? recipe;

    if (recipeRawString != null) {
      recipe = <String, String>{};
      recipeRawString.split(',').forEach((element) {
        List<String> ingredientData = element.split(':');
        String name = ingredientData[0];
        String amount = ingredientData[1];
        recipe?[name] = amount;
      });
    }

    return Cocktail(
      name: row[0].toString(),
      description: row[1].toString(),
      recipe: recipe,
    );
  }
}

String toRecipeAmountDisplayString(String amountChar) {
  switch(amountChar) {
    case "D": return "조금";
    case "F": return "채우기";
    default: return amountChar;
  }
}
