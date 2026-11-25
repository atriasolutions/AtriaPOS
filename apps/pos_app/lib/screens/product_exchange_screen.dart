import 'package:core/api/api.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../di/pos_composition.dart';

class ProductExchangeScreen extends StatefulWidget {
  const ProductExchangeScreen({
    super.key,
    required this.composition,
    this.initialSaleId,
  });

  final PosComposition composition;
  final String? initialSaleId;

  @override
  State<ProductExchangeScreen> createState() => _ProductExchangeScreenState();
}

class _ProductExchangeScreenState extends State<ProductExchangeScreen> {
  final _saleIdController = TextEditingController();
  final _returnQtyController = TextEditingController();
  final _newQtyController = TextEditingController();
  final _searchController = TextEditingController();
  final _paymentAmountController = TextEditingController();

  SaleProductExchangeContextResponse? _context;
  String? _selectedReturnProductId;
  String? _selectedNewProductId;
  String? _selectedNewProductName;
  int? _selectedNewUnitPrice;
  String _paymentMethod = 'EFECTIVO';
  bool _loading = false;
  bool _submitting = false;
  String? _error;
  List<ProductSearchItem> _searchResults = [];

  @override
  void initState() {
    super.initState();
    final initial = widget.initialSaleId;
    if (initial != null && initial.isNotEmpty) {
      _saleIdController.text = initial;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadContext());
    }
  }

  @override
  void dispose() {
    _saleIdController.dispose();
    _returnQtyController.dispose();
    _newQtyController.dispose();
    _searchController.dispose();
    _paymentAmountController.dispose();
    super.dispose();
  }

  SaleProductExchangeLineDto? get _selectedLine {
    final ctx = _context;
    final id = _selectedReturnProductId;
    if (ctx == null || id == null) return null;
    for (final line in ctx.lines) {
      if (line.productId == id) return line;
    }
    return null;
  }

  int? get _creditClp {
    final line = _selectedLine;
    final qty = int.tryParse(_returnQtyController.text.trim());
    if (line == null || qty == null || qty <= 0) return null;
    return qty * line.unitPriceClp;
  }

  int? get _chargeClp {
    final price = _selectedNewUnitPrice;
    final qty = int.tryParse(_newQtyController.text.trim());
    if (price == null || qty == null || qty <= 0) return null;
    return qty * price;
  }

  int? get _differenceClp {
    final credit = _creditClp;
    final charge = _chargeClp;
    if (credit == null || charge == null) return null;
    return charge - credit;
  }

  Future<void> _loadContext() async {
    final saleId = _saleIdController.text.trim();
    if (saleId.isEmpty) {
      _snack('Ingrese el ID de la venta.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _context = null;
      _selectedReturnProductId = null;
    });
    final result = await widget.composition.saleService
        .getSaleProductExchangeContext(widget.composition.requireStoreId, saleId);
    if (!mounted) return;
    setState(() => _loading = false);
    switch (result) {
      case ApiSuccess<SaleProductExchangeContextResponse>(data: final data):
        setState(() {
          _context = data;
          if (data.dteStatus == DteStatus.emitida.apiValue) {
            _error =
                'Esta venta tiene boleta emitida. Se requiere nota de crédito antes del cambio.';
          }
        });
      case ApiFailure<SaleProductExchangeContextResponse>(error: final e):
        setState(() => _error = e.message);
    }
  }

  Future<void> _searchProducts() async {
    final query = _searchController.text.trim();
    if (query.length < 2) {
      setState(() => _searchResults = []);
      return;
    }
    final result = await widget.composition.productService.searchProducts(
      widget.composition.requireStoreId,
      query,
    );
    if (!mounted) return;
    if (result case ApiSuccess<SearchProductsResponse>(data: final data)) {
      setState(() => _searchResults = data.items);
    }
  }

  void _selectNewProduct(ProductSearchItem product) {
    setState(() {
      _selectedNewProductId = product.id;
      _selectedNewProductName = product.name;
      _selectedNewUnitPrice = product.salePriceClp;
      _searchResults = [];
      _searchController.text = product.name;
      _syncPaymentAmount();
    });
  }

  void _syncPaymentAmount() {
    final diff = _differenceClp;
    if (diff == null) {
      _paymentAmountController.clear();
      return;
    }
    if (diff == 0) {
      _paymentAmountController.clear();
    } else {
      _paymentAmountController.text = '${diff.abs()}';
    }
  }

  void _onReturnProductSelected(String? id) {
    SaleProductExchangeLineDto? line;
    final ctx = _context;
    if (ctx != null && id != null) {
      for (final l in ctx.lines) {
        if (l.productId == id) {
          line = l;
          break;
        }
      }
    }
    setState(() {
      _selectedReturnProductId = id;
      _returnQtyController.text = '1';
      if (line != null && line.availableQuantity == 1) {
        _newQtyController.text = '1';
      } else {
        _newQtyController.clear();
      }
      _syncPaymentAmount();
    });
  }

  bool get _canSubmit {
    final ctx = _context;
    if (ctx == null || ctx.dteStatus == DteStatus.emitida.apiValue) {
      return false;
    }
    final returnId = _selectedReturnProductId;
    final newId = _selectedNewProductId;
    final returnQty = int.tryParse(_returnQtyController.text.trim());
    final newQty = int.tryParse(_newQtyController.text.trim());
    final line = _selectedLine;
    if (returnId == null ||
        newId == null ||
        returnQty == null ||
        newQty == null ||
        line == null) {
      return false;
    }
    if (returnQty <= 0 ||
        returnQty > line.availableQuantity ||
        newQty <= 0) {
      return false;
    }
    final diff = _differenceClp;
    if (diff == null) return false;
    if (diff != 0) {
      final pay = int.tryParse(_paymentAmountController.text.trim());
      if (pay == null || pay != diff.abs()) return false;
    }
    return true;
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final saleId = _context!.saleId;
    final returnQty = int.parse(_returnQtyController.text.trim());
    final newQty = int.parse(_newQtyController.text.trim());
    final diff = _differenceClp!;

    ProductExchangePaymentDto? payment;
    if (diff != 0) {
      payment = ProductExchangePaymentDto(
        method: _paymentMethod,
        amountClp: diff.abs(),
      );
    }

    setState(() => _submitting = true);
    final result = await widget.composition.saleService.registerProductExchange(
      widget.composition.requireStoreId,
      saleId,
      RegisterProductExchangeRequest(
        returnProductId: _selectedReturnProductId!,
        returnQuantity: returnQty,
        newProductId: _selectedNewProductId!,
        newQuantity: newQty,
        differencePayment: payment,
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case ApiSuccess<RegisterProductExchangeResponse>():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            key: Key('product_exchange_success_snackbar'),
            content: Text('Cambio registrado correctamente.'),
          ),
        );
        _returnQtyController.clear();
        _newQtyController.clear();
        _searchController.clear();
        setState(() {
          _selectedNewProductId = null;
          _selectedNewProductName = null;
          _selectedNewUnitPrice = null;
        });
        await _loadContext();
      case ApiFailure<RegisterProductExchangeResponse>(error: final e):
        _snack(e.message);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctx = _context;
    final difference = _differenceClp;
    final blockEmitida = ctx?.dteStatus == DteStatus.emitida.apiValue;

    return Scaffold(
      appBar: AppBar(title: const Text('Cambio mostrador')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('product_exchange_sale_id_field'),
                    controller: _saleIdController,
                    decoration: const InputDecoration(
                      labelText: 'ID venta',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: const Key('product_exchange_load_button'),
                  onPressed: _loading ? null : _loadContext,
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Cargar'),
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                key: const Key('product_exchange_error'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (ctx != null && !blockEmitida) ...[
              const SizedBox(height: 16),
              const Text('Producto devuelto'),
              ...ctx.lines.where((l) => l.availableQuantity > 0).map(
                    (line) => RadioListTile<String>(
                      key: Key('product_exchange_return_${line.productId}'),
                      title: Text(line.productName),
                      subtitle: Text(
                        'Vendidos ${line.quantity} · disponibles ${line.availableQuantity} · \$${line.unitPriceClp} c/u',
                      ),
                      value: line.productId,
                      groupValue: _selectedReturnProductId,
                      onChanged: _onReturnProductSelected,
                    ),
                  ),
              TextField(
                key: const Key('product_exchange_return_qty_field'),
                controller: _returnQtyController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad a devolver',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) {
                  setState(_syncPaymentAmount);
                },
              ),
              const SizedBox(height: 16),
              const Text('Producto nuevo'),
              TextField(
                key: const Key('product_exchange_search_field'),
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar producto',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchProducts,
                  ),
                ),
                onSubmitted: (_) => _searchProducts(),
              ),
              if (_searchResults.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final p = _searchResults[index];
                      return ListTile(
                        key: Key('product_exchange_pick_${p.id}'),
                        title: Text(p.name),
                        subtitle: Text('\$${p.salePriceClp} · stock ${p.stock}'),
                        onTap: () => _selectNewProduct(p),
                      );
                    },
                  ),
                ),
              if (_selectedNewProductName != null)
                Text(
                  key: const Key('product_exchange_new_selected'),
                  'Seleccionado: $_selectedNewProductName',
                ),
              TextField(
                key: const Key('product_exchange_new_qty_field'),
                controller: _newQtyController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad entregada',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) {
                  setState(_syncPaymentAmount);
                },
              ),
              const SizedBox(height: 12),
              if (difference != null)
                Text(
                  key: const Key('product_exchange_preview'),
                  'Crédito \$${_creditClp ?? 0} · Cargo \$${_chargeClp ?? 0} · Diferencia \$${difference >= 0 ? difference : -difference} ${difference > 0 ? "(a cobrar)" : difference < 0 ? "(a devolver)" : ""}',
                ),
              if (difference != null && difference != 0) ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  key: const Key('product_exchange_payment_method'),
                  value: _paymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Medio diferencia',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'EFECTIVO',
                      child: Text('Efectivo'),
                    ),
                    DropdownMenuItem(
                      value: 'OTRO',
                      child: Text('Otro'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _paymentMethod = v);
                  },
                ),
                TextField(
                  key: const Key('product_exchange_payment_amount'),
                  controller: _paymentAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Monto diferencia',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('product_exchange_submit_button'),
                onPressed: _submitting || !_canSubmit ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Confirmar cambio'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}