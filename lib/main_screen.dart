import 'dart:async';

import 'package:daynyong_house_flutter/component/custom_appbar.dart';
import 'package:daynyong_house_flutter/component/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _imageIndex = 1;
  late Timer _timer;
  bool _isMenuVisible = false; // 메뉴 표시 상태

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _imageIndex++;
        if (_imageIndex > 6) {
          _imageIndex = 1;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageName = 'assets/images/main_screen_image_$_imageIndex.jpeg';
    return CustomScaffold(
      backgroundColor: Colors.black.withOpacity(0.05),
      appBar: CustomAppBar(
        title: const Text("Day & Nyong & Q"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => setState(() => _isMenuVisible = !_isMenuVisible),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
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
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          AnimatedOpacity(
            opacity: _isMenuVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: _isMenuVisible ? _buildMenu() : Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuButton("보드게임 목록", "/boardgames"),
            const SizedBox(height: 20),
            _buildMenuButton("칵테일 메뉴", "/cocktails"),
            const SizedBox(height: 20),
            _buildMenuButton("위시리스트", "/wishlists"),
            const SizedBox(height: 20),
            _buildMenuButton("배달 맛집", "/restaurants"),
            const SizedBox(height: 20),
            _buildMenuButton("방문 가능 일자", "/schedule"),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String title, String route) {
    return GestureDetector(
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      onTap: () {
        Get.toNamed(route);
      },
    );
  }
}
