import 'package:flutter/material.dart';
import 'package:daynyonghouse/component/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../day_nyong_const.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('찾아오시는 길'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("주소는 개인정보라 연락주세요 ㅋㅋ"),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _openKakaoTalkOpenChat,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/image/logo_kakaotalk_large.png",
                      width: 40, height: 40),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('카카오톡 ', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(
                            '@떼뇽하우스',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      Text(
                        dayNyongOpenChatLink,
                        style: TextStyle(decoration: TextDecoration.underline),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openKakaoTalkOpenChat() async {
    Uri uri = Uri.parse(dayNyongOpenChatLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
