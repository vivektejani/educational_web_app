
import 'package:flutter/material.dart';

import 'details_web_page.dart';
import 'home_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) =>const HomePage(),
        'details_page': (context) => const DetailWebPage(),
      },
    ),
  );
}