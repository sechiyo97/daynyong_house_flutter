
import 'package:daynyong_house_flutter/boardgames/component/link_icon.dart';
import 'package:daynyong_house_flutter/restaurants/model/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantTile extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantTile({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasLink = restaurant.link.isBlank == false;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (hasLink) const SizedBox(width: 10),
                if (hasLink)
                  LinkIcon(
                    url: restaurant.link,
                  )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "메인 메뉴: ${restaurant.mainMenu}" ,
            ),
          ],
        ),
      ),
    );
  }
}
