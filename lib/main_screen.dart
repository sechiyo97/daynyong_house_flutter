import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';

import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _imageIndex = 1;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // 이미지를 5초마다 변경합니다.
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _imageIndex++;
        if (_imageIndex > 7) {
          _imageIndex = 1;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // 타이머를 취소하여 메모리 누수를 방지합니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageName = 'assets/images/main_screen_image_$_imageIndex.jpeg';
    return Scaffold(
      appBar: AppBar(
        title: const Text('떼뇽하우스'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(seconds: 1), // 페이드인/아웃에 걸리는 시간
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Image.asset(
              imageName,
              key: ValueKey<int>(_imageIndex),
              fit: BoxFit.cover, // 배경 이미지가 전체 화면을 채우도록 설정합니다.
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text("보드게임 목록"),
                onPressed: () {
                  Get.toNamed("/boardgames");
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text("칵테일 메뉴"),
                onPressed: () {
                  Get.toNamed("/cocktails");
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text("집들이 선물 위시리스트"),
                onPressed: () {
                  Get.toNamed("/wishlists");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
