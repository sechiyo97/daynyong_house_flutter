class Wishlist {
  final String name;
  final String description;
  final String? link;

  Wishlist({
    required this.name,
    required this.description,
    this.link
  });

  factory Wishlist.fromCsvRow(List<dynamic> row) {
    return Wishlist(
      name: row[0].toString(),
      description: row[1].toString(),
      link: (row.length >= 3) ? row[2].toString() : null
    );
  }
}
