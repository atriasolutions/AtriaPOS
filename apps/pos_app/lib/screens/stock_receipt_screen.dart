import 'dart:async';

import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';
import '../widgets/companion_lan_status_chip.dart';
import '../widgets/companion_qr_panel.dart';
import 'product_create_screen.dart';

enum _StockReceiptMode { manual, scan }

class StockReceiptScreen extends StatefulWidget {
  const StockReceiptScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<StockReceiptScreen> createState() => _StockReceiptScreenState();
}

class _StockReceiptScreenState extends State<StockReceiptScreen> {
  final _searchController = TextEditingController();
  final _quantityController = TextEditingController();
  final _guideController = TextEditingController();
  final _lotController = TextEditingController();
  final _scanCodeController = TextEditingController();
  String? _selectedProductId;
  String? _selectedProductName;
  int? _selectedStock;
  List<ProductSearchItem> _searchResults = [];
  bool _loading = false;
  bool _submitting = false;

  _StockReceiptMode _mode = _StockReceiptMode.manual;
  String? _scanSessionId;
  List<ScanSessionLineDto> _scanLines = [];
  bool _scanBusy = false;
  StreamSubscription<String>? _scanSub;

  @override
  void initState() {
    super.initState();
    unawaited(widget.composition.scannerIngress.start());
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    _searchController.dispose();
    _quantityController.dispose();
    _guideController.dispose();
    _lotController.dispose();
    _scanCodeController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.length < 2) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _loading = true);
    final result = await widget.composition.productService.searchProducts(
      widget.composition.requireStoreId,
      query,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (result case ApiSuccess<SearchProductsResponse>(data: final data)) {
      setState(() => _searchResults = data.items);
    }
  }

  void _selectProduct(ProductSearchItem product) {
    setState(() {
      _selectedProductId = product.id;
      _selectedProductName = product.name;
      _selectedStock = product.stock;
      _searchResults = [];
      _searchController.text = product.name;
    });
  }

  bool _validateForm() {
    if (_selectedProductId == null) {
      _snack('Seleccione un producto.');
      return false;
    }
    final quantity = int.tryParse(_quantityController.text.trim());
    if (quantity == null || quantity <= 0) {
      _snack('Ingrese una cantidad mayor a cero.');
      return false;
    }
    final guide = _guideController.text.trim();
    final lot = _lotController.text.trim();
    if (guide.isEmpty) {
      _snack('Ingrese la referencia de guía.');
      return false;
    }
    if (lot.isEmpty) {
      _snack('Ingrese la referencia de lote.');
      return false;
    }
    return true;
  }

  Future<void> _submit() async {
    if (!_validateForm()) return;
    final productId = _selectedProductId!;
    final quantity = int.parse(_quantityController.text.trim());
    final guide = _guideController.text.trim();
    final lot = _lotController.text.trim();

    setState(() => _submitting = true);
    final result = await widget.composition.inventoryService.recordStockReceipt(
      widget.composition.requireStoreId,
      productId,
      StockReceiptRequest(
        quantity: quantity,
        guideRef: guide,
        lotRef: lot,
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    switch (result) {
      case ApiSuccess<StockReceiptResponse>(data: final data):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('stock_receipt_success_snackbar'),
            content: Text(
              'Ingreso registrado: ${data.stock} u. '
              'Guía ${data.guideRef}, lote ${data.lotRef}.',
            ),
          ),
        );
        setState(() {
          _selectedStock = data.stock;
          _quantityController.clear();
        });
      case ApiFailure<StockReceiptResponse>(error: final e):
        _snack(e.message);
    }
  }

  bool _validateGuideLot() {
    if (_guideController.text.trim().isEmpty) {
      _snack('Ingrese la referencia de guía.');
      return false;
    }
    if (_lotController.text.trim().isEmpty) {
      _snack('Ingrese la referencia de lote.');
      return false;
    }
    return true;
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
    if (!_validateGuideLot()) return;
    setState(() => _scanBusy = true);
    final result = await widget.composition.scanSessionService.createScanSession(
      widget.composition.requireStoreId,
      CreateScanSessionRequest(
        kind: 'receiptScan',
        guideRef: _guideController.text.trim(),
        lotRef: _lotController.text.trim(),
      ),
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
        await widget.composition.scanSessionService.confirmScanSession(
      widget.composition.requireStoreId,
      _scanSessionId!,
      const ConfirmScanSessionRequest(),
    );
    if (!mounted) return;
    setState(() => _scanBusy = false);

    switch (result) {
      case ApiSuccess<ConfirmScanSessionResponse>(data: final data):
        final total = data.results.fold<int>(0, (a, l) => a + l.quantity);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('stock_receipt_scan_success_snackbar'),
            content: Text(
              'Ingreso confirmado: $total u. en ${data.results.length} producto(s).',
            ),
          ),
        );
        _resetScanSession();
      case ApiFailure<ConfirmScanSessionResponse>(error: final e):
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

  void _onModeChanged(_StockReceiptMode mode) {
    if (mode == _mode) return;
    if (_mode == _StockReceiptMode.scan) {
      unawaited(_cancelScanSession());
    }
    setState(() => _mode = mode);
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
        title: const Text('Companion WiFi — Ingreso'),
        content: SizedBox(
          width: 320,
          child: SingleChildScrollView(
            child: CompanionQrPanel(
              composition: widget.composition,
              mode: CompanionMode.receiptScan,
              qrKey: const Key('companion_qr_receipt'),
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
            key: const Key('stock_receipt_mode_manual'),
            onPressed: () => _onModeChanged(_StockReceiptMode.manual),
            style: FilledButton.styleFrom(
              backgroundColor: _mode == _StockReceiptMode.manual
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : null,
            ),
            child: const Text('Manual'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilledButton.tonal(
            key: const Key('stock_receipt_mode_scan'),
            onPressed: () => _onModeChanged(_StockReceiptMode.scan),
            style: FilledButton.styleFrom(
              backgroundColor: _mode == _StockReceiptMode.scan
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : null,
            ),
            child: const Text('Por escaneo'),
          ),
        ),
      ],
    );
  }

  Widget _buildManualBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const Key('stock_receipt_search_field'),
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Buscar producto',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _search,
            ),
          ),
          onSubmitted: (_) => _search(),
        ),
        if (_loading) const LinearProgressIndicator(),
        if (_searchResults.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final p = _searchResults[index];
                return ListTile(
                  key: Key('stock_receipt_pick_${p.id}'),
                  title: Text(p.name),
                  subtitle: Text('Stock ${p.stock}'),
                  onTap: () => _selectProduct(p),
                );
              },
            ),
          ),
        if (_selectedProductName != null)
          Text(
            key: const Key('stock_receipt_selected_label'),
            'Producto: $_selectedProductName (stock $_selectedStock)',
          ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('stock_receipt_quantity_field'),
          controller: _quantityController,
          decoration: const InputDecoration(
            labelText: 'Cantidad',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('stock_receipt_guide_field'),
          controller: _guideController,
          decoration: const InputDecoration(
            labelText: 'Guía',
            border: OutlineInputBorder(),
          ),
          enabled: _scanSessionId == null || _mode == _StockReceiptMode.manual,
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('stock_receipt_lot_ref_field'),
          controller: _lotController,
          decoration: const InputDecoration(
            labelText: 'Lote',
            border: OutlineInputBorder(),
          ),
          enabled: _scanSessionId == null || _mode == _StockReceiptMode.manual,
        ),
        const SizedBox(height: 24),
        FilledButton(
          key: const Key('stock_receipt_submit_button'),
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Registrar ingreso'),
        ),
      ],
    );
  }

  Widget _buildScanBody() {
    final sessionActive = _scanSessionId != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const Key('stock_receipt_guide_field'),
          controller: _guideController,
          decoration: const InputDecoration(
            labelText: 'Guía',
            border: OutlineInputBorder(),
          ),
          enabled: !sessionActive,
        ),
        const SizedBox(height: 12),
        TextField(
          key: const Key('stock_receipt_lot_ref_field'),
          controller: _lotController,
          decoration: const InputDecoration(
            labelText: 'Lote',
            border: OutlineInputBorder(),
          ),
          enabled: !sessionActive,
        ),
        const SizedBox(height: 12),
        if (!sessionActive) ...[
          if (widget.composition.companionLanServer != null)
            TextButton.icon(
              key: const Key('companion_qr_receipt'),
              onPressed: _openCompanionQr,
              icon: const Icon(Icons.qr_code),
              label: const Text('QR companion WiFi'),
            ),
          const SizedBox(height: 8),
          FilledButton(
            key: const Key('stock_receipt_scan_start_button'),
            onPressed: _scanBusy ? null : _startScanSession,
            child: const Text('Iniciar sesión de escaneo'),
          ),
        ]
        else ...[
          TextField(
            key: const Key('stock_receipt_scan_code_field'),
            controller: _scanCodeController,
            decoration: const InputDecoration(
              labelText: 'Código escaneado',
              border: OutlineInputBorder(),
            ),
            onSubmitted: _recordScanCode,
          ),
          const SizedBox(height: 8),
          if (_scanLines.isEmpty)
            const Text('Escaneé productos para armar el ingreso.')
          else
            ListView.builder(
              key: const Key('stock_receipt_scan_lines'),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _scanLines.length,
              itemBuilder: (context, index) {
                final line = _scanLines[index];
                return ListTile(
                  title: Text(line.productName),
                  trailing: Text('×${line.quantity}'),
                );
              },
            ),
          const SizedBox(height: 12),
          FilledButton(
            key: const Key('stock_receipt_scan_confirm_button'),
            onPressed: _scanBusy ? null : _confirmScanSession,
            child: const Text('Confirmar ingreso'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            key: const Key('stock_receipt_scan_cancel_button'),
            onPressed: _scanBusy ? null : _cancelScanSession,
            child: const Text('Cancelar sesión'),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingreso existencias')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.composition.companionLanServer != null)
                CompanionLanStatusChip(composition: widget.composition),
              _buildModeSelector(),
              const SizedBox(height: 16),
              if (_mode == _StockReceiptMode.manual)
                _buildManualBody()
              else
                _buildScanBody(),
            ],
          ),
        ),
      ),
    );
  }
}