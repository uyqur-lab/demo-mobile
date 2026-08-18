import 'package:demo_mobile/features/tender/tender.dart';
import 'package:demo_mobile/features/tender/tender_repository.dart';

/// Loyihada mocking kutubxonasi ishlatilmaydi — fake'lar qo'lda yoziladi
/// (dev-rules.md §4).
class FakeTenderApi implements TenderApi {
  FakeTenderApi({List<Tender>? items}) : _items = items ?? const [];

  final List<Tender> _items;
  bool shouldFail = false;
  TenderStatus? lastRequestedStatus;
  int callCount = 0;

  @override
  Future<List<Tender>> fetch({TenderStatus? status}) async {
    callCount++;
    lastRequestedStatus = status;
    if (shouldFail) throw Exception('tarmoq xatosi');
    if (status == null) return _items;
    return _items.where((t) => t.status == status).toList();
  }
}

const sampleTenders = [
  Tender(id: 1, title: 'Sement', status: TenderStatus.active, amountInTiyin: 1250000000),
  Tender(id: 2, title: 'Armatura', status: TenderStatus.closed, amountInTiyin: 480000000),
  Tender(id: 3, title: "G'isht", status: TenderStatus.active, amountInTiyin: 99900),
];
