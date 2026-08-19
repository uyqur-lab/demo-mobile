import 'package:flutter/material.dart';

import 'color_controller.dart';

class ColorScreen extends StatefulWidget {
  const ColorScreen({super.key, required this.controller});

  final ColorController controller;

  @override
  State<ColorScreen> createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final view = widget.controller.view;
    final isError = view.kind == ColorViewKind.error;

    // Ekranga chiqadigan matn: kod bo'lsa kod, aks holda holat matni.
    // Kod HECH QANDAY o'zgartirilmaydi — `#` qo'shilmaydi, registr tegilmaydi
    // (backend.md, dev-rules §10).
    final shown = view.code.isNotEmpty ? view.code : view.text;

    return Scaffold(
      appBar: AppBar(title: const Text('Tasodifiy rang')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GET /api/v1/color — har chaqiruvda yangi hex kod.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: view.kind == ColorViewKind.loading
                  ? null
                  : widget.controller.load,
              child: const Text('Rang ol'),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  key: const Key('color-swatch'),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    // O'lcham va radius kontraktda: 48×48, radius 8.
                    color: view.color ?? Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  shown,
                  key: const Key('color-code'),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 15,
                    color: isError ? Theme.of(context).colorScheme.error : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
