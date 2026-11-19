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

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await widget.composition.reportService.getAuditTrail(
      widget.composition.requireStoreId,
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

  String _actorLabel(String? userId) =>
      userId == null || userId.isEmpty ? 'Sin registro' : userId;

  @override
  Widget build(BuildContext context) {
    final trail = _trail;
    return Scaffold(
      appBar: AppBar(title: const Text('Auditoría del día')),
      body: RefreshIndicator(
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
                      return ListTile(
                        key: Key('audit_item_$index'),
                        title: Text(item.summary),
                        subtitle: Text(
                          '${item.type} · ${_actorLabel(item.actorUserId)}',
                        ),
                        isThreeLine: true,
                      );
                    },
                  ),
      ),
    );
  }
}