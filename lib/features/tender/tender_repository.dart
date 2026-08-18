import 'tender.dart';

/// Kontrakt: GET /api/tender/list?status=<active|closed>
/// → 200 { "items": [...], "total_count": n }
abstract class TenderApi {
  Future<List<Tender>> fetch({TenderStatus? status});
}

class TenderRepository {
  const TenderRepository(this._api);
  final TenderApi _api;

  Future<List<Tender>> list({TenderStatus? status}) => _api.fetch(status: status);
}
