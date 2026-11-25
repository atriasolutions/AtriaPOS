import 'dart:async';

import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';
import '../widgets/companion_lan_status_chip.dart';
import '../widgets/companion_qr_panel.dart';
import 'product_create_screen.dart';

enum _InventoryCloseMode { manual, scan }

class InventoryCloseScreen extends StatefulWidget {
  const InventoryCloseScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<InventoryCloseScreen> createState() => _InventoryCloseScreenState();
}

class _InventoryCloseScreenState extends State<InventoryCloseScreen> {
  InventoryClosePreviewResponse? _preview;
  final Map<String, TextEditingController> _countControllers = {};
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  _InventoryCloseMode _mode = _InventoryCloseMode.manual;
  String? _scanSessionId;
  List<ScanSessionLineDto> _scanLines = [];
  bool _scanBusy = false;
  final _scanCodeController = TextEditingController();
  StreamSubscription<String>? _scanSub;

  @override
  void initState() {
    super.initState();
    unawaited(widget.composition.scannerIngress.start());
    _loadPreview();
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    _scanCodeController.dispose();
    for (final c in _countControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncControllers(InventoryClosePreviewResponse preview) {
    for (final old in _countControllers.values) {
      old.dispose();
    }
    _countControllers.clear();
    for (final item in preview.items) {
      _countControllers[item.productId] = TextEditingController(
        text: '${item.systemStock}',
      );
    }
  }

  Future<void> _loadPreview() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await widget.composition.inventoryService
        .getInventoryClosePreview(widget.composition.requireStoreId);
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<InventoryClosePreviewResponse>(data: final data):
        setState(() {
          _preview = data;
          _syncControllers(data);
          _loading = false;
        });
      case ApiFailure<InventoryClosePreviewResponse>(error: final e):
        setState(() {
          _preview = null;
          _error = e.message;
          _loading = false;
        });
    }
  }

