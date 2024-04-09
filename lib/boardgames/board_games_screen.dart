import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

import '../component/custom_scaffold.dart';

class BoardGamesScreen extends StatefulWidget {
  const BoardGamesScreen({super.key});

  @override
  State<BoardGamesScreen> createState() => _BoardGamesScreenState();
}

class _BoardGamesScreenState extends State<BoardGamesScreen> {
  Future<List<List<dynamic>>> loadCsvData() async {
    final csvData = await rootBundle.loadString('assets/csv/daynyong-house-boardgames.csv');
    return CsvToListConverter().convert(csvData);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Text('떼뇽하우스 보드게임 목록'),
      ),
      body: FutureBuilder<List<List<dynamic>>>(
        future: loadCsvData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length - 1, // 첫 번째 행(헤더) 제외
              itemBuilder: (context, index) {
                List<dynamic> game = snapshot.data![index + 1]; // 데이터 로우
                return Card(
                  child: ListTile(
                    title: Text(game[0]), // 게임 이름
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('확장: ${game[1]}'),
                        Text('분류: ${game[2]}'),
                        Text('긱웨이트: ${game[3]}'),
                        Text('플레이 인원: ${game[4]}'),
                        Text('베스트 인원: ${game[5]}'),
                        Text('플레이 타임: ${game[6]}'),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
