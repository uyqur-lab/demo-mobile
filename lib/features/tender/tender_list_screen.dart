import 'package:flutter/material.dart';

import '../../core/price_formatter.dart';
import 'tender.dart';
import 'tender_list_controller.dart';

class TenderListScreen extends StatefulWidget {
  const TenderListScreen({super.key, required this.controller});
  final TenderListController controller;

  @override
  State<TenderListScreen> createState() => _TenderListScreenState();
}

class _TenderListScreenState extends State<TenderListScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tenderlar')),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final state = widget.controller.state;
          return Column(
            children: [
              _FilterBar(
                selected: state.filter,
                onChanged: (value) => widget.controller.load(
                  filter: value,
                  clearFilter: value == null,
                ),
              ),
              if (state.status == TenderListStatus.error)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    state.errorMessage ?? 'Xatolik',
                    key: const Key('tender_error_message'),
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              Expanded(child: _body(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _body(TenderListState state) {
    if (state.status == TenderListStatus.loading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == TenderListStatus.empty) {
      return const Center(
        child: Text('Natija topilmadi', key: Key('tender_empty_state')),
      );
    }
    return ListView.builder(
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final tender = state.items[index];
        return ListTile(
          key: Key('tender_${tender.id}'),
          title: Text(tender.title),
          trailing: Text(PriceFormatter.format(tender.amountInTiyin)),
        );
      },
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onChanged});

  final TenderStatus? selected;
  final ValueChanged<TenderStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            key: const Key('filter_active'),
            label: const Text('Faol'),
            selected: selected == TenderStatus.active,
            onSelected: (on) => onChanged(on ? TenderStatus.active : null),
          ),
          const SizedBox(width: 8),
          FilterChip(
            key: const Key('filter_closed'),
            label: const Text('Yopilgan'),
            selected: selected == TenderStatus.closed,
            onSelected: (on) => onChanged(on ? TenderStatus.closed : null),
          ),
        ],
      ),
    );
  }
}
