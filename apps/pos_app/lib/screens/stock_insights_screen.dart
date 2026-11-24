import 'package:core/api/api.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';

class StockInsightsScreen extends StatefulWidget {
  const StockInsightsScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<StockInsightsScreen> createState() => _StockInsightsScreenState();
}

class _StockInsightsScreenState extends State<StockInsightsScreen> {
  StockInsightsResponse? _insights;
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
    final result = await widget.composition.reportService.getStockInsights(
      widget.composition.requireStoreId,
    );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<StockInsightsResponse>(data: final data):
        setState(() {
          _insights = data;
          _loading = false;
        });
      case ApiFailure<StockInsightsResponse>(error: final e):
        setState(() {
          _error = e.message;
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final insights = _insights;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Stock insights')),
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
                        'Al ${insights!.asOfDate}',
                        key: const Key('stock_insights_as_of'),
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Período ranking: ${insights.periodDays} días. '
                        'Umbral default: ${insights.defaultLowStockThreshold} u.',
                        key: const Key('stock_insights_period'),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Stock bajo',
                        style: theme.textTheme.titleSmall,
                      ),
                      if (insights.lowStock.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('No hay productos con stock bajo.'),
                        )
                      else
                        ...insights.lowStock.map(
                          (item) => ListTile(
                            key: Key('stock_insights_low_${item.productId}'),
                            title: Text(item.name),
                            subtitle: Text(
                              'Stock ${item.stock} · umbral ${item.lowStockThreshold}',
                            ),
                            trailing: Text('\$${item.salePriceClp}'),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Text(
                        'Más vendidos',
                        style: theme.textTheme.titleSmall,
                      ),
                      if (insights.topSellers.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Sin ventas en el período.',
                          ),
                        )
                      else
                        ...insights.topSellers.map(
                          (item) => ListTile(
                            key: Key('stock_insights_top_${item.productId}'),
                            title: Text(item.name),
                            trailing: Text('${item.unitsSold} u.'),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }
}