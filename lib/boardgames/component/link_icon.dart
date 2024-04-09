import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkIcon extends StatelessWidget {
  final String url;

  const LinkIcon({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: const Icon(Icons.link),
    );
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}