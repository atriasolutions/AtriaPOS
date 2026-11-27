import 'dart:async';

import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';
import '../widgets/companion_lan_status_chip.dart';
import '../widgets/companion_qr_panel.dart';
import '../theme/atria_touch_targets.dart';
import '../widgets/inventory_count_line_tile.dart';
import '../widgets/operation_bottom_bar.dart';
import '../widgets/operation_mode_segment.dart';
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
      _countControllers[item.productId] = TextEditingController()
        ..addListener(_onCountFieldsChanged);
    }
  }

  void _onCountFieldsChanged() {
    if (mounted) setState(() {});
  }

  int? _countedQtyForManual(String productId) {
    final text = _countControllers[productId]?.text.trim() ?? '';
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  String? get _manualDisabledHint {
    if (_manualCanSubmit) return null;
    final preview = _preview;
    if (preview == null || preview.items.isEmpty) {
      return 'No hay productos para contar.';
    }
    return 'Complete la cantidad contada de cada producto.';
  }

  ({int contado, int sinContar, int diferencias, int total}) _summaryCounts() {
    final preview = _preview;
    if (preview == null) {
      return (contado: 0, sinContar: 0, diferencias: 0, total: 0);
    }
    var contado = 0;
    var sinContar = 0;
    var diferencias = 0;
    for (final item in preview.items) {
      final qty = _mode == _InventoryCloseMode.manual
          ? _countedQtyForManual(item.productId)
          : _countedQtyFromScan(item.productId);
      switch (resolveInventoryCountLineStatus(item.systemStock, qty).status) {
        case InventoryCountLineStatus.sinContar:
          sinContar++;
        case InventoryCountLineStatus.contado:
          contado++;
        case InventoryCountLineStatus.diferencias:
          diferencias++;
      }
    }
    return (
      contado: contado,
      sinContar: sinContar,
      diferencias: diferencias,
      total: preview.items.length,
    );
  }

  bool get _manualCanSubmit {
    final preview = _preview;
    if (preview == null || _submitting) return false;
    if (preview.items.isEmpty) return false;
    for (final item in preview.items) {
      final qty = _countedQtyForManual(item.productId);
      if (qty == null || qty < 0) return false;
    }
    return true;
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
        final preview = _preview;
        final sinContar = preview == null
            ? 0
            : preview.items
                .where((i) => _countedQtyFromScan(i.productId) == null)
                .length;
        final base = withVariance.isEmpty
            ? 'Conteo confirmado: ${data.lines.length} producto(s), sin ajuste.'
            : 'Conteo confirmado: ${withVariance.length} línea(s) con ajuste.';
        final summary = sinContar > 0
            ? '$base Quedan $sinContar sin contar en el catálogo.'
            : base;
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

  int? _countedQtyFromScan(String productId) {
    var total = 0;
    var found = false;
    for (final line in _scanLines) {
      if (line.productId == productId) {
        total += line.quantity;
        found = true;
      }
    }
    return found ? total : null;
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

  Widget _buildSummaryBar() {
    final s = _summaryCounts();
    final theme = Theme.of(context);
    return Container(
      key: const Key('inventory_close_summary'),
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Contados ${s.contado} / ${s.total} · Sin contar ${s.sinContar} · Diferencias ${s.diferencias}',
        style: theme.textTheme.titleSmall,
      ),
    );
  }

  Widget _buildManualBody(InventoryClosePreviewResponse preview) {
    return ListView.builder(
      key: const Key('inventory_close_list'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: preview.items.length,
      itemBuilder: (context, index) {
        final item = preview.items[index];
        final controller = _countControllers[item.productId]!;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InventoryCountLineTile(
            productId: item.productId,
            name: item.name,
            systemStock: item.systemStock,
            unitsSoldInShift: item.unitsSoldInShift,
            countedQty: _countedQtyForManual(item.productId),
            countField: InventoryCountLineTile.countedField(
              fieldKey: Key('inventory_close_count_${item.productId}'),
              controller: controller,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScanBody() {
    final sessionActive = _scanSessionId != null;
    final preview = _preview;
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
              style: touchPrimaryButtonStyle(Theme.of(context)),
              child: const Text('Iniciar conteo por escaneo'),
            ),
          ]
          else ...[
            TextField(
              key: const Key('inventory_close_scan_code_field'),
              controller: _scanCodeController,
              decoration: touchTextFieldDecoration(labelText: 'Código escaneado'),
              onSubmitted: _recordScanCode,
            ),
            const SizedBox(height: 8),
            if (_scanLines.isEmpty)
              const Text('Escaneé productos para registrar el conteo.')
            else
              Text(
                '${_scanLines.length} lectura(s) en la sesión.',
              ),
            if (preview != null && preview.items.isNotEmpty) ...[
              const SizedBox(height: 12),
              ListView.builder(
                key: const Key('inventory_close_scan_catalog'),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: preview.items.length,
                itemBuilder: (context, index) {
                  final item = preview.items[index];
                  return InventoryCountLineTile(
                    productId: item.productId,
                    name: item.name,
                    systemStock: item.systemStock,
                    unitsSoldInShift: item.unitsSoldInShift,
                    countedQty: _countedQtyFromScan(item.productId),
                  );
                },
              ),
            ],
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
                      child: OperationModeSegment(
                        manualKey: const Key('inventory_close_mode_manual'),
                        scanKey: const Key('inventory_close_mode_scan'),
                        scanSelected: _mode == _InventoryCloseMode.scan,
                        onChanged: (scan) => _onModeChanged(
                          scan
                              ? _InventoryCloseMode.scan
                              : _InventoryCloseMode.manual,
                        ),
                      ),
                    ),
                    _buildSummaryBar(),
                    Expanded(
                      child: _mode == _InventoryCloseMode.manual
                          ? _buildManualBody(preview!)
                          : _buildScanBody(),
                    ),
                    if (_mode == _InventoryCloseMode.manual)
                      OperationBottomBar(
                        primaryKey: const Key('inventory_close_submit_button'),
                        primaryLabel: 'Registrar cierre',
                        onPrimary: _manualCanSubmit ? _submit : null,
                        primaryBusy: _submitting,
                        disabledHint: _manualDisabledHint,
                      )
                    else if (_scanSessionId != null)
                      OperationBottomBar(
                        primaryKey:
                            const Key('inventory_close_scan_confirm_button'),
                        primaryLabel: 'Confirmar conteo',
                        onPrimary:
                            !_scanBusy && _scanLines.isNotEmpty
                                ? _confirmScanSession
                                : null,
                        primaryBusy: _scanBusy,
                        disabledHint: _scanLines.isEmpty
                            ? 'Escanee al menos un producto.'
                            : null,
                        secondary: OutlinedButton(
                          key: const Key('inventory_close_scan_cancel_button'),
                          onPressed: _scanBusy ? null : _cancelScanSession,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(kMinTouchHeight),
                          ),
                          child: const Text('Cancelar sesión'),
                        ),
                      ),
                  ],
                ),
    );
  }
}