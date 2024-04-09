import 'package:flutter/material.dart';

import '../model/wishlist.dart';

class WishlistTile extends StatelessWidget {
  final Wishlist wishlist;

  const WishlistTile({Key? key, required this.wishlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wishlist.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              wishlist.description,
            )
          ],
        ),
      ),
    );
  }
}
