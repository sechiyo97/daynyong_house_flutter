import 'package:daynyong_house_flutter/component/custom_appbar.dart';
import 'package:daynyong_house_flutter/restaurants/component/restaurant_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../component/custom_scaffold.dart';
import 'package:csv/csv.dart';

import 'model/restaurant.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  late Future<List<Restaurant>> restaurants;

  @override
  void initState() {
    super.initState();
    restaurants = loadRestaurantsCsvData().then((list) {
      // 알파벳 순으로 정렬
      // list.sort((a, b) => a.base.compareTo(b.base));
      return list;
    });
  }

  Future<List<Restaurant>> loadRestaurantsCsvData() async {
    final csvDataString =
        await rootBundle.loadString('assets/csv/daynyong-house - restaurants.csv');
    List<List<dynamic>> csvList =
        const CsvToListConverter().convert(csvDataString);
    return csvList.sublist(1).map((row) => Restaurant.fromCsvRow(row)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: Text(
          '배달 맛집',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: restaurants,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 40),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return RestaurantTile(restaurant: data[index]);
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
