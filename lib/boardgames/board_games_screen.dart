import 'package:daynyong_house_flutter/boardgames/component/board_game_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

import '../component/custom_scaffold.dart';
import 'model/board_game.dart';

class BoardGamesScreen extends StatefulWidget {
  const BoardGamesScreen({super.key});

  @override
  State<BoardGamesScreen> createState() => _BoardGamesScreenState();
}

class _BoardGamesScreenState extends State<BoardGamesScreen> {
  late Future<List<BoardGame>> boardGames;
  final TextEditingController _searchController = TextEditingController();
  String _selectedSearchType = '이름'; // 검색 기준 초기값

  @override
  void initState() {
    super.initState();
    boardGames = loadBoardGameCsvData();
  }

  Future<List<BoardGame>> loadBoardGameCsvData() async {
    final csvDataString = await rootBundle.loadString('assets/csv/daynyong-house-boardgames.csv');
    List<List<dynamic>> csvList = const CsvToListConverter().convert(csvDataString);
    return csvList.sublist(1).map((row) => BoardGame.fromCsvRow(row)).toList();
  }

  List<BoardGame> filterData(List<BoardGame> data, String searchQuery) {
    if (searchQuery.isEmpty) return data;
    return data.where((game) {
      switch (_selectedSearchType) {
        case '이름':
          return game.name.toString().toLowerCase().contains(searchQuery.toLowerCase());
        case '분류':
          return game.category.toString().toLowerCase().contains(searchQuery.toLowerCase());
        case '플레이 인원':
          return game.playerCount
              .toString()
              .split('~')
              .any((range) => range.contains(searchQuery));
        case '베스트 인원':
          return game.bestFor
              .toString()
              .split('~')
              .any((range) => range.contains(searchQuery));
        default:
          return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text('보드게임 목록'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '검색',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: _selectedSearchType,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSearchType = value;
                  });
                }
              },
              items: <String>['이름', '분류', '플레이 인원', '베스트 인원']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<BoardGame>>(
              future: boardGames,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var filteredData = filterData(snapshot.data!.sublist(1), _searchController.text);
                  return ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      BoardGame game = filteredData[index];
                      return BoardGameTile(game: game);
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
