import 'package:flutter/material.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uyqur',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF2F6FED)),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF2F6FED),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Uyqur')),
        body: const Center(
          child: Text("Bo'sh ekran. Funksiya hali qo'shilmagan."),
        ),
      ),
    );
  }
}
