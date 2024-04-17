import 'dart:convert';

import 'package:daynyong_house_flutter/component/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../component/custom_scaffold.dart';
import '../day_nyong_const.dart';
import 'component/cocktail_tile.dart';
import 'model/cocktail.dart';
import 'package:http/http.dart' as http;

class CocktailsScreen extends StatefulWidget {
  const CocktailsScreen({Key? key}) : super(key: key);

  @override
  State<CocktailsScreen> createState() => _CocktailsScreenState();
}

class _CocktailsScreenState extends State<CocktailsScreen> {
  late Future<List<Cocktail>> cocktails;

  @override
  void initState() {
    super.initState();
    cocktails = loadCocktailsFromSheet().then((list) {
      // 알파벳 순으로 정렬
      // list.sort((a, b) => a.base.compareTo(b.base));
      return list;
    });
  }

  Future<List<Cocktail>> loadCocktailsFromSheet() async {
    final url = Uri.parse('$dayNyongSpreadSheet/values/cocktails!A:C?key=$googleApiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body)['values'];
      final List<List<dynamic>> rows = List<List<dynamic>>.from(data);

      rows.removeAt(0);
      return rows.map((row) {
        return Cocktail.fromGoogleSheetRow(row);
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      appBar: CustomAppBar(
        iconColor: Colors.white,
        backgroundColor: Colors.black.withOpacity(0.3),
        title: const Text(
          '칵테일 목록',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Cocktail>>(
        future: cocktails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 40),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return CocktailTile(cocktail: data[index]);
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
