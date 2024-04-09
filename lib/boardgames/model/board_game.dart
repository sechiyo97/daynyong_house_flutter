class BoardGame {
  final String name;
  final String expansion;
  final String category;
  final String geekWeight;
  final String playerCount;
  final String bestFor;
  final String playTime;

  BoardGame({
    required this.name,
    required this.expansion,
    required this.category,
    required this.geekWeight,
    required this.playerCount,
    required this.bestFor,
    required this.playTime,
  });

  factory BoardGame.fromCsvRow(List<dynamic> row) {
    return BoardGame(
      name: row[0].toString(),
      expansion: row[1].toString(),
      category: row[2].toString(),
      geekWeight: row[3].toString(),
      playerCount: row[4].toString(),
      bestFor: row[5].toString(),
      playTime: row[6].toString(),
    );
  }
}
