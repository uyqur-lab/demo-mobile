import 'package:flutter/material.dart';

import 'features/hi/hi_api.dart';
import 'features/hi/hi_controller.dart';
import 'features/hi/hi_screen.dart';

void main() => runApp(DemoApp(controller: HiController(HttpHiApi())));

class DemoApp extends StatelessWidget {
  const DemoApp({super.key, required this.controller});

  final HiController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uyqur',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF2F6FED)),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF2F6FED),
      ),
      home: HiScreen(controller: controller),
    );
  }
}
