class Cocktail {
  final String name;
  final String base;
  final String description;

  Cocktail({
    required this.name,
    required this.base,
    required this.description,
  });

  factory Cocktail.fromCsvRow(List<dynamic> row) {
    return Cocktail(
      name: row[0].toString(),
      base: row[1].toString(),
      description: row[2].toString(),
    );
  }
}
