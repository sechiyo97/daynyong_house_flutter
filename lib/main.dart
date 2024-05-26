import 'package:daynyonghouse/boardgames/board_games_screen.dart';
import 'package:daynyonghouse/cocktails/cocktails_screen.dart';
import 'package:daynyonghouse/restaurants/restaurants_screen.dart';
import 'package:daynyonghouse/schedule/schedule_screen.dart';
import 'package:daynyonghouse/wishlists/wishlists_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'address/address_screen.dart';
import 'dominiondeckbuilder/dominion_screen.dart';
import 'dominiondeckbuilder/providers/card_provider.dart';
import 'main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return CardProvider();
      },
      child: GetMaterialApp(
        home: const MainScreen(),
        theme: ThemeData(
          fontFamily: 'Noto Sans',
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
            name: '/restaurants',
            page: () => const RestaurantsScreen(),
          ),
          GetPage(
            name: '/schedule',
            page: () => const ScheduleScreen(),
          ),
          GetPage(
            name: '/address',
            page: () => const AddressScreen(),
          ),
          GetPage(
            name: '/dominion',
            page: () => const DominionScreen(),
          ),
        ],
      ),
    );
  }
}
