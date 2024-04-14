import 'package:daynyong_house_flutter/component/custom_appbar.dart';
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
    final csvDataString =
        await rootBundle.loadString('assets/csv/daynyong-house - cocktails.csv');
    List<List<dynamic>> csvList =
        const CsvToListConverter().convert(csvDataString);
    return csvList.sublist(1).map((row) => Cocktail.fromCsvRow(row)).toList();
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
