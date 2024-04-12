import 'package:csv/csv.dart';
import 'package:daynyong_house_flutter/component/custom_appbar.dart';
import 'package:daynyong_house_flutter/wishlists/component/wishlist_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../component/custom_scaffold.dart';
import 'model/wishlist.dart';

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
    wishlists = loadCocktailsCsvData();
  }

  Future<List<Wishlist>> loadCocktailsCsvData() async {
    final csvDataString =
        await rootBundle.loadString('assets/csv/daynyong-house-wishlists.csv');
    List<List<dynamic>> csvList =
        const CsvToListConverter().convert(csvDataString);
    return csvList.sublist(1).map((row) => Wishlist.fromCsvRow(row)).toList();
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
