import 'package:flutter/material.dart';
import 'package:daynyong_house_flutter/cocktails/model/cocktail.dart';

class CocktailTile extends StatefulWidget {
  final Cocktail cocktail;

  const CocktailTile({Key? key, required this.cocktail}) : super(key: key);

  @override
  _CocktailTileState createState() => _CocktailTileState();
}

class _CocktailTileState extends State<CocktailTile> {
  bool _isRecipeVisible = false; // 레시피 표시 여부를 관리하는 플래그

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 이름과 토글 버튼을 양 끝으로 정렬합니다.
              children: [
                Text(
                  widget.cocktail.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton( // 레시피 표시 토글 버튼
                  icon: Icon(_isRecipeVisible ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isRecipeVisible = !_isRecipeVisible; // 레시피 표시 상태를 토글합니다.
                    });
                  },
                ),
              ],
            ),
            Text(widget.cocktail.description), // 항상 보이는 설명 텍스트
            if (_isRecipeVisible) // 레시피 표시 여부에 따라 조건부 렌더링
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  widget.cocktail.recipeDisplayString() ?? '',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
