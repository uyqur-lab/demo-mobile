import 'package:flutter/foundation.dart';

import 'tender.dart';
import 'tender_repository.dart';

enum TenderListStatus { initial, loading, data, empty, error }

@immutable
class TenderListState {
  const TenderListState({
    this.status = TenderListStatus.initial,
    this.items = const [],
    this.filter,
    this.from,
    this.to,
    this.query = '',
    this.errorMessage,
  });

  final TenderListStatus status;
  final List<Tender> items;
  final TenderStatus? filter;
  final DateTime? from;
  final DateTime? to;
  final String query;
  final String? errorMessage;

  TenderListState copyWith({
    TenderListStatus? status,
    List<Tender>? items,
    TenderStatus? filter,
    bool clearFilter = false,
    DateTime? from,
    DateTime? to,
    bool clearRange = false,
    String? query,
    String? errorMessage,
  }) {
    return TenderListState(
      status: status ?? this.status,
      items: items ?? this.items,
      filter: clearFilter ? null : (filter ?? this.filter),
      from: clearRange ? null : (from ?? this.from),
      to: clearRange ? null : (to ?? this.to),
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }
}

class TenderListController extends ChangeNotifier {
  TenderListController(this._repository);
  final TenderRepository _repository;

  TenderListState _state = const TenderListState();
  TenderListState get state => _state;

  void _emit(TenderListState next) {
    _state = next;
    notifyListeners();
  }

  /// AC-1: sana oralig'i tanlanganda faqat shu oraliqdagi tenderlar.
  /// AC-2: oraliq teskari bo'lsa so'rov yuborilmaydi.
  /// AC-1: nomida qidiruv matni bor tenderlar ko'rsatiladi.
  /// AC-2: qidiruv katta-kichik harfga sezgir emas.
  void search(String query) {
    _emit(_state.copyWith(query: query));
  }

  /// Qidiruv qo'llangan ro'yxat.
  List<Tender> get visibleItems {
    final q = _state.query.trim().toLowerCase();
    if (q.isEmpty) return _state.items;
    return _state.items
        .where((t) => t.title.toLowerCase().contains(q))
        .toList();
  }

  Future<void> load({
    TenderStatus? filter,
    bool clearFilter = false,
    DateTime? from,
    DateTime? to,
    bool clearRange = false,
  }) async {
    final nextFrom = clearRange ? null : (from ?? _state.from);
    final nextTo = clearRange ? null : (to ?? _state.to);

    if (nextFrom != null && nextTo != null && nextFrom.isAfter(nextTo)) {
      _emit(_state.copyWith(
        status: TenderListStatus.error,
        errorMessage: "Sana oralig'i noto'g'ri",
      ));
      return;
    }

    _emit(_state.copyWith(
      status: TenderListStatus.loading,
      filter: filter,
      clearFilter: clearFilter,
      from: from,
      to: to,
      clearRange: clearRange,
    ));

    try {
      final items = await _repository.list(
        status: _state.filter,
        from: _state.from,
        to: _state.to,
      );
      _emit(_state.copyWith(
        status: items.isEmpty ? TenderListStatus.empty : TenderListStatus.data,
        items: items,
      ));
    } catch (e) {
      _emit(_state.copyWith(
        status: TenderListStatus.error,
        errorMessage: 'Ro`yxatni yuklab bo`lmadi',
      ));
    }
  }
}
