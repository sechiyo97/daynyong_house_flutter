import 'package:flutter/material.dart';

import '../model/board_game.dart';

class BoardGameTile extends StatelessWidget {
  final BoardGame game;

  const BoardGameTile({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              game.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                if (game.expansion.isNotEmpty)
                  Chip(
                    label: Text('확장: ${game.expansion}'),
                    avatar: Icon(Icons.extension, size: 20),
                  ),
                Chip(
                  label: Text('분류: ${game.category}'),
                  avatar: Icon(Icons.category, size: 20),
                ),
                Chip(
                  label: Text('긱웨이트: ${game.geekWeight}'),
                  avatar: Icon(Icons.dashboard_customize, size: 20),
                ),
                Chip(
                  label: Text('플레이 인원: ${game.playerCount}'),
                  avatar: Icon(Icons.group, size: 20),
                ),
                Chip(
                  label: Text('베스트 인원: ${game.bestFor}'),
                  avatar: Icon(Icons.star, size: 20),
                ),
                Chip(
                  label: Text('플레이 타임: ${game.playTime}'),
                  avatar: Icon(Icons.timer, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
