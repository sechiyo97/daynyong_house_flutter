import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../components/card_filter_slider.dart';
import '../const.dart';
import '../model/card_model.dart';

class CardProvider with ChangeNotifier {
  List<CardModel> allCards = [];
  List<CardModel> selectedCards = [];
  SelectedCardsInfo selectedCardsInfo = SelectedCardsInfo();

  CardProvider() {
    _loadAllCards(); // Initial load of cards
  }

  Future<void> _loadAllCards() async {
    List<Expansion> allExpansions = Expansion.values;
    allCards.clear();
    allExpansions.forEach((expansion) async {
      List<CardModel> cardsFromExpansion = await getCardsFromExpansion(expansion);
      allCards.addAll(cardsFromExpansion);
    });
  }

  Future<List<CardModel>> getCardsFromExpansion(Expansion expansion) async {
    final url = Uri.parse('$spreadSheet/values/${expansion.name}!A:J?key=$googleApiKey');
    debugPrint("url is $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body)['values'];
      final List<List<dynamic>> rows = List<List<dynamic>>.from(data);

      rows.removeAt(0);
      return rows.map((row) {
        return CardModel.fromGoogleSheetRow(row, expansion: expansion);
      }).toList();
    } else {
      throw Exception('Failed to load data, ${response.body}');
    }
  }

  void shuffleCards(
      List<Expansion> selectedExpansions,
      CardFilterOption addActionCardOption,
      CardFilterOption attackCardOption,
      CardFilterOption addCardCardOption,
      CardFilterOption discardCardCardOption,
      ) {
    var allCardsCopied = <CardModel>[...allCards].where((card) => selectedExpansions.contains(card.expansion)).toList();
    print("selected $selectedExpansions");
    allCardsCopied.shuffle();
    selectedCardsInfo.reset();

    // 핀 고정
    selectedCards.removeWhere((element) => !element.isPinned);
    int leftCardCount = 10 - selectedCards.length;
    selectedCards.forEach((element) {
      allCardsCopied.remove(element);
      selectedCardsInfo.addCard(element);
    });

    // 사용하지 않음 선택한 경우 관련 카드 모두 제거
    for (var card in allCards) {
      if (addCardCardOption == CardFilterOption.atMostZero) {
        if (card.isAddCardCard()) allCardsCopied.remove(card);
      }
      if (addActionCardOption == CardFilterOption.atMostZero) {
        if (card.isAddActionCard()) allCardsCopied.remove(card);
      }
      if (attackCardOption == CardFilterOption.atMostZero) {
        if (card.isAttack) allCardsCopied.remove(card);
      }
      if (discardCardCardOption == CardFilterOption.atMostZero) {
        if (card.isDiscard) allCardsCopied.remove(card);
      }
    }

    if (addCardCardOption != CardFilterOption.atMostZero) {
      int minCards = addCardCardOption.toCount();
      int left = minCards - selectedCardsInfo.addCardCardCount;
      print("leftCardCount $left");
      if (left > 0) {
        List<CardModel> popAddCardCards = allCardsCopied
            .where((element) => element.isAddCardCard())
            .take(left)
            .toList();
        for (var card in popAddCardCards) {
          print("card.. ${card.nameKr} ${card.addActionCount}");
          selectedCards.add(card);
          selectedCardsInfo.addCard(card);
          allCardsCopied.remove(card);
          leftCardCount--;
        }
      }
    }

    if (addActionCardOption != CardFilterOption.atMostZero) {
      int minCards = addCardCardOption.toCount();
      int left = minCards - selectedCardsInfo.addActionCardCount;
      print("leftActionCards $left");
      if (left > 0) {
        List<CardModel> popAddActionCards = allCardsCopied
            .where((element) => element.isAddActionCard())
            .take(left)
            .toList();
        for (var card in popAddActionCards) {
          print("card.. ${card.nameKr} ${card.addActionCount}");
          selectedCards.add(card);
          selectedCardsInfo.addCard(card);
          allCardsCopied.remove(card);
          leftCardCount--;
        }
      }
    }

    if (attackCardOption != CardFilterOption.atMostZero) {
      int minCards = attackCardOption.toCount();
      int left = minCards - selectedCardsInfo.attackCardCount;
      if (left > 0) {
        List<CardModel> popAttackCards = allCardsCopied
            .where((element) => element.isAttack)
            .take(left)
            .toList();
        for (var card in popAttackCards) {
          selectedCards.add(card);
          selectedCardsInfo.addCard(card);
          allCardsCopied.remove(card);
          leftCardCount--;
        }
      }
    }

    if (discardCardCardOption != CardFilterOption.atMostZero) {
      int minCards = discardCardCardOption.toCount();
      int left = minCards - selectedCardsInfo.discardCardCount;
      print("leftCardCount $left");
      if (left > 0) {
        List<CardModel> popAddCardCards = allCardsCopied
            .where((element) => element.isDiscard)
            .take(left)
            .toList();
        for (var card in popAddCardCards) {
          print("card.. ${card.nameKr} ${card.addActionCount}");
          selectedCards.add(card);
          selectedCardsInfo.addCard(card);
          allCardsCopied.remove(card);
          leftCardCount--;
        }
      }
    }

    print("now leftCardCount $leftCardCount");
    List<CardModel> totalRandomCards =
        allCardsCopied.take(leftCardCount).toList();
    for (var card in totalRandomCards) {
      selectedCards.add(card);
      allCardsCopied.remove(card);
    }

    selectedCards.sort((a, b) {
      return a.price - b.price;
    });

    notifyListeners();
  }
}

class SelectedCardsInfo {
  int addActionCardCount = 0;
  int addCardCardCount = 0;
  int attackCardCount = 0;
  int discardCardCount = 0;

  void addCard(CardModel card) {
    if (card.isAddActionCard()) addActionCardCount++;
    if (card.isAddCardCard()) addCardCardCount++;
    if (card.isAttack) attackCardCount++;
    if (card.isDiscard) discardCardCount++;
  }

  void reset() {
    addActionCardCount = 0;
    addCardCardCount = 0;
    attackCardCount = 0;
  }
}