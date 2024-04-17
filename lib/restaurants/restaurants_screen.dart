import 'package:daynyong_house_flutter/component/custom_appbar.dart';
import 'package:daynyong_house_flutter/day_nyong_const.dart';
import 'package:daynyong_house_flutter/restaurants/component/restaurant_tile.dart';
import 'package:flutter/material.dart';
import '../component/custom_scaffold.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    restaurants = loadRestaurantsFromSheet().then((list) {
      // 알파벳 순으로 정렬
      // list.sort((a, b) => a.base.compareTo(b.base));
      return list;
    });
  }

  Future<List<Restaurant>> loadRestaurantsFromSheet() async {
    final url = Uri.parse('$dayNyongSpreadSheet/values/restaurants!A:C?key=$googleApiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body)['values'];
      final List<List<dynamic>> rows = List<List<dynamic>>.from(data);

      rows.removeAt(0);
      return rows.map((row) {
        return Restaurant.fromGoogleSheetRow(row);
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
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
