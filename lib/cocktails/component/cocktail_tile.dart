import 'package:daynyong_house_flutter/cocktails/model/cocktail.dart';
import 'package:flutter/material.dart';

class CocktailTile extends StatelessWidget {
  final Cocktail cocktail;

  const CocktailTile({Key? key, required this.cocktail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? recipeString = cocktail.recipeDisplayString();
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  cocktail.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(width: 10),
                // Chip(
                //   label: Text('베이스: ${cocktail.base}'),
                //   avatar: Icon(Icons.local_drink, size: 20),
                // ),
              ],
            ),
            if (recipeString != null) Text(
              recipeString,
            ),
            Text(
              cocktail.description,
            )
          ],
        ),
      ),
    );
  }
}
