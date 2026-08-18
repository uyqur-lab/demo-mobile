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
  Future<List<Tender>> fetch({TenderStatus? status}) async {
    const all = [
      Tender(id: 1, title: 'Sement yetkazish', status: TenderStatus.active, amountInTiyin: 1250000000),
      Tender(id: 2, title: 'Armatura', status: TenderStatus.closed, amountInTiyin: 480000000),
    ];
    if (status == null) return all;
    return all.where((t) => t.status == status).toList();
  }
}
