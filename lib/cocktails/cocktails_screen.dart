import 'package:csv/csv.dart';
import 'package:daynyong_house_flutter/cocktails/component/cocktail_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../component/custom_scaffold.dart';
import 'model/cocktail.dart';

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
    cocktails = loadCocktailsCsvData();
  }

  Future<List<Cocktail>> loadCocktailsCsvData() async {
    final csvDataString = await rootBundle.loadString('assets/csv/daynyong-house-cocktails.csv');
    List<List<dynamic>> csvList = const CsvToListConverter().convert(csvDataString);
    return csvList.sublist(1).map((row) => Cocktail.fromCsvRow(row)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text('칵테일 목록'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Cocktail>>(
              future: cocktails,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      Cocktail cocktail = data[index];
                      return CocktailTile(cocktail: cocktail);
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