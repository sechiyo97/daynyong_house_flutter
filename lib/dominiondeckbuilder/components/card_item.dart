import 'package:flutter/material.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

import '../model/card_model.dart';

class CardItem extends StatelessWidget {
  final CardModel card;
  final Function(bool) onPinned;

  const CardItem(
      {super.key,
      required this.card,
      required this.onPinned});

  @override
  Widget build(BuildContext context) {
    String cardNameForFile = card.nameEng
        .toLowerCase()
        .replaceAll("'", "")
        .replaceAll(' ', '_');
    String imagePath =
        "image/card/${card.expansion.name}/img_card_${card.expansion.name}_$cardNameForFile.webp";
    debugPrint("imagePath $imagePath");
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onPinned(card.isPinned);
          },
          child: Icon(card.isPinned ? Typicons.pin : Typicons.pin_outline),
        ),
        Image.asset(
          imagePath,
          height: 200,
        ),
        Text(
          "${card.nameKr} (${card.nameEng})",
          style: TextStyle(
            color: card.isAttack ? Colors.red : Colors.black,
            fontWeight:
                card.isAttack ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          card.expansion.name,
        )
      ],
    );
  }
}
