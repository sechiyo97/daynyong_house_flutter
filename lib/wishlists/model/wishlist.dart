class Wishlist {
  final String name;
  final String description;

  Wishlist({
    required this.name,
    required this.description,
  });

  factory Wishlist.fromCsvRow(List<dynamic> row) {
    return Wishlist(
      name: row[0].toString(),
      description: row[1].toString(),
    );
  }
}
