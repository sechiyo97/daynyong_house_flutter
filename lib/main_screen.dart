import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'component/custom_scaffold.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text('떼뇽하우스'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: const Text("보드게임 목록"),
            onPressed: () {
              Get.toNamed("/boardgames");
            },
          ),
          ElevatedButton(
            child: const Text("칵테일 메뉴"),
            onPressed: () {
              Get.toNamed("/cocktails");
            },
          ),
        ],
      ),
    );
  }
}
