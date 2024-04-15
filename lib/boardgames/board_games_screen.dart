import 'package:daynyong_house_flutter/component/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../component/custom_scaffold.dart';
import 'component/board_game_tile.dart';
import 'model/board_game.dart';

class BoardGamesScreen extends StatefulWidget {
  const BoardGamesScreen({Key? key}) : super(key: key);

  @override
  State<BoardGamesScreen> createState() => _BoardGamesScreenState();
}

class _BoardGamesScreenState extends State<BoardGamesScreen> {
  late Future<List<BoardGame>> boardGames;
  final TextEditingController _searchNameController = TextEditingController();

  List<String> playerCounts = ['전체', '1', '2', '3', '4', '5', '6', '7', '8'];
  String _selectedPlayerCount = '전체';

  List<String> bestForCounts = ['전체', '1', '2', '3', '4', '5', '6', '7', '8'];
  String _selectedBestForCount = '전체';

  List<String> categories = [
    '전체',
    '전략',
    '추상전략',
    '파티',
    '패밀리',
    '퍼즐',
    '테마틱',
    '어린이'
  ];
  String _selectedSearchCategory = '전체';

  List<String> geekWeightCategories = ['전체', '1점대', '2점대', '3점대', '4점대'];
  String _selectedGeekWeight = '전체'; // Default to show all

  final ScrollController _scrollController = ScrollController();
  bool _showSearchOptions = false; // 검색 옵션 표시 상태

  @override
  void initState() {
    super.initState();
    boardGames = loadBoardGameCsvData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  void _scrollListener() {
    setState(() {
      _showSearchOptions = false;
    });
  }

  Future<List<BoardGame>> loadBoardGameCsvData() async {
    final csvDataString = await rootBundle
        .loadString('assets/csv/daynyong-house - boardgames.csv');
    List<List<dynamic>> csvList =
        const CsvToListConverter().convert(csvDataString);
    return csvList.sublist(1).map((row) => BoardGame.fromCsvRow(row)).toList();
  }

  List<BoardGame> filterData(List<BoardGame> data) {
    return data.where((game) {
      bool matchesGeekWeight = true;
      if (_selectedGeekWeight != '전체') {
        double gameGeekWeight = double.tryParse(game.geekWeight) ?? 0;
        int weightFloor =
            int.parse(_selectedGeekWeight[0]); // Assumes format like '1점대'
        matchesGeekWeight =
            (gameGeekWeight >= weightFloor && gameGeekWeight < weightFloor + 1);
      }

      bool matchesName = _searchNameController.text.isEmpty ||
          game.name
              .toLowerCase()
              .contains(_searchNameController.text.toLowerCase());
      bool matchesCategory = _selectedSearchCategory == '전체' ||
          game.category == _selectedSearchCategory;
      bool matchesPlayerCount = true;
      bool matchesBestFor = true;

      // 사용자가 플레이 인원수를 입력한 경우
      if (_selectedPlayerCount != '전체') {
        int? searchCount = int.tryParse(_selectedPlayerCount);
        // 입력 값이 유효한 숫자인 경우
        if (searchCount != null) {
          // game.playerCount가 범위를 나타내는 경우 "3~5"
          if (game.playerCount.contains('~')) {
            var parts = game.playerCount.split('~').map(int.tryParse).toList();
            // 범위의 시작과 끝을 확인
            if (parts[0] != null && parts[1] != null) {
              matchesPlayerCount =
                  searchCount >= parts[0]! && searchCount <= parts[1]!;
            }
          } else {
            // game.playerCount가 단일 숫자인 경우
            matchesPlayerCount = game.playerCount == _selectedPlayerCount;
          }
        }
      }

      // 사용자가 베스트 인원수를 입력한 경우
      if (_selectedBestForCount != '전체') {
        int? searchCount = int.tryParse(_selectedBestForCount);
        // 입력 값이 유효한 숫자인 경우
        if (searchCount != null) {
          // game.playerCount가 범위를 나타내는 경우 "3~5"
          if (game.bestFor.contains('~')) {
            var parts = game.bestFor.split('~').map(int.tryParse).toList();
            // 범위의 시작과 끝을 확인
            if (parts[0] != null && parts[1] != null) {
              matchesBestFor =
                  searchCount >= parts[0]! && searchCount <= parts[1]!;
            }
          } else {
            // game.playerCount가 단일 숫자인 경우
            matchesBestFor = game.bestFor == _selectedBestForCount;
          }
        }
      }

      return matchesName &&
          matchesCategory &&
          matchesPlayerCount &&
          matchesBestFor &&
          matchesGeekWeight;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.black.withOpacity(0.05),
      appBar: CustomAppBar(
        backgroundColor: Colors.black.withOpacity(0.0),
        title: const Text('보드게임 목록'),
        actions: [
          IconButton(
            icon: Icon(_showSearchOptions ? Icons.search_off : Icons.search),
            onPressed: () {
              setState(() {
                _showSearchOptions = !_showSearchOptions; // 검색 옵션 표시 상태 토글
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showSearchOptions) _buildSearchOptions(),
          Expanded(
            child: FutureBuilder<List<BoardGame>>(
              future: boardGames,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var filteredData = filterData(snapshot.data!);
                  return ListView.builder(
                    controller: _scrollController,
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

  Widget _buildSearchOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 10,
        children: [
          TextField(
            controller: _searchNameController,
            decoration: const InputDecoration(
              labelText: '이름으로 검색',
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() {}),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("게임 종류: "),
              DropdownButton<String>(
                value: _selectedSearchCategory,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSearchCategory = value;
                    });
                  }
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("긱 웨이트: "),
              DropdownButton<String>(
                value: _selectedGeekWeight,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedGeekWeight = value;
                    });
                  }
                },
                items: geekWeightCategories
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("플레이 인원: "),
              DropdownButton<String>(
                value: _selectedPlayerCount,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPlayerCount = value;
                    });
                  }
                },
                items:
                    playerCounts.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("베스트 인원: "),
              DropdownButton<String>(
                value: _selectedBestForCount,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedBestForCount = value;
                    });
                  }
                },
                items:
                    bestForCounts.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
