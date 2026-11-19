import 'package:core/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../di/pos_composition.dart';

class ProductCreateScreen extends StatefulWidget {
  const ProductCreateScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<ProductCreateScreen> createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: '0');
  final _barcodeController = TextEditingController();
  bool _submitting = false;
  String? _createdQrPayload;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _snack('Ingrese el nombre del producto.');
      return;
    }
    final price = int.tryParse(_priceController.text.trim());
    if (price == null || price <= 0) {
      _snack('Ingrese un precio de venta mayor a cero.');
      return;
    }
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;
    if (stock < 0) {
      _snack('El stock inicial no puede ser negativo.');
      return;
    }
    final barcodeRaw = _barcodeController.text.trim();
    final barcode = barcodeRaw.isEmpty ? null : barcodeRaw;

    setState(() => _submitting = true);
    final result = await widget.composition.productService.createProduct(
      widget.composition.requireStoreId,
      CreateProductRequest(
        name: name,
        salePriceClp: price,
        initialStock: stock,
        barcode: barcode,
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case ApiSuccess<ProductResponse>(data: final data):
        setState(() => _createdQrPayload = data.qrPayload);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('product_create_success_snackbar'),
            content: Text('Producto creado: ${data.name} (stock ${data.stock}).'),
          ),
        );
        if (Navigator.of(context).canPop() && data.qrPayload == null) {
          Navigator.of(context).pop(true);
        } else if (!Navigator.of(context).canPop()) {
          _nameController.clear();
          _priceController.clear();
          _stockController.text = '0';
          _barcodeController.clear();
        }
      case ApiFailure<ProductResponse>(error: final e):
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
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo producto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('product_create_name_field'),
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('product_create_price_field'),
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Precio venta (CLP, IVA incluido)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('product_create_stock_field'),
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'Stock inicial',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('product_create_barcode_field'),
              controller: _barcodeController,
              decoration: const InputDecoration(
                labelText: 'Código de barras (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('product_create_submit_button'),
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar producto'),
            ),
            if (_createdQrPayload case final payload?) ...[
              const SizedBox(height: 24),
              const Text('Código QR del producto'),
              const SizedBox(height: 8),
              Center(
                child: QrImageView(
                  key: const Key('product_qr_image'),
                  data: payload,
                  size: 180,
                ),
              ),
              const SizedBox(height: 8),
              SelectableText(payload),
              if (Navigator.of(context).canPop()) ...[
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Volver'),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}