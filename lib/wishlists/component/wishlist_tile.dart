import 'dart:io';

import 'package:daynyong_house_flutter/boardgames/component/link_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/wishlist.dart';

class WishlistTile extends StatelessWidget {
  final Wishlist wishlist;

  const WishlistTile({Key? key, required this.wishlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasLink = wishlist.link?.isBlank == false;
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
                  wishlist.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (hasLink) const SizedBox(width: 10),
                if (hasLink)
                  LinkIcon(
                    url: wishlist.link!,
                  )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              wishlist.description,
            ),
          ],
        ),
      ),
    );
  }
}
