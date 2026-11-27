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

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final insights = _insights;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            ],
                          ),
                        ),
                      ),
                      _sectionCard(
                        title: 'Stock bajo',
                        children: insights.lowStock.isEmpty
                            ? [
                                const Text('No hay productos con stock bajo.'),
                              ]
                            : insights.lowStock
                                .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Card(
                                    color: cs.errorContainer.withValues(alpha: 0.2),
                                    child: ListTile(
                                      key: Key(
                                        'stock_insights_low_${item.productId}',
                                      ),
                                      minVerticalPadding: 12,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 4,
                                      ),
                                      title: Text(item.name),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Stock ${item.stock} · umbral ${item.lowStockThreshold}',
                                            style: theme.textTheme.bodyLarge,
                                          ),
                                          const SizedBox(height: 6),
                                          Chip(
                                            avatar: Icon(
                                              Icons.warning_amber_outlined,
                                              size: 18,
                                              color: cs.onErrorContainer,
                                            ),
                                            label: const Text('Stock bajo'),
                                            visualDensity: VisualDensity.compact,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            backgroundColor: cs.errorContainer,
                                          ),
                                        ],
                                      ),
                                      trailing: Text(
                                        '\$${item.salePriceClp}',
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                .toList(),
                      ),
                      _sectionCard(
                        title: 'Más vendidos',
                        children: insights.topSellers.isEmpty
                            ? [
                                const Text('Sin ventas en el período.'),
                              ]
                            : insights.topSellers
                                .map(
                                (item) => Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    key: Key(
                                      'stock_insights_top_${item.productId}',
                                    ),
                                    minVerticalPadding: 12,
                                    title: Text(item.name),
                                    trailing: Text(
                                      '${item.unitsSold} u.',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                              )
                                .toList(),
                      ),
                    ],
                  ),
      ),
    );
  }
}