import 'package:flutter/material.dart';

import 'features/tender/tender.dart';
import 'features/tender/tender_list_controller.dart';
import 'features/tender/tender_list_screen.dart';
import 'features/tender/tender_repository.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TenderListController(
      const TenderRepository(_InMemoryTenderApi()),
    );
    return MaterialApp(
      title: 'Uyqur demo',
      home: TenderListScreen(controller: controller),
    );
  }
}

class _InMemoryTenderApi implements TenderApi {
  const _InMemoryTenderApi();

  @override
  Future<List<Tender>> fetch({TenderStatus? status, DateTime? from, DateTime? to}) async {
    final all = [
      Tender(id: 1, title: 'Sement yetkazish', status: TenderStatus.active, amountInTiyin: 1250000000, createdAt: DateTime(2026, 8, 1)),
      Tender(id: 2, title: 'Armatura', status: TenderStatus.closed, amountInTiyin: 480000000, createdAt: DateTime(2026, 8, 10)),
    ];
    return all.where((t) {
      if (status != null && t.status != status) return false;
      if (from != null && t.createdAt.isBefore(from)) return false;
      if (to != null && t.createdAt.isAfter(to)) return false;
      return true;
    }).toList();
  }
}
