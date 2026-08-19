import 'package:flutter/material.dart';

import 'features/color/color_api.dart';
import 'features/color/color_controller.dart';
import 'features/color/color_screen.dart';
import 'features/hi/hi_api.dart';
import 'features/hi/hi_controller.dart';
import 'features/hi/hi_screen.dart';

/// Server manzili. Standart qiymat kontraktdagi (backend.md), lekin lokal
/// mashinada 3000 porti band bo'lishi mumkin. Shunda:
///
///   flutter run --dart-define=API_BASE=http://localhost:3001
///
/// Bu CU-86eyp4nmg dagi QA topilmasidan chiqdi: o'shanda simulyatorda
/// uchdan-uchgacha tekshirib bo'lmagan edi.
const apiBase = String.fromEnvironment(
  'API_BASE',
  defaultValue: 'http://localhost:3000',
);

void main() {
  runApp(
    DemoApp(
      hi: HiController(HttpHiApi(baseUrl: apiBase)),
      color: ColorController(HttpColorApi(baseUrl: apiBase)),
    ),
  );
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key, required this.hi, required this.color});

  final HiController hi;
  final ColorController color;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uyqur',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF2F6FED)),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF2F6FED),
      ),
      home: _Home(hi: hi, color: color),
    );
  }
}

/// Ikki ekran orasida almashish. Demo uchun eng sodda yo'l.
class _Home extends StatefulWidget {
  const _Home({required this.hi, required this.color});

  final HiController hi;
  final ColorController color;

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _index == 0
          ? HiScreen(controller: widget.hi)
          : ColorScreen(controller: widget.color),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.waving_hand), label: 'Salom'),
          NavigationDestination(icon: Icon(Icons.palette), label: 'Rang'),
        ],
      ),
    );
  }
}
