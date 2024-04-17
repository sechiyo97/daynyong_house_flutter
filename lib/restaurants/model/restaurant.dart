class Restaurant {
  final String name;
  final String mainMenu;
  final String link;

  Restaurant({
    required this.name,
    required this.mainMenu,
    required this.link,
  });

  factory Restaurant.fromGoogleSheetRow(List<dynamic> row) {
    String name = row[0];
    String mainMenu = row[1];
    String link = (row.length > 2) ? row[2] : ""; // link 정보가 있을 경우 사용, 없으면 빈 문자열
    return Restaurant(name: name, mainMenu: mainMenu, link: link);
  }
}
