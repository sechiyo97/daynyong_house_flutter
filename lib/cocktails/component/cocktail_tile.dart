import 'package:flutter/material.dart';
import 'package:daynyonghouse/cocktails/model/cocktail.dart';

class CocktailTile extends StatefulWidget {
  final Cocktail cocktail;

  const CocktailTile({Key? key, required this.cocktail}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CocktailTileState();
}

class _CocktailTileState extends State<CocktailTile> {
  bool _isRecipeVisible = false; // 레시피 표시 여부를 관리하는 플래그

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              child: Text(
                widget.cocktail.name,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                setState(() {
                  _isRecipeVisible = !_isRecipeVisible; // 레시피 표시 상태를 토글합니다.
                });
              },
            ),
            const SizedBox(
              height: 6,
            ),
            Text(widget.cocktail.description, style: TextStyle(
              color: Colors.white.withOpacity(0.8),
            ),),
            if (_isRecipeVisible) // 레시피 표시 여부에 따라 조건부 렌더링
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  widget.cocktail.recipeDisplayString() ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
