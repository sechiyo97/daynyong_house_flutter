
class CardModel {
  Expansion expansion;
  String nameKr;
  String nameEng;
  String image;
  int price;
  CardType type;
  int addCardCount;
  int addActionCount;
  int addBuyCount;
  bool isAddMoney;
  bool isAttack;
  bool isDiscard;
  bool isPinned;

  CardModel({
    this.expansion = Expansion.kingdom,
    required this.nameKr,
    required this.nameEng,
    required this.price,
    this.type = CardType.action,
    this.addCardCount = 0,
    this.image = "",
    this.addActionCount = 0,
    this.addBuyCount = 0,
    this.isAddMoney = false,
    this.isAttack = false,
    this.isDiscard = false,
    this.isPinned = false,
  });

  bool isAddActionCard() {
    return addActionCount > 1;
  }

  bool isAddCardCard() {
    return addCardCount > 1;
  }

  factory CardModel.fromGoogleSheetRow(List<dynamic> row, {Expansion? expansion}) {
    return CardModel(
      nameKr: row[0].toString(),
      nameEng: row[1].toString(),
      expansion: expansion ?? Expansion.kingdom,
      type: CardType.fromString(row[2].toString()),
      price: int.parse(row[3]),
      addCardCount: int.parse(row[4]),
      addActionCount: int.parse(row[5]),
      addBuyCount: int.parse(row[6]),
      isAttack: row[7] == 'T' ? true : false,
      isDiscard: row[8] == 'T' ? true : false,
    );
  }
}

enum CardType {
  action,
  score,
  treasure;

  factory CardType.fromString(String type) {
    switch (type) {
      case "Action":
        return action;
      case "Score":
        return score;
      case "Treasure":
        return treasure;
      default:
        return action;
    }
  }
}

enum Expansion {
  kingdom,
  seaside,
  empire,
  intrigue,
  prosperity,
  allies,
}
