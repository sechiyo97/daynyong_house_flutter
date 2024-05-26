class CardFilterModel {
  int minAddActionCard;
  int minAddCardCard;
  int minAddBuyCard;
  int minAttackCard;

  CardFilterModel({
    this.minAddActionCard = 0,
    this.minAddCardCard = 0,
    this.minAddBuyCard = 0,
    this.minAttackCard = 0,
  });
}

enum CardType {
  action,
  score,
  treasure,
}
