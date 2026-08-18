import 'tender.dart';

/// Kontrakt: GET /api/tender/list?status=<active|closed>&date_from=&date_to=
/// → 200 { "items": [...], "total_count": n }
abstract class TenderApi {
  Future<List<Tender>> fetch({TenderStatus? status, DateTime? from, DateTime? to});
}

class TenderRepository {
  const TenderRepository(this._api);
  final TenderApi _api;

  Future<List<Tender>> list({TenderStatus? status, DateTime? from, DateTime? to}) =>
      _api.fetch(status: status, from: from, to: to);
}
