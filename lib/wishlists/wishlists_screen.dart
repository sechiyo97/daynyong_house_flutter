import 'dart:convert';

import 'package:daynyong_house_flutter/component/custom_appbar.dart';
import 'package:daynyong_house_flutter/wishlists/component/wishlist_tile.dart';
import 'package:flutter/material.dart';
import '../component/custom_scaffold.dart';
import '../day_nyong_const.dart';
import 'model/wishlist.dart';
import 'package:http/http.dart' as http;

class WishlistsScreen extends StatefulWidget {
  const WishlistsScreen({Key? key}) : super(key: key);

  @override
  State<WishlistsScreen> createState() => _WishlistsScreenState();
}

class _WishlistsScreenState extends State<WishlistsScreen> {
  late Future<List<Wishlist>> wishlists;

  @override
  void initState() {
    super.initState();
    wishlists = loadWishlistFromSheet();
  }

  Future<List<Wishlist>> loadWishlistFromSheet() async {
    final url = Uri.parse('$dayNyongSpreadSheet/values/wishlist!A:C?key=$googleApiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body)['values'];
      final List<List<dynamic>> rows = List<List<dynamic>>.from(data);

      rows.removeAt(0);
      return rows.map((row) {
        return Wishlist.fromGoogleSheetRow(row);
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: Column(children: [
          Text(
            '집들이 선물 위시리스트',
          ),
          Text(
            '(사람들이 자꾸 뭐 사갈지 물어봐서 만들었어요)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          )
        ]),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Wishlist>>(
              future: wishlists,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      Wishlist wishlist = data[index];
                      return WishlistTile(wishlist: wishlist);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
