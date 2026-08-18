import 'package:demo_mobile/features/tender/tender.dart';
import 'package:demo_mobile/features/tender/tender_repository.dart';

/// Loyihada mocking kutubxonasi ishlatilmaydi — fake'lar qo'lda yoziladi
/// (dev-rules.md §4).
class FakeTenderApi implements TenderApi {
  FakeTenderApi({List<Tender>? items}) : _items = items ?? const [];

  final List<Tender> _items;
  bool shouldFail = false;
  TenderStatus? lastRequestedStatus;
  DateTime? lastFrom;
  DateTime? lastTo;
  int callCount = 0;

  @override
  Future<List<Tender>> fetch({TenderStatus? status, DateTime? from, DateTime? to}) async {
    callCount++;
    lastRequestedStatus = status;
    lastFrom = from;
    lastTo = to;
    if (shouldFail) throw Exception('tarmoq xatosi');

    return _items.where((t) {
      if (status != null && t.status != status) return false;
      if (from != null && t.createdAt.isBefore(from)) return false;
      if (to != null && t.createdAt.isAfter(to)) return false;
      return true;
    }).toList();
  }
}

final sampleTenders = [
  Tender(id: 1, title: 'Sement', status: TenderStatus.active, amountInTiyin: 1250000000, createdAt: DateTime(2026, 8, 1)),
  Tender(id: 2, title: 'Armatura', status: TenderStatus.closed, amountInTiyin: 480000000, createdAt: DateTime(2026, 8, 10)),
  Tender(id: 3, title: "G'isht", status: TenderStatus.active, amountInTiyin: 99900, createdAt: DateTime(2026, 8, 20)),
];
