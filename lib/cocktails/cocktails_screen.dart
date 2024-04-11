import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../component/custom_scaffold.dart';
import 'component/cocktail_tile.dart';
import 'model/cocktail.dart';
import 'package:csv/csv.dart';

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
    cocktails = loadCocktailsCsvData().then((list) {
      // 알파벳 순으로 정렬
      // list.sort((a, b) => a.base.compareTo(b.base));
      return list;
    });
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
      body: FutureBuilder<List<Cocktail>>(
        future: cocktails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            // 여기에서 베이스를 기준으로 그룹화하여 UI를 구성합니다.
            return ListView.builder(
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