  Future<void> _submit() async {
    final preview = _preview;
    if (preview == null) return;

    final lines = <InventoryCloseLineRequest>[];
    for (final item in preview.items) {
      final controller = _countControllers[item.productId];
      if (controller == null) continue;
      final counted = int.tryParse(controller.text.trim());
      if (counted == null || counted < 0) {
        _snack('Ingrese cantidades válidas para ${item.name}.');
        return;
      }
      lines.add(
        InventoryCloseLineRequest(
          productId: item.productId,
          countedQty: counted,
        ),
      );
    }

    setState(() => _submitting = true);
    final result = await widget.composition.inventoryService.submitInventoryClose(
      widget.composition.requireStoreId,
      InventoryCloseSubmitRequest(lines: lines),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    switch (result) {
      case ApiSuccess<InventoryCloseSubmitResponse>(data: final data):
        final withVariance = data.lines.where((l) => l.variance != 0).toList();
        final summary = withVariance.isEmpty
            ? 'Cierre registrado sin correcciones de stock.'
            : 'Cierre registrado. ${withVariance.length} línea(s) con ajuste.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('inventory_close_success'),
            content: Text(summary),
          ),
        );
        await _loadPreview();
      case ApiFailure<InventoryCloseSubmitResponse>(error: final e):
        _snack(e.message);
    }
  }

  void _listenScanner(bool active) {
    if (active) {
      _scanSub ??=
          widget.composition.scannerIngress.scans.listen(_recordScanCode);
    } else {
      _scanSub?.cancel();
      _scanSub = null;
    }
  }

  Future<void> _startScanSession() async {
    setState(() => _scanBusy = true);
    final result = await widget.composition.scanSessionService.createScanSession(
      widget.composition.requireStoreId,
      const CreateScanSessionRequest(kind: 'countScan'),
    );
    if (!mounted) return;
    setState(() => _scanBusy = false);
    switch (result) {
      case ApiSuccess<ScanSessionResponse>(data: final data):
        setState(() {
          _scanSessionId = data.sessionId;
          _scanLines = data.lines;
        });
        _listenScanner(true);
      case ApiFailure<ScanSessionResponse>(error: final e):
        _snack(e.message);
    }
  }

  Future<void> _recordScanCode(String raw) async {
    final code = raw.trim();
    if (code.isEmpty || _scanSessionId == null || _scanBusy) return;

    setState(() => _scanBusy = true);
    final result = await widget.composition.scanSessionService.recordScan(
      widget.composition.requireStoreId,
      _scanSessionId!,
      RecordScanRequest(code: code),
    );
    if (!mounted) return;
    setState(() => _scanBusy = false);
    _scanCodeController.clear();

    switch (result) {
      case ApiSuccess<ScanSessionResponse>(data: final data):
        setState(() => _scanLines = data.lines);
      case ApiFailure<ScanSessionResponse>(
        statusCode: final statusCode,
        error: final err,
      ):
        if (statusCode == 404 && err.details?['canCreateProduct'] == true) {
          await _offerCreateProduct(code);
        } else {
          _snack(err.message);
        }
    }
  }

  Future<void> _offerCreateProduct(String barcode) async {
    final create = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Producto no encontrado'),
        content: Text('No hay producto para el código $barcode.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cerrar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Crear producto'),
          ),
        ],
      ),
    );
    if (create != true || !mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ProductCreateScreen(
          composition: widget.composition,
          initialBarcode: barcode,
        ),
      ),
    );
  }

  Future<void> _confirmScanSession() async {
    if (_scanSessionId == null) return;
    setState(() => _scanBusy = true);
    final result =
        await widget.composition.scanSessionService.confirmInventoryCountScan(
      widget.composition.requireStoreId,
      _scanSessionId!,
      const ConfirmInventoryCountScanRequest(),
    );
    if (!mounted) return;
    setState(() => _scanBusy = false);

    switch (result) {
      case ApiSuccess<ConfirmInventoryCountScanResponse>(data: final data):
        final withVariance =
            data.lines.where((l) => l.variance != 0).toList();
        final summary = withVariance.isEmpty
            ? 'Conteo confirmado: ${data.lines.length} producto(s), sin ajuste.'
            : 'Conteo confirmado: ${withVariance.length} línea(s) con ajuste.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('inventory_close_scan_success_snackbar'),
            content: Text(summary),
          ),
        );
        _resetScanSession();
        await _loadPreview();
      case ApiFailure<ConfirmInventoryCountScanResponse>(error: final e):
        _snack(e.message);
    }
  }

  Future<void> _cancelScanSession() async {
    if (_scanSessionId == null) {
      _resetScanSession();
      return;
    }
    setState(() => _scanBusy = true);
    await widget.composition.scanSessionService.cancelScanSession(
      widget.composition.requireStoreId,
      _scanSessionId!,
    );
    if (!mounted) return;
    setState(() => _scanBusy = false);
    _resetScanSession();
  }

  void _resetScanSession() {
    _listenScanner(false);
    setState(() {
      _scanSessionId = null;
      _scanLines = [];
    });
  }

  void _onModeChanged(_InventoryCloseMode mode) {
    if (mode == _mode) return;
    if (_mode == _InventoryCloseMode.scan) {
      unawaited(_cancelScanSession());
    }
    setState(() => _mode = mode);
  }

  int? _systemStockFor(String productId) {
    final preview = _preview;
    if (preview == null) return null;
    for (final item in preview.items) {
      if (item.productId == productId) return item.systemStock;
    }
    return null;
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openCompanionQr() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Companion WiFi — Conteo'),
        content: SizedBox(
          width: 320,
          child: SingleChildScrollView(
            child: CompanionQrPanel(
              composition: widget.composition,
              mode: CompanionMode.countScan,
              qrKey: const Key('companion_qr_count'),
              statusKey: const Key('companion_lan_status'),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonal(
            key: const Key('inventory_close_mode_manual'),
            onPressed: () => _onModeChanged(_InventoryCloseMode.manual),
            style: FilledButton.styleFrom(
              backgroundColor: _mode == _InventoryCloseMode.manual
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : null,
            ),
            child: const Text('Manual'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton.tonal(
            key: const Key('inventory_close_mode_scan'),
            onPressed: () => _onModeChanged(_InventoryCloseMode.scan),
            style: FilledButton.styleFrom(
              backgroundColor: _mode == _InventoryCloseMode.scan
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : null,
            ),
            child: const Text('Por escaneo'),
          ),
        ),
      ],
    );
  }

  Widget _buildManualBody(InventoryClosePreviewResponse preview) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            key: const Key('inventory_close_list'),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: preview.items.length,
            itemBuilder: (context, index) {
              final item = preview.items[index];
              final controller = _countControllers[item.productId]!;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        item.name,
                        key: Key('inventory_close_name_${item.productId}'),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        'Stock sistema: ${item.systemStock}',
                        key: Key(
                          'inventory_close_system_${item.productId}',
                        ),
                      ),
                      Text(
                        'Vendidos en turno: ${item.unitsSoldInShift}',
                        key: Key(
                          'inventory_close_sold_${item.productId}',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        key: Key(
                          'inventory_close_count_${item.productId}',
                        ),
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: 'Cantidad contada',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            key: const Key('inventory_close_submit_button'),
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Registrar cierre'),
          ),
        ),
      ],
    );
  }

  Widget _buildScanBody() {
    final sessionActive = _scanSessionId != null;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Solo los productos escaneados se incluirán en el cierre.',
          ),
          const SizedBox(height: 16),
          if (!sessionActive) ...[
            if (widget.composition.companionLanServer != null)
              TextButton.icon(
                key: const Key('companion_qr_count'),
                onPressed: _openCompanionQr,
                icon: const Icon(Icons.qr_code),
                label: const Text('QR companion WiFi'),
              ),
            const SizedBox(height: 8),
            FilledButton(
              key: const Key('inventory_close_scan_start_button'),
              onPressed: _scanBusy ? null : _startScanSession,
              child: const Text('Iniciar conteo por escaneo'),
            ),
          ]
          else ...[
            TextField(
              key: const Key('inventory_close_scan_code_field'),
              controller: _scanCodeController,
              decoration: const InputDecoration(
                labelText: 'Código escaneado',
                border: OutlineInputBorder(),
              ),
              onSubmitted: _recordScanCode,
            ),
            const SizedBox(height: 8),
            if (_scanLines.isEmpty)
              const Text('Escaneé productos para registrar el conteo.')
            else
              ListView.builder(
                key: const Key('inventory_close_scan_lines'),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _scanLines.length,
                itemBuilder: (context, index) {
                  final line = _scanLines[index];
                  final system = _systemStockFor(line.productId);
                  final subtitle = system != null
                      ? 'Stock sistema: $system'
                      : null;
                  return ListTile(
                    title: Text(line.productName),
                    subtitle: subtitle != null ? Text(subtitle) : null,
                    trailing: Text('×${line.quantity}'),
                  );
                },
              ),
            const SizedBox(height: 12),
            FilledButton(
              key: const Key('inventory_close_scan_confirm_button'),
              onPressed: _scanBusy ? null : _confirmScanSession,
              child: const Text('Confirmar conteo'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              key: const Key('inventory_close_scan_cancel_button'),
              onPressed: _scanBusy ? null : _cancelScanSession,
              child: const Text('Cancelar sesión'),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final preview = _preview;
    final noShift = !_loading && preview == null && _error != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Cierre inventario')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : noShift
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _error!,
                      key: const Key('inventory_close_no_shift'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.composition.companionLanServer != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: CompanionLanStatusChip(
                          composition: widget.composition,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: _buildModeSelector(),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _mode == _InventoryCloseMode.manual
                          ? _buildManualBody(preview!)
                          : _buildScanBody(),
                    ),
                  ],
                ),
    );
  }
}