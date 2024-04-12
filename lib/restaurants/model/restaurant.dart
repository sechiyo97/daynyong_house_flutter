class Restaurant {
  final String name;
  final String mainMenu;
  final String link;

  Restaurant({
    required this.name,
    required this.mainMenu,
    required this.link,
  });

  factory Restaurant.fromCsvRow(List<dynamic> row) {
    return Restaurant(
      name: row[0].toString(),
      mainMenu: row[1].toString(),
      link: row[2].toString(),
    );
  }
}
