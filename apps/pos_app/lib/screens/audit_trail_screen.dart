import 'package:core/api/api.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';

class AuditTrailScreen extends StatefulWidget {
  const AuditTrailScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<AuditTrailScreen> createState() => _AuditTrailScreenState();
}

class _AuditTrailScreenState extends State<AuditTrailScreen> {
  AuditTrailResponse? _trail;
  bool _loading = true;
  String? _error;
  late DateTime _fromLocal;
  late DateTime _toLocal;
  bool _filterVentas = true;
  bool _filterInventario = true;
  bool _filterUsuarios = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _fromLocal = DateTime(now.year, now.month, now.day);
    _toLocal = DateTime(now.year, now.month, now.day);
    _refresh();
  }

  static String _ymd(DateTime localMidnight) {
    final y = localMidnight.year.toString().padLeft(4, '0');
    final m = localMidnight.month.toString().padLeft(2, '0');
    final d = localMidnight.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String? _categoriesParam() {
    const allCount = 3;
    final selected = <String>[];
    if (_filterVentas) selected.add('VENTAS');
    if (_filterInventario) selected.add('INVENTARIO');
    if (_filterUsuarios) selected.add('USUARIOS');
    if (selected.isEmpty || selected.length >= allCount) {
      return null;
    }
    return selected.join(',');
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial = isFrom ? _fromLocal : _toLocal;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      final local = DateTime(picked.year, picked.month, picked.day);
      if (isFrom) {
        _fromLocal = local;
      } else {
        _toLocal = local;
      }
    });
  }

  Future<void> _refresh() async {
    if (_toLocal.isBefore(_fromLocal)) {
      setState(() {
        _loading = false;
        _error = null;
      });
      _snack('La fecha hasta no puede ser anterior a desde.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await widget.composition.reportService.getAuditTrail(
      widget.composition.requireStoreId,
      from: _ymd(_fromLocal),
      to: _ymd(_toLocal),
      categories: _categoriesParam(),
    );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<AuditTrailResponse>(data: final data):
        setState(() {
          _trail = data;
          _loading = false;
        });
      case ApiFailure<AuditTrailResponse>(error: final e):
        setState(() {
          _error = e.message;
          _loading = false;
        });
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _actorLabel(String? userId) =>
      userId == null || userId.isEmpty ? 'Sin registro' : userId;

  @override
  Widget build(BuildContext context) {
    final trail = _trail;
    final multiDay =
        trail != null && trail.fromDate != trail.toDate;

    return Scaffold(
      appBar: AppBar(title: const Text('Auditoría')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        key: const Key('audit_trail_from_button'),
                        onPressed: () => _pickDate(isFrom: true),
                        child: Text('Desde: ${_ymd(_fromLocal)}'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        key: const Key('audit_trail_to_button'),
                        onPressed: () => _pickDate(isFrom: false),
                        child: Text('Hasta: ${_ymd(_toLocal)}'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      key: const Key('audit_trail_cat_ventas'),
                      label: const Text('Ventas'),
                      selected: _filterVentas,
                      onSelected: (v) => setState(() => _filterVentas = v),
                    ),
                    FilterChip(
                      key: const Key('audit_trail_cat_inventario'),
                      label: const Text('Inventario'),
                      selected: _filterInventario,
                      onSelected: (v) => setState(() => _filterInventario = v),
                    ),
                    FilterChip(
                      key: const Key('audit_trail_cat_usuarios'),
                      label: const Text('Usuarios'),
                      selected: _filterUsuarios,
                      onSelected: (v) => setState(() => _filterUsuarios = v),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                FilledButton(
                  key: const Key('audit_trail_apply_button'),
                  onPressed: _loading ? null : _refresh,
                  child: const Text('Consultar'),
                ),
              ],
            ),
          ),
          if (trail != null && !_loading && _error == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Período: ${trail.fromDate} — ${trail.toDate}',
                key: const Key('audit_trail_range_label'),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: _loading
                  ? ListView(
                      children: const [
                        SizedBox(height: 120),
                        Center(child: CircularProgressIndicator()),
                      ],
                    )
                  : _error != null
                      ? ListView(
                          children: [
                            const SizedBox(height: 48),
                            Center(child: Text(_error!)),
                          ],
                        )
                      : ListView.builder(
                          key: const Key('audit_trail_list'),
                          padding: const EdgeInsets.all(16),
                          itemCount: trail!.items.length,
                          itemBuilder: (context, index) {
                            final item = trail.items[index];
                            final subtitle = multiDay
                                ? '${item.category} · ${item.type} · ${_actorLabel(item.actorUserId)}\n${item.occurredAt}'
                                : '${item.category} · ${item.type} · ${_actorLabel(item.actorUserId)}';
                            return ListTile(
                              key: Key('audit_item_$index'),
                              title: Text(item.summary),
                              subtitle: Text(subtitle),
                              isThreeLine: multiDay,
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}