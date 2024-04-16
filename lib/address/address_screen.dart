import 'package:flutter/material.dart';
import 'package:daynyong_house_flutter/component/custom_appbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

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
              onTap: _openInstagramUrl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset("assets/images/logo_instagram.svg",
                      width: 40, height: 40),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('인스타그램 ', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(
                            '@sechiyo97',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      Text(
                        "https://www.instagram.com/sechiyo97",
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

  void _openInstagramUrl() async {
    Uri uri = Uri.parse(
        'https://www.instagram.com/sechiyo97?igsh=MTN6aHhmZGdkbTdrZg==');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
