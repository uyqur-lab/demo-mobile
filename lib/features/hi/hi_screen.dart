import 'package:flutter/material.dart';

import 'hi_controller.dart';

class HiScreen extends StatefulWidget {
  const HiScreen({super.key, required this.controller});

  final HiController controller;

  @override
  State<HiScreen> createState() => _HiScreenState();
}

class _HiScreenState extends State<HiScreen> {
  final _name = TextEditingController(text: 'Alisher');
  bool _omitName = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    _name.dispose();
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final view = widget.controller.view;
    final scheme = Theme.of(context).colorScheme;
    final isError = view.kind == HiViewKind.error;

    return Scaffold(
      appBar: AppBar(title: const Text('Salomlashish')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'POST /api/v1/hi — ism yuboriladi, hi {name} qaytadi.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _name,
              enabled: !_omitName,
              decoration: const InputDecoration(
                labelText: 'Ism',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _omitName,
              onChanged: (v) => setState(() => _omitName = v),
              title: const Text(
                'name yubormaslik (tana {} bo’ladi)',
                style: TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: view.kind == HiViewKind.loading
                  ? null
                  : () => widget.controller
                      .send(name: _name.text, omitName: _omitName),
              child: const Text('Yubor'),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 52),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isError
                    ? scheme.errorContainer
                    : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                // Trim QILINMAYDI (ISSUE-1). Bo'sh ism uchun kontrakt javobi
                // "hi " — orqasida bo'shliq bilan; ekran uni o'zgartirmaydi.
                // Aks holda bir xil so'rovga FE va MB boshqa natija beradi.
                view.text,
                key: const Key('result'),
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: isError ? scheme.onErrorContainer : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
