import 'package:core/api/api.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';

class DailySalesScreen extends StatefulWidget {
  const DailySalesScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<DailySalesScreen> createState() => _DailySalesScreenState();
}

class _DailySalesScreenState extends State<DailySalesScreen> {
  DailySalesReportResponse? _report;
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
    final result = await widget.composition.reportService.getDailySales(
      widget.composition.requireStoreId,
    );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<DailySalesReportResponse>(data: final data):
        setState(() {
          _report = data;
          _loading = false;
        });
      case ApiFailure<DailySalesReportResponse>(error: final e):
        setState(() {
          _error = e.message;
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = _report;
    return Scaffold(
      appBar: AppBar(title: const Text('Ventas del día')),
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
                : ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Text(
                        'Fecha: ${report!.date}',
                        key: const Key('daily_report_date'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      _MetricTile(
                        label: 'Total ventas',
                        value: '\$${report.salesTotalClp}',
                        valueKey: const Key('daily_report_total'),
                      ),
                      _MetricTile(
                        label: 'Transacciones',
                        value: '${report.transactionCount}',
                        valueKey: const Key('daily_report_count'),
                      ),
                      _MetricTile(
                        label: 'Ticket promedio',
                        value: '\$${report.averageTicketClp}',
                        valueKey: const Key('daily_report_average'),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.valueKey,
  });

  final String label;
  final String value;
  final Key valueKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: ListTile(
          title: Text(label),
          trailing: Text(
            value,
            key: valueKey,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}