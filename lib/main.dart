import 'package:daynyong_house_flutter/boardgames/board_games_screen.dart';
import 'package:daynyong_house_flutter/cocktails/cocktails_screen.dart';
import 'package:daynyong_house_flutter/schedule/schedule_screen.dart';
import 'package:daynyong_house_flutter/wishlists/wishlists_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const MainScreen(),
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
        ),
      ),
      title: "떼뇽하우스",
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
        GetPage(
          name: '/wishlists',
          page: () => const WishlistsScreen(),
        ),
        GetPage(
          name: '/schedule',
          page: () => const ScheduleScreen(),
        ),
      ],
    );
  }
}
