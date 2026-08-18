import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'features/status/server_status.dart';

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
    final statusController = ServerStatusController(const HttpStatusApi());
    return MaterialApp(
      title: 'Uyqur demo',
      home: TenderListScreen(
        controller: controller,
        statusController: statusController,
      ),
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


/// Kontrakt: uyqur-lab/contracts → GET /api/status
/// Simulyatorda host mashina `localhost` orqali ko'rinadi.
class HttpStatusApi implements StatusApi {
  const HttpStatusApi({this.baseUrl = 'http://localhost:3000'});
  final String baseUrl;

  @override
  Future<String> fetchStatus() async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 3);
    try {
      final request = await client.getUrl(Uri.parse('$baseUrl/api/status'));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      return (jsonDecode(body) as Map<String, dynamic>)['status'] as String;
    } finally {
      client.close();
    }
  }
}
