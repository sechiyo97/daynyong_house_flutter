import 'package:daynyong_house_flutter/boardgames/board_games_screen.dart';
import 'package:daynyong_house_flutter/cocktails/cocktails_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const MainScreen(),
      getPages: [
        GetPage(
          name: '/main',
          page: () => const MainScreen(),
        ),
        GetPage(
          name: '/boardgames',
          page: () => const BoardGamesScreen(),
        ),
        GetPage(
          name: '/cocktails',
          page: () => const CocktailsScreen(),
        ),
      ],
    );
  }
}
