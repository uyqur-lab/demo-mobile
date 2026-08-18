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
    this.errorMessage,
  });

  final TenderListStatus status;
  final List<Tender> items;
  final TenderStatus? filter;
  final String? errorMessage;

  TenderListState copyWith({
    TenderListStatus? status,
    List<Tender>? items,
    TenderStatus? filter,
    bool clearFilter = false,
    String? errorMessage,
  }) {
    return TenderListState(
      status: status ?? this.status,
      items: items ?? this.items,
      filter: clearFilter ? null : (filter ?? this.filter),
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

  /// AC-1: filtr qo'llanganda ro'yxat faqat mos tenderlarni ko'rsatadi.
  /// AC-2: natija bo'sh bo'lsa `empty` holati.
  /// AC-3: xato bo'lsa oldingi ro'yxat saqlanadi.
  Future<void> load({TenderStatus? filter, bool clearFilter = false}) async {
    _emit(_state.copyWith(
      status: TenderListStatus.loading,
      filter: filter,
      clearFilter: clearFilter,
    ));

    try {
      final items = await _repository.list(status: _state.filter);
      _emit(_state.copyWith(
        status: items.isEmpty ? TenderListStatus.empty : TenderListStatus.data,
        items: items,
      ));
    } catch (e) {
      // Oldingi ro'yxat ataylab saqlanadi — foydalanuvchi kontekstni yo'qotmaydi.
      _emit(_state.copyWith(
        status: TenderListStatus.error,
        errorMessage: 'Ro`yxatni yuklab bo`lmadi',
      ));
    }
  }
}
